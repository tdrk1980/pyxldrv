# *-* encoding: utf-8 *-*
import vxlapi as xl
import chardet
import win32event
import time


class Can:
    def __init__(self, *, appName="pyxldrv", appChannel=0, HwType=xl.XL_HWTYPE_VIRTUAL, HwIndex=0, HwChannel=0, rxQueueSize=2^10, busType=xl.XL_BUS_TYPE_CAN, flags=xl.XL_ACTIVATE_RESET_CLOCK, queueLevel=1):
        # set by param
        self.appName        = bytes(appName.encode())
        self.pHwType        = [HwType]
        self.pHwIndex       = [HwIndex]
        self.pHwChannel     = [HwChannel]
        self.busType        = busType
        self.rxQueueSize    = rxQueueSize
        self.flags          = flags
        self.appChannel     = appChannel
        self.queueLevel     = queueLevel

        # internal use
        self.accessMask = 0
        self.portHandle = [0]
        self.permissionMask = [self.accessMask]
        self.xlInterfaceVersion = xl.XL_INTERFACE_VERSION
        self.xlHandle = [0]

        # internal use for error
        self.last_error = xl.XL_SUCCESS

        #
        # Setup Driver. see 4.2 Flowchart in XL Driver Library - Description.pdf
        #
        status = xl.OpenDriver()
        if status != xl.XL_SUCCESS:
            self.last_error = status

        status = xl.SetApplConfig(self.appName, self.appChannel, self.pHwType, self.pHwIndex, self.pHwChannel, self.busType)
        if status != xl.XL_SUCCESS:
            # t.b.d logging warning
            self.last_error = status

        xl.GetApplConfig(self.appName, self.appChannel, self.pHwType, self.pHwIndex, self.pHwChannel, self.busType)
        if status != xl.XL_SUCCESS:
            # t.b.d logging warning
            self.last_error = status

        # accessMask soulde be OR(|=). but in this case, OR(|=) has little meaning.
        self.accessMask |= xl.GetChannelMask(self.pHwType[0],self.pHwIndex[0],self.pHwChannel[0])
        if self.accessMask  == 0:
            # t.b.d logging warning
            pass

        # permissionMask should be same as accessMask
        self.permissionMask = [self.accessMask]
        status = xl.OpenPort(self.portHandle, self.appName, self.accessMask, self.permissionMask, self.rxQueueSize, self.xlInterfaceVersion, self.busType)
        if status != xl.XL_SUCCESS:
            # t.b.d logging warning
            self.last_error = status

        # check permissionMask. it should be same as accessMask
        if self.accessMask != self.permissionMask[0]:
            # t.b.d logging warning
            # xlCANdemo.c
            pass
        elif self.permissionMask[0] == 0:
            # t.b.d logging warning
            pass

        # check portHandle[0]
        if self.portHandle[0] == 0 or xl.XL_INVALID_PORTHANDLE:
            # t.b.d logging warning
            pass

        status = xl.ActivateChannel(self.portHandle[0], self.accessMask, self.busType, self.flags)
        if status != xl.XL_SUCCESS:
            # t.b.d logging warning
            self.last_error = status

        status = xl.SetNotification(self.portHandle[0], self.xlHandle, self.queueLevel )
        if status != xl.XL_SUCCESS:
            # t.b.d logging warning
            self.last_error = status

    def __del__(self):
        #
        # tearDown Driver. see 4.2 Flowchart in XL Driver Library - Description.pdf
        #
        status = xl.DeactivateChannel(self.portHandle[0], self.accessMask)
        if status != xl.XL_SUCCESS:
            # t.b.d logging warning
            pass

        status = xl.ClosePort(self.portHandle[0])
        if status != xl.XL_SUCCESS:
            # t.b.d logging warning
            pass

        status = xl.CloseDriver()
        if status != xl.XL_SUCCESS:
            # t.b.d logging warning
            pass

    def send(self,*, id, data, flags=None, dlc=None):
        ret = True
        msgs = [{"flags":0, "id":id, "dlc":len(data), "data":bytearray(data)}]
        messageCount = [len(msgs)]

        status = xl.CanTransmit(self.portHandle[0], self.accessMask, messageCount, msgs)
        if status != xl.XL_SUCCESS:
            self.last_error = status
            ret = False
        return ret

    def _recv_nonblock(self):
        pEventCount = [1]
        pEventList = [{}]
        status = xl.Receive(self.portHandle[0], pEventCount, pEventList)
        return (status, pEventList[0])

    def recv(self, *, timeout_sec=-1, t_WaitForSingleObject_msec=100):
        ret = False
        can_id = None
        dlc    = None
        data   = []
        start = time.time()
        while True:
            
            if timeout_sec < 0:
                # wait forever
                pass
            if timeout_sec == 0:
                # non_block
                pass
            elif timeout_sec > 0:
                # with timeout
                elapsed = time.time() - start
                if elapsed > (timeout_sec * 1000):
                    break
            ret_win32 = win32event.WaitForSingleObject(self.xlHandle[0], t_WaitForSingleObject_msec)
            if ret_win32 == win32event.WAIT_OBJECT_0:
                # rx msg event occured
                status, xlevent = can._recv_nonblock()
                if status == xl.XL_SUCCESS:
                    if xlevent["tag"] == xl.XL_RECEIVE_MSG:
                        msg_flags = xlevent["tagData"]["msg"]["flags"]
                        if msg_flags == 0:
                            can_id = xlevent["tagData"]["msg"]["id"]
                            dlc    = xlevent["tagData"]["msg"]["dlc"]
                            data   = xlevent["tagData"]["msg"]["data"]
                            ret = True
                            break
                        else:
                            # self._parse_msg_flags(msg_flags)
                            pass
                else:
                    # self.last_error = status
                    pass

            elif ret_win32 == win32event.WAIT_TIMEOUT:
                pass
            else:
                # e.g. ret_win32 == win32event.WAIT_ABANDONED:
                break
        return (ret, can_id, dlc, data)

    def get_last_error(self):
        return self._decode_bin(xl.GetErrorString(self.last_error))

    def _decode_bin(self,bin):
        return bin.decode(chardet.detect(bin)["encoding"])

    def _parse_msg_flags(self, msg_flags):
        #define XL_CAN_MSG_FLAG_ERROR_FRAME   0x01
        #define XL_CAN_MSG_FLAG_OVERRUN       0x02           //!< Overrun in Driver or CAN Controller, previous msgs have been lost.
        #define XL_CAN_MSG_FLAG_NERR          0x04           //!< Line Error on Lowspeed
        #define XL_CAN_MSG_FLAG_WAKEUP        0x08           //!< High Voltage Message on Single Wire CAN
        #define XL_CAN_MSG_FLAG_REMOTE_FRAME  0x10
        #define XL_CAN_MSG_FLAG_RESERVED_1    0x20
        #define XL_CAN_MSG_FLAG_TX_COMPLETED  0x40           //!< Message Transmitted
        #define XL_CAN_MSG_FLAG_TX_REQUEST    0x80           //!< Transmit Message stored into Controller
        #define XL_CAN_MSG_FLAG_SRR_BIT_DOM 0x0200           //!< SRR bit in CAN message is dominant

        # for logging
        if msg_flags & xl.XL_CAN_MSG_FLAG_ERROR_FRAME:
            pass
        if msg_flags & xl.XL_CAN_MSG_FLAG_NERR:
            pass
        if msg_flags & xl.XL_CAN_MSG_FLAG_WAKEUP:
            pass
        if msg_flags & xl.XL_CAN_MSG_FLAG_REMOTE_FRAME:
            pass
        if msg_flags & xl.XL_CAN_MSG_FLAG_RESERVED_1:
            pass
        if msg_flags & xl.XL_CAN_MSG_FLAG_TX_COMPLETED:
            pass
        if msg_flags & xl.XL_CAN_MSG_FLAG_TX_REQUEST:
            pass
        if msg_flags & xl.XL_CAN_MSG_FLAG_SRR_BIT_DOM:
            pass
        
if __name__ == "__main__":
    import time
    # xl.PopupHwConfig()
    # ex = Example() # if you would lie to use XL_HWTYPE_VIRTUAL

    can = Can()

    if False:
        data=[0x12]*8
        status = 0
        messageCount = 0
        for c in range(0x100):
            status, _ = can.send(id=0x0, data=data)
            messageCount=messageCount+1
        print(status,messageCount)


        test_burst_send = True
        if test_burst_send:
            # XL_ERR_QUEUE_IS_FULL might occur with real hadware interface. Can.send() might be enough for you.
            msgs = [{"flags":0, "id":0x1, "dlc":len(data), "data":bytearray(data)}] * 0x100
            status,messageCount = can.burst_send(msgs=msgs)
            print(len(msgs), status, messageCount)
            #=> 256 11 [103] --> 11:XL_ERR_QUEUE_IS_FULL  @ XL_HWTYPE_CANCASEXL
            #=> 256 0 [256] @ XL_HWTYPE_VIRTUAL


    ret = can.send(id=0x0, data=[0])
    start = time.time()
    ret, can_id, dlc, data = can.recv(timeout_sec=1)
    elapsed_time = time.time() - start


    test_receive_non_block = False
    if test_receive_non_block:
        print("receive test")

        start = time.time()
        cycle_num = 1_000_000

        elapsed_time = time.time() - start
        print(f"receive {cycle_num} times => " + str(elapsed_time) + "[msec]")

    print(can.get_last_error_string())