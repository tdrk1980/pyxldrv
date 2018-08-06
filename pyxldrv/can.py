# *-* encoding: utf-8 *-*
import vxlapi as xl
import chardet
import win32event


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

    def send(self,*, id, data, flags=None,dlc=None):

        msgs = [{"flags":0, "id":id, "dlc":len(data), "data":bytearray(data)}]
        messageCount = [len(msgs)]

        status = xl.CanTransmit(self.portHandle[0], self.accessMask, messageCount, msgs)
        if status != xl.XL_SUCCESS:
            self.last_error = status
        return (status, messageCount)

    def recv_nonblock(self):
        pEventCount = [1]
        pEventList = [{}]
        status = xl.Receive(self.portHandle[0],pEventCount, pEventList)
        if status != (xl.XL_SUCCESS or xl.XL_ERR_QUEUE_IS_EMPTY):
            self.last_error = status
        return (status, pEventList[0])

    def recv(self, *, milliseconds=1000):
        print("recv_wait start")
        ret = win32event.WaitForSingleObject(self.xlHandle[0], milliseconds)
        if ret == win32event.WAIT_OBJECT_0:
            print("win32event.WAIT_OBJECT_0")
        if ret == win32event.WAIT_ABANDONED:
            print("win32event.WAIT_ABANDONED")
        if ret == win32event.WAIT_TIMEOUT:
            print("win32event.WAIT_TIMEOUT")
        print("recv_wait end")
        return ret

    def burst_send(self, *, msgs):
        messageCount = [len(msgs)]
        status = xl.CanTransmit(self.portHandle[0], self.accessMask, messageCount, msgs)
        return (status, messageCount)

    def decode_bin(self,bin):
        return bin.decode(chardet.detect(bin)["encoding"])

    def get_last_error_string(self):
        return self.decode_bin(xl.GetErrorString(self.last_error))

if __name__ == "__main__":
    import time
    # xl.PopupHwConfig()
    # ex = Example() # if you would lie to use XL_HWTYPE_VIRTUAL

    can = Can()

    if True:
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


    start = time.time()
    ret = can.recv(milliseconds=1000)
    elapsed_time = time.time() - start


    test_receive_non_block = False
    if test_receive_non_block:
        print("receive test")

        start = time.time()
        cycle_num = 1_000_000
        for i in range(cycle_num):
            status, xlevent = can.recv_nonblock()
            if xlevent["tag"] == xl.XL_RECEIVE_MSG:
                msg_flags = xlevent["tagData"]["msg"]["flags"]
                if msg_flags == 0:
                    data = xlevent["tagData"]["msg"]["data"]
                    can_id = xlevent["tagData"]["msg"]["id"]
                    # print(f"{status}, {can_id:03x}, {data}") 
                elif msg_flags & (xl.XL_CAN_MSG_FLAG_TX_COMPLETED|xl.XL_CAN_MSG_FLAG_TX_REQUEST):
                    # print("tx completed or request = 0x{:02x}".format(xlevent["tagData"]["msg"]["flags"]))
                    pass
                else:
                    print("overrun??", xlevent["tagData"]["msg"]["flags"])
        elapsed_time = time.time() - start
        print(f"receive {cycle_num} times => " + str(elapsed_time) + "[msec]")

    print(can.get_last_error_string())