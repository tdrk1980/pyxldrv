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
            pass# *-* encoding: utf-8 *-*
import vxlapi as xl
import chardet
from concurrent.futures import ThreadPoolExecutor
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

        status = xl.ClosePort(self.portHandle[0])
        if status != xl.XL_SUCCESS:
            # t.b.d logging warning
            pass

        status = xl.CloseDriver()
        if status != xl.XL_SUCCESS:
            # t.b.d logging warning
            pass

    def send(self,*, can_id, data, flags=None, dlc=None):
        ret = True
        msgs = [{"flags":0, "id":can_id, "dlc":len(data), "data":bytearray(data)}]
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

    def recv(self, *, timeout_sec=-1, t_WaitForSingleObject_msec=10):
        start = time.time()
        elapsed = 0
        while True:
            ret = False
            time_stamp = 0
            can_id = None
            dlc    = None
            data   = []
            if timeout_sec < 0:
                # wait forever
                pass
            if timeout_sec == 0:
                # non_block
                pass
            elif timeout_sec > 0:
                # with timeout
                elapsed = time.time() - start
                if elapsed > (timeout_sec):
                    break
            ret_win32 = win32event.WaitForSingleObject(self.xlHandle[0], t_WaitForSingleObject_msec)
            # http://chokuto.ifdef.jp/advanced/function/WaitForSingleObject.html
            # 0x00000000 (WAIT_OBJECT_0) オブジェクトがシグナル状態になったことを示します。
            # 0x00000080 (WAIT_ABANDONED) 指定されたオブジェクトがミューテックスオブジェクトであり、それを所有していたスレッドが終了する前にミューテックスオブジェクトが解放されなかったことを示します。ミューテックスオブジェクトの所有権は呼び出し側スレッドに与えられ、ミューテックスは非シグナル状態に設定されます。ミューテックスが永続的な状態情報を保護している場合には、整合性を保つためにこの戻り値を確認すべきです。
            # 0x00000102 (WAIT_TIMEOUT) タイムアウト時間が経過したことを示します。
            # 0xFFFFFFFF (WAIT_FAILED) エラーが発生したことを示します。拡張エラー情報を取得するには、GetLastError関数を使います。
            if ret_win32 == win32event.WAIT_OBJECT_0:
                # rx msg event occured
                status, xlevent = self._recv_nonblock()
                if status == xl.XL_SUCCESS:
                    if xlevent["tag"] == xl.XL_RECEIVE_MSG:
                        msg_flags = xlevent["tagData"]["msg"]["flags"]
                        if msg_flags == 0:
                            time_stamp = xlevent["timeStamp"] / 1_000_000_000 # unit conversion from nanoseconds to seconds.
                            can_id = xlevent["tagData"]["msg"]["id"]
                            dlc    = xlevent["tagData"]["msg"]["dlc"]
                            data   = xlevent["tagData"]["msg"]["data"]
                            ret = True
                            break
                        else:
                            self._parse_msg_flags(msg_flags)
                            pass
                else:
                    print("waht")
                    # status is not xl.XL_SUCCESS:
                    # self.last_error = status
                    pass
            elif ret_win32 == win32event.WAIT_TIMEOUT:
                pass
            else:
                # e.g. ret_win32 == win32event.WAIT_ABANDONED:
                break
        return (ret, time_stamp, can_id, dlc, data)

    def get_last_error(self):
        return self._decode_bin(xl.GetErrorString(self.last_error))

    def _decode_bin(self,bin):
        return bin.decode(chardet.detect(bin)["encoding"])

    def _parse_msg_flags(self, msg_flags):
        # for logging
        #define XL_CAN_MSG_FLAG_ERROR_FRAME   0x01
        if msg_flags & xl.XL_CAN_MSG_FLAG_ERROR_FRAME:
            print(f"XL_CAN_MSG_FLAG_ERROR_FRAME msg_flags=0x{msg_flags:04x}")
        #define XL_CAN_MSG_FLAG_OVERRUN       0x02           //!< Overrun in Driver or CAN Controller, previous msgs have been lost.
        if msg_flags & xl.XL_CAN_MSG_FLAG_OVERRUN:
            print(f"XL_CAN_MSG_FLAG_OVERRUN msg_flags=0x{msg_flags:04x}")
        #define XL_CAN_MSG_FLAG_NERR          0x04           //!< Line Error on Lowspeed
        if msg_flags & xl.XL_CAN_MSG_FLAG_NERR:
            print(f"XL_CAN_MSG_FLAG_NERR msg_flags=0x{msg_flags:04x}")
        #define XL_CAN_MSG_FLAG_WAKEUP        0x08           //!< High Voltage Message on Single Wire CAN
        if msg_flags & xl.XL_CAN_MSG_FLAG_WAKEUP:
            print(f"XL_CAN_MSG_FLAG_WAKEUP msg_flags=0x{msg_flags:04x}")
        #define XL_CAN_MSG_FLAG_REMOTE_FRAME  0x10
        if msg_flags & xl.XL_CAN_MSG_FLAG_REMOTE_FRAME:
            print(f"XL_CAN_MSG_FLAG_REMOTE_FRAME msg_flags=0x{msg_flags:04x}")
        #define XL_CAN_MSG_FLAG_RESERVED_1    0x20
        if msg_flags & xl.XL_CAN_MSG_FLAG_RESERVED_1:
            print(f"XL_CAN_MSG_FLAG_RESERVED_1 msg_flags=0x{msg_flags:04x}")
        #define XL_CAN_MSG_FLAG_TX_COMPLETED  0x40           //!< Message Transmitted
        if msg_flags & xl.XL_CAN_MSG_FLAG_TX_COMPLETED:
            print(f"XL_CAN_MSG_FLAG_TX_COMPLETED msg_flags=0x{msg_flags:04x}")
        #define XL_CAN_MSG_FLAG_TX_REQUEST    0x80           //!< Transmit Message stored into Controller
        if msg_flags & xl.XL_CAN_MSG_FLAG_TX_REQUEST:
            print(f"XL_CAN_MSG_FLAG_TX_REQUEST msg_flags=0x{msg_flags:04x}")
        #define XL_CAN_MSG_FLAG_SRR_BIT_DOM 0x0200           //!< SRR bit in CAN message is dominant
        if msg_flags & xl.XL_CAN_MSG_FLAG_SRR_BIT_DOM:
            print(f"XL_CAN_MSG_FLAG_SRR_BIT_DOM msg_flags=0x{msg_flags:04x}")
        return

if __name__ == "__main__":
    import time
    # xl.PopupHwConfig()

    # 受信スレッドを上げて置く
    def recv_task():
        can = Can()
        while True:
            ret, timestamp, can_id, dlc, data = can.recv(timeout_sec=2)
            if ret == True:
                print(f"{timestamp} ID:0x{can_id:03x} Data:{data[0]}")
            else:
                print("exit")
                break
        return True

    executor = ThreadPoolExecutor(max_workers=1)
    executor.submit(recv_task)

    time.sleep(0.1)
    c = Can()

    can_id=0x5

    signals = 0x0
    c.send(can_id=can_id, data=[signals])
    time.sleep(0.01)

    signals |= 0x1
    c.send(can_id=can_id, data=[signals])

    signals |= 0x2
    c.send(can_id=can_id, data=[signals])


