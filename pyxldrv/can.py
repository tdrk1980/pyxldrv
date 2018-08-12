# *-* encoding: utf-8 *-*
import vxlapi as xl
import chardet
import win32event
import time

from logging import getLogger, DEBUG, NullHandler, StreamHandler, FileHandler
logger = getLogger(__name__)
logger.setLevel(DEBUG)
logger.addHandler(NullHandler())
logger.propagate = False

def decode_bin(bin):
    return bin.decode(chardet.detect(bin)["encoding"])

def get_can_bus_params(hwType, hwIndex, hwChannel, busType):
    driverConfig = {}
    xl.GetDriverConfig(driverConfig)
    can_bus_params = None
    for ch in driverConfig["channel"]:
        if (ch["hwType"] == hwType and ch["hwIndex"] == hwIndex and ch["hwChannel"] == hwChannel):
            if ch["busParams"]["busType"] == busType:
                can_bus_params = ch["busParams"]["data"]["can"]
                can_bus_params["name"] = decode_bin(ch["name"])
                can_bus_params["hwType"] = ch["hwType"]
                can_bus_params["hwIndex"] = ch["hwIndex"]
                can_bus_params["hwChannel"] = ch["hwChannel"]
    return can_bus_params

def print_can_networks():
    driverConfig = {}
    xl.GetDriverConfig(driverConfig)
    for ch in driverConfig["channel"]:
        if ch["busParams"]["busType"] == xl.XL_BUS_TYPE_CAN:
            name = decode_bin(ch["name"])
            print(f"name      : {name}")
            hwType=ch["hwType"]
            print(f"hwType    : {hwType}")
            hwIndex=ch["hwIndex"]
            print(f"hwIndex   : {hwIndex}")
            hwChannel = ch["hwChannel"]
            print(f"hwChannel : {hwChannel}")
            bitRate = ch["busParams"]["data"]["can"]["bitRate"]
            print(f"bitRate   : {bitRate//1000} kbps")
            print()
class Can:
    def __init__(self, *, appName="pyxldrv", appChannel=0, HwType=xl.XL_HWTYPE_VIRTUAL, HwIndex=0, HwChannel=0, rxQueueSize=2**10, busType=xl.XL_BUS_TYPE_CAN, flags=xl.XL_ACTIVATE_RESET_CLOCK, queueLevel=1, logger=logger):
        self.log = logger
        self.log.debug(f"[{self.__class__.__name__:8}][{self.__init__.__name__:8}] new instance.  appName:{appName}, appChannel:{appChannel}, HwType:{HwType}, HwIndex:{HwIndex}, HwChannel:{HwChannel}, rxQueueSize:{rxQueueSize}, busType:{busType}, flags:{flags}")

        # set by param
        self.appName        = appName
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
        # Setup Driver. see 4.2 Flowchart in "XL Driver Library - Description.pdf"
        #
        status = xl.OpenDriver()
        if status != xl.XL_SUCCESS:
            self.log.error(f"[{self.appName:8}][{self.__init__.__name__:8}] !! OpenDriver() returned {status} !!")

        status = xl.SetApplConfig(bytes(self.appName.encode()), self.appChannel, self.pHwType, self.pHwIndex, self.pHwChannel, self.busType)
        if status != xl.XL_SUCCESS:
            self.log.debug(f"[{self.appName:8}][{self.__init__.__name__:8}] SetApplConfig returned {status}.  appName:{self.appName}, appChannel:{self.appChannel}, pHwType:{self.pHwType}, pHwIndex:{self.pHwIndex}, pHwChannel:{self.pHwChannel}, busType:{self.busType}")

        status = xl.GetApplConfig(bytes(self.appName.encode()), self.appChannel, self.pHwType, self.pHwIndex, self.pHwChannel, self.busType)
        if status != xl.XL_SUCCESS:
            self.log.debug(f"[{self.appName:8}][{self.__init__.__name__:8}] GetApplConfig returned {status}.  appName:{self.appName}, appChannel:{self.appChannel}, pHwType:{self.pHwType}, pHwIndex:{self.pHwIndex}, pHwChannel:{self.pHwChannel}, busType:{self.busType}")

        # accessMask should be OR(|=), if multi-HwChannels are used. (In this case, OR(|=) has little meaning.)
        self.accessMask |= xl.GetChannelMask(self.pHwType[0],self.pHwIndex[0],self.pHwChannel[0])
        if self.accessMask == 0:
            self.log.error(f"[{self.appName:8}][{self.__init__.__name__:8}]!! GetChannelMask returned accessMask={self.accessMask}!!  pHwType:{self.pHwType}, pHwIndex:{self.pHwIndex}, pHwChannel:{self.pHwChannel}")

        # permissionMask should be same as accessMask at when OpenPort timing.
        self.permissionMask = [self.accessMask]
        status = xl.OpenPort(self.portHandle, bytes(self.appName.encode()), self.accessMask, self.permissionMask, self.rxQueueSize, self.xlInterfaceVersion, self.busType)
        if status != xl.XL_SUCCESS:
            self.log.error(f"[{self.appName:8}][{self.__init__.__name__:8}]!! OpenPort returned {status} !!  portHandle:{self.portHandle}, appName:{self.appName}, accessMask:{self.accessMask}, permissionMask:{self.permissionMask}, rxQueueSize:{self.rxQueueSize}, xlInterfaceVersion:{self.xlInterfaceVersion}, busType:{self.busType}")

        # check permissionMask for logging. see 3.2.9 xlOpenPort in "XL Driver Library - Description.pdf"
        if self.permissionMask[0] == 0:
            self.log.debug(f"[{self.appName:8}][{self.__init__.__name__:8}] permissionMask({self.permissionMask[0]}) is 0. If this is not init access for CANs, this is no issue.")

        # check portHandle for logging.
        if self.portHandle[0] == xl.XL_INVALID_PORTHANDLE:
            self.log.error(f"[{self.appName:8}][{self.__init__.__name__:8}]!! portHandle({self.portHandle[0]}) is XL_INVALID_PORTHANDLE !!")

        status = xl.ActivateChannel(self.portHandle[0], self.accessMask, self.busType, self.flags)
        if status != xl.XL_SUCCESS:
            self.log.debug(f"[{self.appName:8}][{self.__init__.__name__:8}] ActivateChannel returned {status}.  portHandle:{self.portHandle}, accessMask:{self.accessMask}, busType:{self.busType}, flags:{self.flags}")

        status = xl.SetNotification(self.portHandle[0], self.xlHandle, self.queueLevel )
        if status != xl.XL_SUCCESS:
            self.log.debug(f"[{self.appName:8}][{self.__init__.__name__:8}] SetNotification returned {status}.  portHandle:{self.portHandle}, xlHandle:{self.xlHandle}, queueLevel:{self.queueLevel}")

    def __del__(self):
        #
        # tearDown Driver. see 4.2 Flowchart in XL Driver Library - Description.pdf
        #
        status = xl.DeactivateChannel(self.portHandle[0], self.accessMask)
        if status != xl.XL_SUCCESS:
            self.log.debug(f"[{self.appName:8}][{self.__del__.__name__:8}] DeactivateChannel returned {status}.  portHandle:{self.portHandle}, accessMask:{self.accessMask}")

        status = xl.ClosePort(self.portHandle[0])
        if status != xl.XL_SUCCESS:
            self.log.debug(f"[{self.appName:8}][{self.__del__.__name__:8}] ClosePort returned {status}.  portHandle:{self.portHandle}")

        status = xl.CloseDriver()
        if status != xl.XL_SUCCESS:
            self.log.debug(f"[{self.appName:8}][{self.__del__.__name__:8}] CloseDriver returned {status}")


    def send(self, *, can_id, data, user_flags=0, user_dlc=None):
        ret = True

        # dlc must be 0-8, even if user_dlc is not 0-8.
        dlc = None
        if  user_dlc:
            if user_dlc <= 8:
                dlc = user_dlc
            else:
                self.log.warn(f"[{self.appName:8}][{self.send.__name__:8}] user_dlc({user_dlc}) is ignored.")
        
        # if dlc is not determined by user_dlc, it is estimated by len(data).
        if dlc is None:
            if len(data) <= 8:
                dlc = len(data)
            else:
                self.log.warn(f"[{self.appName:8}][{self.send.__name__:8}] len(data)({len(data)}) is over 8. dlc is changed into 8.")
                dlc = 8

        # the size of data is 0-8byte.
        data_buf = [0]*8
        for i in range(dlc):
            data_buf[i] = data[i]

        # flags
        flags = user_flags

        msgs = [{"flags":flags, "id":can_id, "dlc":dlc, "data":bytearray(data_buf)}]
        messageCount = [len(msgs)]

        status = xl.CanTransmit(self.portHandle[0], self.accessMask, messageCount, msgs)
        if status != xl.XL_SUCCESS:
            self.log.error(f"[{self.appName:8}][{self.send.__name__:8}]!! CanTransmit retruns {status} !!")
            ret = False
        return ret

    def _recv_nonblock(self):
        pEventCount = [1]
        pEventList = [{}]
        pEventString = [b""]
        status = xl.Receive(self.portHandle[0], pEventCount, pEventList, pEventString)
        return (status, pEventList[0], pEventString[0])

    def recv(self, *, timeout_sec=3, t_WaitForSingleObject_msec=300):
        start_sec = time.time()
        elapsed_sec = 0
        
        while True:
            ret     = False
            msg_flags = 0
            timestamp = 0
            ch      = None
            can_id  = None
            dlc     = None
            data    = []
            
            # wait for the signal from vector xl driver
            self.debug(self.recv, f"call WaitForSingleObject. xlHandle:{self.xlHandle[0]}, t_WaitForSingleObject_msec:{t_WaitForSingleObject_msec} msec")
            ret_win32 = win32event.WaitForSingleObject(self.xlHandle[0], t_WaitForSingleObject_msec)

            if ret_win32 == win32event.WAIT_OBJECT_0:
                self.debug(self.recv, f"WaitForSingleObject returned WAIT_OBJECT_0(xlHandle was signaled correctly).")
                
                # get the event which signals the xHandle via _recv_nonblock->xlReceive.
                status, xlevent, xlevstr = self._recv_nonblock()

                # analysis of the event
                if status == xl.XL_SUCCESS:
                    xlevent_tag = xlevent["tag"]
                    if xlevent_tag == xl.XL_RECEIVE_MSG: # Normal case : the event was rx msg(exected event).
                        msg_flags = xlevent["tagData"]["msg"]["flags"]
                        if (msg_flags == 0) or (msg_flags & xl.XL_CAN_MSG_FLAG_ERROR_FRAME): # Normal case : valid receive message or error frame was received.
                            ret = True
                            msg_flags   = msg_flags
                            timestamp   = xlevent["timeStamp"] / 1_000_000_000 # unit conversion from nanoseconds to seconds.
                            ch          = xlevent["chanIndex"]
                            can_id      = xlevent["tagData"]["msg"]["id"]
                            dlc         = xlevent["tagData"]["msg"]["dlc"]
                            data        = xlevent["tagData"]["msg"]["data"][:dlc]
                            break # loop end normally (ret = True)

                    # logging unhandled event.
                    self.debug(self.recv, f"{self._decode_bin(xlevstr)}")
                else:
                    # status != xl.XL_SUCCESS
                    self.warn(self.recv, f"! _recv_nonblock retruns {self._decode_bin(xl.GetErrorString(status))} !")
            elif ret_win32 == win32event.WAIT_TIMEOUT:
                # continue recv() loop 
                self.debug(self.recv, f"WaitForSingleObject returned WAIT_TIMEOUT. xlHandle:{self.xlHandle[0]}, t_WaitForSingleObject_msec:{t_WaitForSingleObject_msec} msec")
            else:
                # critical errors. this loop must be finished.
                if ret_win32 == win32event.WAIT_ABANDONED:
                    # xlHandle might be no longer valid. 
                    self.critical(self.recv, f"!! break recv() loop (ret = False). WaitForSingleObject returned WAIT_ABANDONED. xlHandle:{self.xlHandle[0]}, t_WaitForSingleObject_msec:{t_WaitForSingleObject_msec} msec")
                    break
                elif ret_win32 == win32event.WAIT_FAILED:
                    # win32api error occured. to get extra info, GetLastError should be used. 
                    self.critical(self.recv, f"!! break recv() loop (ret = False). WaitForSingleObject returned WAIT_FAILED. xlHandle:{self.xlHandle[0]}, t_WaitForSingleObject_msec:{t_WaitForSingleObject_msec} msec")
                    break
                else:
                    # unkown error occured.
                    self.critical(self.recv, f"!! break recv() loop (ret = False). WaitForSingleObject returned unkown value({win32event}) break recv() loop !! xlHandle:{self.xlHandle[0]}, t_WaitForSingleObject_msec:{t_WaitForSingleObject_msec} msec")
                    break
            
            # timeout detection
            elapsed_sec = time.time() - start_sec
            if elapsed_sec > timeout_sec:
                self.info(self.recv, f"break recv() loop due to no event (ret = False). elapsed_sec:{elapsed_sec:<.3}, timeout_sec:{timeout_sec}")
                break
        return (ret, msg_flags, timestamp, ch, can_id, dlc, data)

    def info(self,method,s):
        self.log.info(f"[{self.appName:8}][{method.__name__:8}] {s}")

    def debug(self,method,s):
        self.log.debug(f"[{self.appName:8}][{method.__name__:8}] {s}")

    def warn(self,method,s):
        self.log.warn(f"[{self.appName:8}][{method.__name__:8}] {s}")

    def critical(self,method,s):
        self.log.critical(f"[{self.appName:8}][{method.__name__:8}] {s}")

    def _decode_bin(self,bin):
        return bin.decode(chardet.detect(bin)["encoding"])

    def _parse_msg_flags(self, msg_flags):
        msg_flags_str = ""
        msg_flags_str += "" if msg_flags & xl.XL_CAN_MSG_FLAG_ERROR_FRAME  else "|XL_CAN_MSG_FLAG_ERROR_FRAME"
        msg_flags_str += "" if msg_flags & xl.XL_CAN_MSG_FLAG_OVERRUN      else "|XL_CAN_MSG_FLAG_OVERRUN"
        msg_flags_str += "" if msg_flags & xl.XL_CAN_MSG_FLAG_NERR         else "|XL_CAN_MSG_FLAG_NERR"
        msg_flags_str += "" if msg_flags & xl.XL_CAN_MSG_FLAG_WAKEUP       else "|XL_CAN_MSG_FLAG_WAKEUP"
        msg_flags_str += "" if msg_flags & xl.XL_CAN_MSG_FLAG_REMOTE_FRAME else "|XL_CAN_MSG_FLAG_REMOTE_FRAME"
        msg_flags_str += "" if msg_flags & xl.XL_CAN_MSG_FLAG_RESERVED_1   else "|XL_CAN_MSG_FLAG_RESERVED_1"
        msg_flags_str += "" if msg_flags & xl.XL_CAN_MSG_FLAG_TX_COMPLETED else "|XL_CAN_MSG_FLAG_TX_COMPLETED"
        msg_flags_str += "" if msg_flags & xl.XL_CAN_MSG_FLAG_TX_REQUEST   else "|XL_CAN_MSG_FLAG_TX_REQUEST"
        msg_flags_str += "" if msg_flags & xl.XL_CAN_MSG_FLAG_SRR_BIT_DOM  else "|XL_CAN_MSG_FLAG_SRR_BIT_DOM"
        return msg_flags_str


def recv_thread(can, timeout_sec):
    logger.debug("recv_task - start")
    while True:
        ret, msg_flags, timestamp, ch, can_id, dlc, data = can.recv(timeout_sec=timeout_sec)
        if ret == True:
            if msg_flags == 0:
                data = " ".join(map(lambda d:f"{d:02X}",data))
                #___0.081289 1  3E6             Rx   d 8 50 00 00 00 00 00 00 00  Length = 960000 BitCount = 124 ID = 998
                print(f"{timestamp:>11.6f} {ch+1:<2} {can_id:3x}             Rx   d {dlc:1} {data}")
            elif msg_flags & xl.XL_CAN_MSG_FLAG_ERROR_FRAME:
                print(f"{timestamp:>11.6f} {ch+1:<2} ERROR FRAME")
            else:
                # ignore other flags
                pass
        else:
            break
    logger.debug("recv_task - end")
    return True

if __name__ == "__main__":
    from logging import basicConfig, Formatter
    basicConfig(level=DEBUG)
    logger = getLogger(__name__)
    handler = StreamHandler()
    handler.setLevel(DEBUG)
    handler.setFormatter(Formatter("%(asctime)s [%(levelname)-7s][%(name)-10s]%(message)s"))
    logger.addHandler(handler)

    print_can_networks()
    # xl.PopupHwConfig()
    from concurrent.futures import ThreadPoolExecutor

    executor = ThreadPoolExecutor(max_workers=1)

    receiver=Can(appName="receiver")
    executor.submit(recv_thread, can=receiver, timeout_sec=3)

    sender=Can(appName="sender")
    for i in range(10):
        sender.send(can_id=0x123, data=[0,1,2,3,4,5])
        time.sleep(0.1)

    executor.shutdown()
