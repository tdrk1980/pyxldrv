# *-* encoding: utf-8 *-*

from libc.string cimport memset
from libc.stdlib cimport malloc, free


cdef extern from "vxlapi.h":

    int _XL_HWTYPE_NONE                    "XL_HWTYPE_NONE"
    int _XL_HWTYPE_VIRTUAL                 "XL_HWTYPE_VIRTUAL"
    int _XL_HWTYPE_CANCARDX                "XL_HWTYPE_CANCARDX"
    int _XL_HWTYPE_CANAC2PCI               "XL_HWTYPE_CANAC2PCI"
    int _XL_HWTYPE_CANCARDY                "XL_HWTYPE_CANCARDY"
    int _XL_HWTYPE_CANCARDXL               "XL_HWTYPE_CANCARDXL"
    int _XL_HWTYPE_CANCASEXL               "XL_HWTYPE_CANCASEXL"
    int _XL_HWTYPE_CANCASEXL_LOG_OBSOLETE  "XL_HWTYPE_CANCASEXL_LOG_OBSOLETE"
    int _XL_HWTYPE_CANBOARDXL              "XL_HWTYPE_CANBOARDXL"
    int _XL_HWTYPE_CANBOARDXL_PXI          "XL_HWTYPE_CANBOARDXL_PXI"
    int _XL_HWTYPE_VN2600                  "XL_HWTYPE_VN2600"
    int _XL_HWTYPE_VN2610                  "XL_HWTYPE_VN2610"
    int _XL_HWTYPE_VN3300                  "XL_HWTYPE_VN3300"
    int _XL_HWTYPE_VN3600                  "XL_HWTYPE_VN3600"
    int _XL_HWTYPE_VN7600                  "XL_HWTYPE_VN7600"
    int _XL_HWTYPE_CANCARDXLE              "XL_HWTYPE_CANCARDXLE"
    int _XL_HWTYPE_VN8900                  "XL_HWTYPE_VN8900"
    int _XL_HWTYPE_VN8950                  "XL_HWTYPE_VN8950"
    int _XL_HWTYPE_VN2640                  "XL_HWTYPE_VN2640"
    int _XL_HWTYPE_VN1610                  "XL_HWTYPE_VN1610"
    int _XL_HWTYPE_VN1630                  "XL_HWTYPE_VN1630"
    int _XL_HWTYPE_VN1640                  "XL_HWTYPE_VN1640"
    int _XL_HWTYPE_VN8970                  "XL_HWTYPE_VN8970"
    int _XL_HWTYPE_VN1611                  "XL_HWTYPE_VN1611"
    int _XL_HWTYPE_VN5610                  "XL_HWTYPE_VN5610"
    int _XL_HWTYPE_VN7570                  "XL_HWTYPE_VN7570"
    int _XL_HWTYPE_IPCLIENT                "XL_HWTYPE_IPCLIENT"
    int _XL_HWTYPE_IPSERVER                "XL_HWTYPE_IPSERVER"
    int _XL_HWTYPE_VX1121                  "XL_HWTYPE_VX1121"
    int _XL_HWTYPE_VX1131                  "XL_HWTYPE_VX1131"
    int _XL_HWTYPE_VT6204                  "XL_HWTYPE_VT6204"
    int _XL_HWTYPE_VN1630_LOG              "XL_HWTYPE_VN1630_LOG"
    int _XL_HWTYPE_VN7610                  "XL_HWTYPE_VN7610"
    int _XL_HWTYPE_VN7572                  "XL_HWTYPE_VN7572"
    int _XL_HWTYPE_VN8972                  "XL_HWTYPE_VN8972"
    int _XL_HWTYPE_VN0601                  "XL_HWTYPE_VN0601"
    int _XL_HWTYPE_VX0312                  "XL_HWTYPE_VX0312"
    int _XL_HWTYPE_VN8800                  "XL_HWTYPE_VN8800"
    int _XL_HWTYPE_IPCL8800                "XL_HWTYPE_IPCL8800"
    int _XL_HWTYPE_IPSRV8800               "XL_HWTYPE_IPSRV8800"
    int _XL_HWTYPE_CSMCAN                  "XL_HWTYPE_CSMCAN"
    int _XL_HWTYPE_VN5610A                 "XL_HWTYPE_VN5610A"
    int _XL_HWTYPE_VN7640                  "XL_HWTYPE_VN7640"
    int _XL_MAX_HWTYPE                     "XL_MAX_HWTYPE"

    int _XL_BUS_TYPE_NONE      "XL_BUS_TYPE_NONE"
    int _XL_BUS_TYPE_CAN       "XL_BUS_TYPE_CAN"
    int _XL_BUS_TYPE_LIN       "XL_BUS_TYPE_LIN"
    int _XL_BUS_TYPE_FLEXRAY   "XL_BUS_TYPE_FLEXRAY"
    int _XL_BUS_TYPE_AFDX      "XL_BUS_TYPE_AFDX"
    int _XL_BUS_TYPE_MOST      "XL_BUS_TYPE_MOST"
    int _XL_BUS_TYPE_DAIO      "XL_BUS_TYPE_DAIO"
    int _XL_BUS_TYPE_J1708     "XL_BUS_TYPE_J1708"
    int _XL_BUS_TYPE_ETHERNET  "XL_BUS_TYPE_ETHERNET"
    int _XL_BUS_TYPE_A429      "XL_BUS_TYPE_A429"

    int _XL_INTERFACE_VERSION_V2  "XL_INTERFACE_VERSION_V2"
    int _XL_INTERFACE_VERSION_V3  "XL_INTERFACE_VERSION_V3"
    int _XL_INTERFACE_VERSION_V4  "XL_INTERFACE_VERSION_V4"
    int _XL_INTERFACE_VERSION     "XL_INTERFACE_VERSION"

    int _XL_INVALID_PORTHANDLE    "XL_INVALID_PORTHANDLE"

    int _XL_BUS_PARAMS_CANOPMODE_CAN20  "XL_BUS_PARAMS_CANOPMODE_CAN20"
    int _XL_BUS_PARAMS_CANOPMODE_CANFD  "XL_BUS_PARAMS_CANOPMODE_CANFD"

    int _XL_A429_MSG_CHANNEL_DIR_TX              "XL_A429_MSG_CHANNEL_DIR_TX"
    int _XL_A429_MSG_CHANNEL_DIR_RX              "XL_A429_MSG_CHANNEL_DIR_RX"
    int _XL_A429_MSG_BITRATE_SLOW_MIN            "XL_A429_MSG_BITRATE_SLOW_MIN"
    int _XL_A429_MSG_BITRATE_SLOW_MAX            "XL_A429_MSG_BITRATE_SLOW_MAX"
    int _XL_A429_MSG_BITRATE_FAST_MIN            "XL_A429_MSG_BITRATE_FAST_MIN"
    int _XL_A429_MSG_BITRATE_FAST_MAX            "XL_A429_MSG_BITRATE_FAST_MAX"
    int _XL_A429_MSG_GAP_4BIT                    "XL_A429_MSG_GAP_4BIT"
    int _XL_A429_MSG_BITRATE_RX_MIN              "XL_A429_MSG_BITRATE_RX_MIN"
    int _XL_A429_MSG_BITRATE_RX_MAX              "XL_A429_MSG_BITRATE_RX_MAX"
    int _XL_A429_MSG_AUTO_BAUDRATE_DISABLED      "XL_A429_MSG_AUTO_BAUDRATE_DISABLED"
    int _XL_A429_MSG_AUTO_BAUDRATE_ENABLED       "XL_A429_MSG_AUTO_BAUDRATE_ENABLED"
    int _XL_A429_MSG_FLAG_ON_REQUEST             "XL_A429_MSG_FLAG_ON_REQUEST"
    int _XL_A429_MSG_FLAG_CYCLIC                 "XL_A429_MSG_FLAG_CYCLIC"
    int _XL_A429_MSG_FLAG_DELETE_CYCLIC          "XL_A429_MSG_FLAG_DELETE_CYCLIC"
    int _XL_A429_MSG_CYCLE_MAX                   "XL_A429_MSG_CYCLE_MAX"
    int _XL_A429_MSG_GAP_DEFAULT                 "XL_A429_MSG_GAP_DEFAULT"
    int _XL_A429_MSG_GAP_MAX                     "XL_A429_MSG_GAP_MAX"
    int _XL_A429_MSG_PARITY_DEFAULT              "XL_A429_MSG_PARITY_DEFAULT"
    int _XL_A429_MSG_PARITY_DISABLED             "XL_A429_MSG_PARITY_DISABLED"
    int _XL_A429_MSG_PARITY_ODD                  "XL_A429_MSG_PARITY_ODD"
    int _XL_A429_MSG_PARITY_EVEN                 "XL_A429_MSG_PARITY_EVEN"
    int _XL_A429_EV_TX_MSG_CTRL_ON_REQUEST       "XL_A429_EV_TX_MSG_CTRL_ON_REQUEST"
    int _XL_A429_EV_TX_MSG_CTRL_CYCLIC           "XL_A429_EV_TX_MSG_CTRL_CYCLIC"
    int _XL_A429_EV_TX_ERROR_ACCESS_DENIED       "XL_A429_EV_TX_ERROR_ACCESS_DENIED"
    int _XL_A429_EV_TX_ERROR_TRANSMISSION_ERROR  "XL_A429_EV_TX_ERROR_TRANSMISSION_ERROR"
    int _XL_A429_EV_RX_ERROR_GAP_VIOLATION       "XL_A429_EV_RX_ERROR_GAP_VIOLATION"
    int _XL_A429_EV_RX_ERROR_PARITY              "XL_A429_EV_RX_ERROR_PARITY"
    int _XL_A429_EV_RX_ERROR_BITRATE_LOW         "XL_A429_EV_RX_ERROR_BITRATE_LOW"
    int _XL_A429_EV_RX_ERROR_BITRATE_HIGH        "XL_A429_EV_RX_ERROR_BITRATE_HIGH"
    int _XL_A429_EV_RX_ERROR_FRAME_FORMAT        "XL_A429_EV_RX_ERROR_FRAME_FORMAT"
    int _XL_A429_EV_RX_ERROR_CODING_RZ           "XL_A429_EV_RX_ERROR_CODING_RZ"
    int _XL_A429_EV_RX_ERROR_DUTY_FACTOR         "XL_A429_EV_RX_ERROR_DUTY_FACTOR"
    int _XL_A429_EV_RX_ERROR_AVG_BIT_LENGTH      "XL_A429_EV_RX_ERROR_AVG_BIT_LENGTH"
    int _XL_A429_QUEUE_OVERFLOW                  "XL_A429_QUEUE_OVERFLOW"
    int _XL_A429_RX_FIFO_QUEUE_SIZE_MAX          "XL_A429_RX_FIFO_QUEUE_SIZE_MAX"
    int _XL_A429_RX_FIFO_QUEUE_SIZE_MIN          "XL_A429_RX_FIFO_QUEUE_SIZE_MIN"

    int _XL_SUCCESS                        "XL_SUCCESS"
    int _XL_PENDING                        "XL_PENDING"
    int _XL_ERR_QUEUE_IS_EMPTY             "XL_ERR_QUEUE_IS_EMPTY"
    int _XL_ERR_QUEUE_IS_FULL              "XL_ERR_QUEUE_IS_FULL"
    int _XL_ERR_TX_NOT_POSSIBLE            "XL_ERR_TX_NOT_POSSIBLE"
    int _XL_ERR_NO_LICENSE                 "XL_ERR_NO_LICENSE"
    int _XL_ERR_WRONG_PARAMETER            "XL_ERR_WRONG_PARAMETER"
    int _XL_ERR_TWICE_REGISTER             "XL_ERR_TWICE_REGISTER"
    int _XL_ERR_INVALID_CHAN_INDEX         "XL_ERR_INVALID_CHAN_INDEX"
    int _XL_ERR_INVALID_ACCESS             "XL_ERR_INVALID_ACCESS"
    int _XL_ERR_PORT_IS_OFFLINE            "XL_ERR_PORT_IS_OFFLINE"
    int _XL_ERR_CHAN_IS_ONLINE             "XL_ERR_CHAN_IS_ONLINE"
    int _XL_ERR_NOT_IMPLEMENTED            "XL_ERR_NOT_IMPLEMENTED"
    int _XL_ERR_INVALID_PORT               "XL_ERR_INVALID_PORT"
    int _XL_ERR_HW_NOT_READY               "XL_ERR_HW_NOT_READY"
    int _XL_ERR_CMD_TIMEOUT                "XL_ERR_CMD_TIMEOUT"
    int _XL_ERR_CMD_HANDLING               "XL_ERR_CMD_HANDLING"
    int _XL_ERR_HW_NOT_PRESENT             "XL_ERR_HW_NOT_PRESENT"
    int _XL_ERR_NOTIFY_ALREADY_ACTIVE      "XL_ERR_NOTIFY_ALREADY_ACTIVE"
    int _XL_ERR_INVALID_TAG                "XL_ERR_INVALID_TAG"
    int _XL_ERR_INVALID_RESERVED_FLD       "XL_ERR_INVALID_RESERVED_FLD"
    int _XL_ERR_INVALID_SIZE               "XL_ERR_INVALID_SIZE"
    int _XL_ERR_INSUFFICIENT_BUFFER        "XL_ERR_INSUFFICIENT_BUFFER"
    int _XL_ERR_ERROR_CRC                  "XL_ERR_ERROR_CRC"
    int _XL_ERR_BAD_EXE_FORMAT             "XL_ERR_BAD_EXE_FORMAT"
    int _XL_ERR_NO_SYSTEM_RESOURCES        "XL_ERR_NO_SYSTEM_RESOURCES"
    int _XL_ERR_NOT_FOUND                  "XL_ERR_NOT_FOUND"
    int _XL_ERR_INVALID_ADDRESS            "XL_ERR_INVALID_ADDRESS"
    int _XL_ERR_REQ_NOT_ACCEP              "XL_ERR_REQ_NOT_ACCEP"
    int _XL_ERR_INVALID_LEVEL              "XL_ERR_INVALID_LEVEL"
    int _XL_ERR_NO_DATA_DETECTED           "XL_ERR_NO_DATA_DETECTED"
    int _XL_ERR_INTERNAL_ERROR             "XL_ERR_INTERNAL_ERROR"
    int _XL_ERR_UNEXP_NET_ERR              "XL_ERR_UNEXP_NET_ERR"
    int _XL_ERR_INVALID_USER_BUFFER        "XL_ERR_INVALID_USER_BUFFER"
    int _XL_ERR_NO_RESOURCES               "XL_ERR_NO_RESOURCES"
    int _XL_ERR_WRONG_CHIP_TYPE            "XL_ERR_WRONG_CHIP_TYPE"
    int _XL_ERR_WRONG_COMMAND              "XL_ERR_WRONG_COMMAND"
    int _XL_ERR_INVALID_HANDLE             "XL_ERR_INVALID_HANDLE"
    int _XL_ERR_RESERVED_NOT_ZERO          "XL_ERR_RESERVED_NOT_ZERO"
    int _XL_ERR_INIT_ACCESS_MISSING        "XL_ERR_INIT_ACCESS_MISSING"
    int _XL_ERR_CANNOT_OPEN_DRIVER         "XL_ERR_CANNOT_OPEN_DRIVER"
    int _XL_ERR_WRONG_BUS_TYPE             "XL_ERR_WRONG_BUS_TYPE"
    int _XL_ERR_DLL_NOT_FOUND              "XL_ERR_DLL_NOT_FOUND"
    int _XL_ERR_INVALID_CHANNEL_MASK       "XL_ERR_INVALID_CHANNEL_MASK"
    int _XL_ERR_NOT_SUPPORTED              "XL_ERR_NOT_SUPPORTED"
    int _XL_ERR_CONNECTION_BROKEN          "XL_ERR_CONNECTION_BROKEN"
    int _XL_ERR_CONNECTION_CLOSED          "XL_ERR_CONNECTION_CLOSED"
    int _XL_ERR_INVALID_STREAM_NAME        "XL_ERR_INVALID_STREAM_NAME"
    int _XL_ERR_CONNECTION_FAILED          "XL_ERR_CONNECTION_FAILED"
    int _XL_ERR_STREAM_NOT_FOUND           "XL_ERR_STREAM_NOT_FOUND"
    int _XL_ERR_STREAM_NOT_CONNECTED       "XL_ERR_STREAM_NOT_CONNECTED"
    int _XL_ERR_QUEUE_OVERRUN              "XL_ERR_QUEUE_OVERRUN"
    int _XL_ERROR                          "XL_ERROR"
    int _XL_ERR_INVALID_DLC                "XL_ERR_INVALID_DLC"
    int _XL_ERR_INVALID_CANID              "XL_ERR_INVALID_CANID"
    int _XL_ERR_INVALID_FDFLAG_MODE20      "XL_ERR_INVALID_FDFLAG_MODE20"
    int _XL_ERR_EDL_RTR                    "XL_ERR_EDL_RTR"
    int _XL_ERR_EDL_NOT_SET                "XL_ERR_EDL_NOT_SET"
    int _XL_ERR_UNKNOWN_FLAG               "XL_ERR_UNKNOWN_FLAG"
    int _XL_ERR_ETH_PHY_ACTIVATION_FAILED  "XL_ERR_ETH_PHY_ACTIVATION_FAILED"
    int _XL_ERR_ETH_MAC_RESET_FAILED       "XL_ERR_ETH_MAC_RESET_FAILED"
    int _XL_ERR_ETH_MAC_NOT_READY          "XL_ERR_ETH_MAC_NOT_READY"
    int _XL_ERR_ETH_PHY_CONFIG_ABORTED     "XL_ERR_ETH_PHY_CONFIG_ABORTED"
    int _XL_ERR_ETH_RESET_FAILED           "XL_ERR_ETH_RESET_FAILED"
    int _XL_ERR_ETH_SET_CONFIG_DELAYED     "XL_ERR_ETH_SET_CONFIG_DELAYED"
    int _XL_ERR_ETH_UNSUPPORTED_FEATURE    "XL_ERR_ETH_UNSUPPORTED_FEATURE"
    int _XL_ERR_ETH_MAC_ACTIVATION_FAILED  "XL_ERR_ETH_MAC_ACTIVATION_FAILED"
    int _XL_ERR_ETH_FILTER_INVALID         "XL_ERR_ETH_FILTER_INVALID"
    int _XL_ERR_ETH_FILTER_UNAVAILABLE     "XL_ERR_ETH_FILTER_UNAVAILABLE"
    int _XL_ERR_ETH_FILTER_NO_INIT_ACCESS  "XL_ERR_ETH_FILTER_NO_INIT_ACCESS"
    int _XL_ERR_ETH_FILTER_TOO_COMPLEX     "XL_ERR_ETH_FILTER_TOO_COMPLEX"

    int _XL_ACTIVATE_NONE         "XL_ACTIVATE_NONE"
    int _XL_ACTIVATE_RESET_CLOCK  "XL_ACTIVATE_RESET_CLOCK"

    int _XL_CAN_EXT_MSG_ID              "XL_CAN_EXT_MSG_ID"
    int _XL_CAN_MSG_FLAG_ERROR_FRAME    "XL_CAN_MSG_FLAG_ERROR_FRAME"
    int _XL_CAN_MSG_FLAG_OVERRUN        "XL_CAN_MSG_FLAG_OVERRUN"
    int _XL_CAN_MSG_FLAG_NERR           "XL_CAN_MSG_FLAG_NERR"
    int _XL_CAN_MSG_FLAG_WAKEUP         "XL_CAN_MSG_FLAG_WAKEUP"
    int _XL_CAN_MSG_FLAG_REMOTE_FRAME   "XL_CAN_MSG_FLAG_REMOTE_FRAME"
    int _XL_CAN_MSG_FLAG_RESERVED_1     "XL_CAN_MSG_FLAG_RESERVED_1"
    int _XL_CAN_MSG_FLAG_TX_COMPLETED   "XL_CAN_MSG_FLAG_TX_COMPLETED"
    int _XL_CAN_MSG_FLAG_TX_REQUEST     "XL_CAN_MSG_FLAG_TX_REQUEST"
    int _XL_CAN_MSG_FLAG_SRR_BIT_DOM    "XL_CAN_MSG_FLAG_SRR_BIT_DOM"
    int _XL_EVENT_FLAG_OVERRUN          "XL_EVENT_FLAG_OVERRUN"
    int _XL_LIN_MSGFLAG_TX              "XL_LIN_MSGFLAG_TX"
    int _XL_LIN_MSGFLAG_CRCERROR        "XL_LIN_MSGFLAG_CRCERROR"

    XLstatus xlOpenDriver()
    XLstatus xlCloseDriver()

    XLaccess xlGetChannelMask(int hwType, int hwIndex, int hwChannel)

    XLstatus xlOpenPort(XLportHandle* portHandle, char* userName, XLaccess accessMask, XLaccess* permissionMask, unsigned int rxQueueSize, unsigned int xlInterfaceVersion, unsigned int busType)
    XLstatus xlClosePort(XLportHandle portHandle)

    XLstatus xlActivateChannel(XLportHandle portHandle, XLaccess accessMask, unsigned int busType, unsigned int flags)
    XLstatus xlDeactivateChannel(XLportHandle portHandle, XLaccess accessMask)

    XLstatus xlCanTransmit(XLportHandle portHandle, XLaccess accessMask, unsigned int* messageCount, void* pMessage)
    XLstatus xlReceive(XLportHandle portHandle, unsigned int *pEventCount, XLevent *pEventList)
    XLstatus xlSetNotification(XLportHandle portHandle, XLhandle pXlHandle, int queueLevel)
    
    XLstringType xlGetEventString(XLevent* ev)
    const char* xlGetErrorString(XLstatus err)

    XLstatus xlGetApplConfig(char *appName, unsigned int appChannel, unsigned int *pHwType, unsigned int *pHwIndex, unsigned int *pHwChannel, unsigned int busType)
    XLstatus xlSetApplConfig(char *appName, unsigned int appChannel, unsigned int hwType, unsigned int hwIndex, unsigned int hwChannel, unsigned int busType)
    XLstatus xlGetDriverConfig(XLdriverConfig *pDriverConfig)

    XLstatus xlPopupHwConfig(char* callSign, unsigned int waitForFinish)

cpdef enum e_XLevent_type:
    XL_NO_COMMAND               =  0
    XL_RECEIVE_MSG              =  1
    XL_CHIP_STATE               =  4
    XL_TRANSCEIVER              =  6
    XL_TIMER                    =  8
    XL_TRANSMIT_MSG             = 10
    XL_SYNC_PULSE               = 11
    XL_APPLICATION_NOTIFICATION = 15
    XL_LIN_MSG                  = 20
    XL_LIN_ERRMSG               = 21
    XL_LIN_SYNCERR              = 22
    XL_LIN_NOANS                = 23
    XL_LIN_WAKEUP               = 24
    XL_LIN_SLEEP                = 25
    XL_LIN_CRCINFO              = 26
    XL_RECEIVE_DAIO_DATA        = 32
    XL_RECEIVE_DAIO_PIGGY       = 34

cpdef OpenDriver():
    return xlOpenDriver()

cpdef CloseDriver():
    return xlCloseDriver()

cpdef GetChannelMask(int hwType, int hwIndex, int hwChannel):
    return xlGetChannelMask(hwType, hwIndex, hwChannel)

cpdef OpenPort(list portHandle, char* appName, XLaccess accessMask, list permissionMask, unsigned int rxQueueSize, unsigned int xlInterfaceVersion, unsigned int busType):
    cdef XLstatus status = 0
    cdef XLportHandle port_handle = -1 # XL_INVALID_PORTHANDLE
    cdef XLaccess permission_mask = permissionMask[0]

    status = xlOpenPort(&port_handle, appName, accessMask, &permission_mask, rxQueueSize, xlInterfaceVersion, busType)
    
    portHandle[0] = port_handle
    permissionMask[0] = permission_mask
    return status

cpdef ClosePort(XLportHandle portHandle):
    return xlClosePort(portHandle)

cpdef ActivateChannel(XLportHandle portHandle, XLaccess accessMask, unsigned int busType, unsigned int flags):
    return xlActivateChannel(portHandle, accessMask, busType, flags)

cpdef DeactivateChannel(XLportHandle portHandle, XLaccess accessMask):
    return xlDeactivateChannel(portHandle, accessMask)

cpdef CanTransmit(XLportHandle portHandle, XLaccess accessMask, list messageCount, list pMessage):
    cdef XLstatus status = 0
    cdef unsigned int message_count = 0
    cdef XLevent *pxlEvent = NULL

    message_count = <unsigned int>len(pMessage)
    if message_count > 0:
        pxlEvent = <XLevent *> malloc(sizeof(XLevent) * message_count)
        memset(pxlEvent, 0, sizeof(XLevent) * message_count)
        for i, msg in enumerate(pMessage):
            pxlEvent[i].tag                 = <unsigned char >XL_TRANSMIT_MSG
            pxlEvent[i].tagData.msg.flags   = <unsigned short>msg["flags"]
            pxlEvent[i].tagData.msg.id      = <unsigned long >msg["id"]
            pxlEvent[i].tagData.msg.dlc     = <unsigned short>msg["dlc"]
            for j, b in enumerate(msg["data"]):
                pxlEvent[i].tagData.msg.data[j] = b
        status = xlCanTransmit(portHandle, accessMask, &message_count, pxlEvent)
        free(pxlEvent)
    messageCount[0] = message_count
    return status

cpdef Receive(XLportHandle portHandle, list pEventCount, list pEventList):
    cdef XLstatus status = 0
    cdef unsigned int eventCount = 1
    cdef XLevent xlEvent
    memset(&xlEvent, 0, sizeof(xlEvent))
    retEvent = {}

    status = xlReceive(portHandle, &eventCount, &xlEvent)
    retEvent["tag"]         = xlEvent.tag
    retEvent["chanIndex"]   = xlEvent.chanIndex
    retEvent["transId"]     = xlEvent.transId
    retEvent["portHandle"]  = xlEvent.portHandle
    retEvent["flags"]       = xlEvent.flags # XL_EVENT_FLAG_OVERRUN が立っていたら、これがなくなるまでリードする。
    # retEvent["reserved"]  = xlEvent.reserved
    retEvent["timeStamp"]   = xlEvent.timeStamp # Actual time stamp generated by the hardware with 8 μs resolution. Value is in nanoseconds.

    tagData = {}
    if xlEvent.tag == XL_RECEIVE_MSG:
        msg = {}
        msg["id"]    = xlEvent.tagData.msg.id
        msg["flags"] = xlEvent.tagData.msg.flags
        msg["dlc"]   = xlEvent.tagData.msg.dlc
        msg["data"]   = [xlEvent.tagData.msg.data[i] for i in range(8)]
        tagData["msg"] = msg
    else:
        # The following events are not supported now.
        # Common and CAN events : XL_CHIP_STATE, XL_TRANSCEIVER, XL_TIMER, XL_TRANSMIT_MSG, XL_SYNC_PULSE
        # Special LIN events    : XL_LIN_MSG, XL_LIN_ERRMSG,XL_LIN_SYNCERR, XL_LIN_NOANS, XL_LIN_WAKEUP, XL_LIN_SLEEP, XL_LIN_CRCINFO
        # Special DAIO events   : XL_RECEIVE_DAIO_DATA
        pass
    retEvent["tagData"] = tagData
    pEventCount[0] = eventCount
    pEventList[0] = retEvent
    return status

cpdef SetNotification(XLportHandle portHandle, list pXlHandle, int queueLevel):
    cpdef XLstatus status = 0
    cpdef XLhandle xlHandle = NULL
    status = xlSetNotification(portHandle, &xlHandle, queueLevel)
    pXlHandle[0] = <size_t>xlHandle
    return status


cpdef GetErrorString(XLstatus err):
    return xlGetErrorString(err)

def GetApplConfig(char *appName, unsigned int appChannel, list pHwType, list pHwIndex, list pHwChannel, unsigned int busType):
    cdef XLstatus status = 0
    cdef unsigned int hwType    = pHwType[0]
    cdef unsigned int hwIndex   = pHwIndex[0]
    cdef unsigned int hwChannel = pHwChannel[0]

    status = xlGetApplConfig(appName, appChannel, &hwType, &hwIndex, &hwChannel, busType)
    pHwType[0]    = hwType
    pHwIndex[0]   = hwIndex
    pHwChannel[0] = hwChannel

    return status

def SetApplConfig(char *appName, unsigned int appChannel, list pHwType, list pHwIndex, list pHwChannel, unsigned int busType):
    return xlSetApplConfig(appName, appChannel, pHwType[0], pHwIndex[0], pHwChannel[0], busType)

def GetDriverConfig(dict pDriverConfig):
    cdef XLstatus status
    cdef XLdriverConfig driverConfig
    
    status = xlGetDriverConfig(&driverConfig)

    pDriverConfig["dllVersion"]   = driverConfig.dllVersion
    pDriverConfig["channelCount"] = driverConfig.channelCount
    pDriverConfig["reserved[10]"] = [driverConfig.reserved[i] for i in range(10)]

    channel = []
    cdef int channelCount = driverConfig.channelCount
    for i in range(channelCount):
        ch = {}
        ch["name"]                   = bytes(driverConfig.channel[i].name)
        ch["hwType"]                 = driverConfig.channel[i].hwType
        ch["hwIndex"]                = driverConfig.channel[i].hwIndex
        ch["transceiverType"]        = driverConfig.channel[i].transceiverType
        ch["transceiverState"]       = driverConfig.channel[i].transceiverState
        ch["configError"]            = driverConfig.channel[i].configError
        ch["channelIndex"]           = driverConfig.channel[i].channelIndex
        ch["channelMask"]            = driverConfig.channel[i].channelMask
        ch["channelCapabilities"]    = driverConfig.channel[i].channelCapabilities
        ch["channelBusCapabilities"] = driverConfig.channel[i].channelBusCapabilities
        ch["isOnBus"]                = driverConfig.channel[i].isOnBus
        ch["connectedBusType"]       = driverConfig.channel[i].connectedBusType

        busParams = {}
        busParams["busType"] = driverConfig.channel[i].busParams.busType

        data = {}
        if busParams["busType"]   == XL_BUS_TYPE_NONE:
            pass
        elif busParams["busType"] == XL_BUS_TYPE_CAN:
            if driverConfig.channel[i].busParams.data.can.canOpMode == XL_BUS_PARAMS_CANOPMODE_CANFD:
                canFD = {}
                canFD["arbitrationBitRate"] = driverConfig.channel[i].busParams.data.canFD.arbitrationBitRate
                canFD["sjwAbr"]             = driverConfig.channel[i].busParams.data.canFD.sjwAbr
                canFD["tseg1Abr"]           = driverConfig.channel[i].busParams.data.canFD.tseg1Abr
                canFD["tseg2Abr"]           = driverConfig.channel[i].busParams.data.canFD.tseg2Abr
                canFD["samAbr"]             = driverConfig.channel[i].busParams.data.canFD.samAbr
                canFD["outputMode"]         = driverConfig.channel[i].busParams.data.canFD.outputMode
                canFD["sjwDbr"]             = driverConfig.channel[i].busParams.data.canFD.sjwDbr
                canFD["tseg1Dbr"]           = driverConfig.channel[i].busParams.data.canFD.tseg1Dbr
                canFD["tseg2Dbr"]           = driverConfig.channel[i].busParams.data.canFD.tseg2Dbr
                canFD["dataBitRate"]        = driverConfig.channel[i].busParams.data.canFD.dataBitRate
                canFD["canOpMode"]          = driverConfig.channel[i].busParams.data.canFD.canOpMode
                data["canFD"] = canFD
            else:
                can = {}
                can["bitRate"]    = driverConfig.channel[i].busParams.data.can.bitRate
                can["sjw"]        = driverConfig.channel[i].busParams.data.can.sjw
                can["tseg1"]      = driverConfig.channel[i].busParams.data.can.tseg1
                can["tseg2"]      = driverConfig.channel[i].busParams.data.can.tseg2
                can["sam"]        = driverConfig.channel[i].busParams.data.can.sam
                can["outputMode"] = driverConfig.channel[i].busParams.data.can.outputMode
                can["reserved[7]"]= bytearray([driverConfig.channel[i].busParams.data.can.reserved[j] for j in range(7)])
                can["canOpMode"]  = driverConfig.channel[i].busParams.data.can.canOpMode
                data["can"] = can
        elif busParams["busType"] == XL_BUS_TYPE_LIN:
            pass
        elif busParams["busType"] == XL_BUS_TYPE_FLEXRAY:
            flexray = {}
            flexray["status"]   = driverConfig.channel[i].busParams.data.flexray.status
            flexray["cfgMode"]  = driverConfig.channel[i].busParams.data.flexray.cfgMode
            flexray["baudrate"] = driverConfig.channel[i].busParams.data.flexray.baudrate
            data["flexray"] = flexray
        elif busParams["busType"] == XL_BUS_TYPE_AFDX:
            pass
        elif busParams["busType"] == XL_BUS_TYPE_MOST:
            most = {}
            most["activeSpeedGrade"]     = driverConfig.channel[i].busParams.data.most.activeSpeedGrade
            most["compatibleSpeedGrade"] = driverConfig.channel[i].busParams.data.most.compatibleSpeedGrade
            most["inicFwVersion"]        = driverConfig.channel[i].busParams.data.most.inicFwVersion
            data["most"] = most
        elif busParams["busType"] == XL_BUS_TYPE_DAIO:
            pass
        elif busParams["busType"] == XL_BUS_TYPE_J1708:
            pass
        elif busParams["busType"] == XL_BUS_TYPE_ETHERNET:
            ethernet = {}
            ethernet["macAddr[6]"]      = bytearray([driverConfig.channel[i].busParams.data.ethernet.macAddr[j] for j in range(6)])
            ethernet["connector"]       = driverConfig.channel[i].busParams.data.ethernet.connector
            ethernet["phy"]             = driverConfig.channel[i].busParams.data.ethernet.phy
            ethernet["link"]            = driverConfig.channel[i].busParams.data.ethernet.link
            ethernet["speed"]           = driverConfig.channel[i].busParams.data.ethernet.speed
            ethernet["clockMode"]       = driverConfig.channel[i].busParams.data.ethernet.clockMode
            ethernet["bypass"]          = driverConfig.channel[i].busParams.data.ethernet.bypass
            data["ethernet"] = ethernet
        elif busParams["busType"] == XL_BUS_TYPE_A429:
            a429 = {}
            a429["res1"] = driverConfig.channel[i].busParams.data.a429.res1
            a429["channelDirection"] = driverConfig.channel[i].busParams.data.a429.channelDirection
            dir = {}
            if a429["channelDirection"] == XL_A429_MSG_CHANNEL_DIR_TX:
                dir["bitrate"] = driverConfig.channel[i].busParams.data.a429.dir.tx.bitrate
                dir["parity"]  = driverConfig.channel[i].busParams.data.a429.dir.tx.parity
                dir["minGap"]  = driverConfig.channel[i].busParams.data.a429.dir.tx.minGap
            elif driverConfig.channel[i].busParams.data.a429.channelDirection == XL_A429_MSG_CHANNEL_DIR_RX:
                dir["bitrate"]     = driverConfig.channel[i].busParams.data.a429.dir.rx.bitrate
                dir["minBitrate"]  = driverConfig.channel[i].busParams.data.a429.dir.rx.minBitrate
                dir["maxBitrate"]  = driverConfig.channel[i].busParams.data.a429.dir.rx.maxBitrate
                dir["parity"]      = driverConfig.channel[i].busParams.data.a429.dir.rx.parity
                dir["minGap"]      = driverConfig.channel[i].busParams.data.a429.dir.rx.minGap
                dir["autoBaudrate"]= driverConfig.channel[i].busParams.data.a429.dir.rx.autoBaudrate
            else:
                pass
            dir["raw[24]"]   = bytearray([driverConfig.channel[i].busParams.data.raw[j] for j in range(24)])
            a429["dir"]  = dir
            data["a429"] = a429
        else:
            pass
        
        data["raw[28]"]   = bytearray([driverConfig.channel[i].busParams.data.raw[j] for j in range(28)])
        busParams["data"] = data
        ch["busParams"] = busParams

        ch["_doNotUse"]                     = driverConfig.channel[i]._doNotUse
        ch["driverVersion"]                 = driverConfig.channel[i].driverVersion
        ch["interfaceVersion"]              = driverConfig.channel[i].interfaceVersion
        ch["raw_data[10]"]                  = [driverConfig.channel[i].raw_data[j] for j in range(10)]
        ch["serialNumber"]                  = driverConfig.channel[i].serialNumber
        ch["articleNumber"]                 = driverConfig.channel[i].articleNumber
        ch["transceiverName"]               = bytes(driverConfig.channel[i].transceiverName)
        ch["specialCabFlags"]               = driverConfig.channel[i].specialCabFlags
        ch["dominantTimeout"]               = driverConfig.channel[i].dominantTimeout
        ch["dominantRecessiveDelay"]        = driverConfig.channel[i].dominantRecessiveDelay
        ch["recessiveDominantDelay"]        = driverConfig.channel[i].recessiveDominantDelay
        ch["connectionInfo"]                = driverConfig.channel[i].connectionInfo
        ch["currentlyAvailableTimestamps"]  = driverConfig.channel[i].currentlyAvailableTimestamps
        ch["minimalSupplyVoltage"]          = driverConfig.channel[i].minimalSupplyVoltage
        ch["maximalSupplyVoltage"]          = driverConfig.channel[i].maximalSupplyVoltage
        ch["maximalBaudrate"]               = driverConfig.channel[i].maximalBaudrate
        ch["fpgaCoreCapabilities"]          = driverConfig.channel[i].fpgaCoreCapabilities
        ch["specialDeviceStatus"]           = driverConfig.channel[i].specialDeviceStatus
        ch["channelBusActiveCapabilities"]  = driverConfig.channel[i].channelBusActiveCapabilities
        ch["breakOffset"]                   = driverConfig.channel[i].breakOffset
        ch["delimiterOffset"]               = driverConfig.channel[i].delimiterOffset
        ch["reserved[3]"]                      = bytearray([driverConfig.channel[i].reserved[j] for j in range(3)])





        channel.append(ch)
    
    pDriverConfig["channel"] = channel

    return status

def PopupHwConfig(char* callSign=NULL, unsigned int waitForFinish=0):
    return xlPopupHwConfig(callSign, waitForFinish)


# HwType
XL_HWTYPE_NONE                   = _XL_HWTYPE_NONE
XL_HWTYPE_VIRTUAL                = _XL_HWTYPE_VIRTUAL
XL_HWTYPE_CANCARDX               = _XL_HWTYPE_CANCARDX
XL_HWTYPE_CANAC2PCI              = _XL_HWTYPE_CANAC2PCI
XL_HWTYPE_CANCARDY               = _XL_HWTYPE_CANCARDY
XL_HWTYPE_CANCARDXL              = _XL_HWTYPE_CANCARDXL
XL_HWTYPE_CANCASEXL              = _XL_HWTYPE_CANCASEXL
XL_HWTYPE_CANCASEXL_LOG_OBSOLETE = _XL_HWTYPE_CANCASEXL_LOG_OBSOLETE
XL_HWTYPE_CANBOARDXL             = _XL_HWTYPE_CANBOARDXL
XL_HWTYPE_CANBOARDXL_PXI         = _XL_HWTYPE_CANBOARDXL_PXI
XL_HWTYPE_VN2600                 = _XL_HWTYPE_VN2600
XL_HWTYPE_VN2610                 = _XL_HWTYPE_VN2610
XL_HWTYPE_VN3300                 = _XL_HWTYPE_VN3300
XL_HWTYPE_VN3600                 = _XL_HWTYPE_VN3600
XL_HWTYPE_VN7600                 = _XL_HWTYPE_VN7600
XL_HWTYPE_CANCARDXLE             = _XL_HWTYPE_CANCARDXLE
XL_HWTYPE_VN8900                 = _XL_HWTYPE_VN8900
XL_HWTYPE_VN8950                 = _XL_HWTYPE_VN8950
XL_HWTYPE_VN2640                 = _XL_HWTYPE_VN2640
XL_HWTYPE_VN1610                 = _XL_HWTYPE_VN1610
XL_HWTYPE_VN1630                 = _XL_HWTYPE_VN1630
XL_HWTYPE_VN1640                 = _XL_HWTYPE_VN1640
XL_HWTYPE_VN8970                 = _XL_HWTYPE_VN8970
XL_HWTYPE_VN1611                 = _XL_HWTYPE_VN1611
XL_HWTYPE_VN5610                 = _XL_HWTYPE_VN5610
XL_HWTYPE_VN7570                 = _XL_HWTYPE_VN7570
XL_HWTYPE_IPCLIENT               = _XL_HWTYPE_IPCLIENT
XL_HWTYPE_IPSERVER               = _XL_HWTYPE_IPSERVER
XL_HWTYPE_VX1121                 = _XL_HWTYPE_VX1121
XL_HWTYPE_VX1131                 = _XL_HWTYPE_VX1131
XL_HWTYPE_VT6204                 = _XL_HWTYPE_VT6204
XL_HWTYPE_VN1630_LOG             = _XL_HWTYPE_VN1630_LOG
XL_HWTYPE_VN7610                 = _XL_HWTYPE_VN7610
XL_HWTYPE_VN7572                 = _XL_HWTYPE_VN7572
XL_HWTYPE_VN8972                 = _XL_HWTYPE_VN8972
XL_HWTYPE_VN0601                 = _XL_HWTYPE_VN0601
XL_HWTYPE_VX0312                 = _XL_HWTYPE_VX0312
XL_HWTYPE_VN8800                 = _XL_HWTYPE_VN8800
XL_HWTYPE_IPCL8800               = _XL_HWTYPE_IPCL8800
XL_HWTYPE_IPSRV8800              = _XL_HWTYPE_IPSRV8800
XL_HWTYPE_CSMCAN                 = _XL_HWTYPE_CSMCAN
XL_HWTYPE_VN5610A                = _XL_HWTYPE_VN5610A
XL_HWTYPE_VN7640                 = _XL_HWTYPE_VN7640
XL_MAX_HWTYPE                    = _XL_MAX_HWTYPE

# BusType
XL_BUS_TYPE_NONE     = _XL_BUS_TYPE_NONE
XL_BUS_TYPE_CAN      = _XL_BUS_TYPE_CAN
XL_BUS_TYPE_LIN      = _XL_BUS_TYPE_LIN
XL_BUS_TYPE_FLEXRAY  = _XL_BUS_TYPE_FLEXRAY
XL_BUS_TYPE_AFDX     = _XL_BUS_TYPE_AFDX
XL_BUS_TYPE_MOST     = _XL_BUS_TYPE_MOST
XL_BUS_TYPE_DAIO     = _XL_BUS_TYPE_DAIO
XL_BUS_TYPE_J1708    = _XL_BUS_TYPE_J1708
XL_BUS_TYPE_ETHERNET = _XL_BUS_TYPE_ETHERNET
XL_BUS_TYPE_A429     = _XL_BUS_TYPE_A429

# interface version for our events
XL_INTERFACE_VERSION_V2 = _XL_INTERFACE_VERSION_V2
XL_INTERFACE_VERSION_V3 = _XL_INTERFACE_VERSION_V3 
XL_INTERFACE_VERSION_V4 = _XL_INTERFACE_VERSION_V4 # for MOST,CAN FD, Ethernet, FlexRay, ARINC429
XL_INTERFACE_VERSION    = _XL_INTERFACE_VERSION       # forCAN, LIN, DAIO.

# porthandle
XL_INVALID_PORTHANDLE = _XL_INVALID_PORTHANDLE

# defines for XLbusParams::data::can/canFD::canOpMode
XL_BUS_PARAMS_CANOPMODE_CAN20 = _XL_BUS_PARAMS_CANOPMODE_CAN20
XL_BUS_PARAMS_CANOPMODE_CANFD = _XL_BUS_PARAMS_CANOPMODE_CANFD

# ARINC429 types and definitions
XL_A429_MSG_CHANNEL_DIR_TX = _XL_A429_MSG_CHANNEL_DIR_TX
XL_A429_MSG_CHANNEL_DIR_RX = _XL_A429_MSG_CHANNEL_DIR_RX
XL_A429_MSG_BITRATE_SLOW_MIN = _XL_A429_MSG_BITRATE_SLOW_MIN
XL_A429_MSG_BITRATE_SLOW_MAX = _XL_A429_MSG_BITRATE_SLOW_MAX
XL_A429_MSG_BITRATE_FAST_MIN = _XL_A429_MSG_BITRATE_FAST_MIN
XL_A429_MSG_BITRATE_FAST_MAX = _XL_A429_MSG_BITRATE_FAST_MAX
XL_A429_MSG_GAP_4BIT = _XL_A429_MSG_GAP_4BIT
XL_A429_MSG_BITRATE_RX_MIN = _XL_A429_MSG_BITRATE_RX_MIN
XL_A429_MSG_BITRATE_RX_MAX = _XL_A429_MSG_BITRATE_RX_MAX
XL_A429_MSG_AUTO_BAUDRATE_DISABLED = _XL_A429_MSG_AUTO_BAUDRATE_DISABLED
XL_A429_MSG_AUTO_BAUDRATE_ENABLED = _XL_A429_MSG_AUTO_BAUDRATE_ENABLED
XL_A429_MSG_FLAG_ON_REQUEST = _XL_A429_MSG_FLAG_ON_REQUEST
XL_A429_MSG_FLAG_CYCLIC = _XL_A429_MSG_FLAG_CYCLIC
XL_A429_MSG_FLAG_DELETE_CYCLIC = _XL_A429_MSG_FLAG_DELETE_CYCLIC
XL_A429_MSG_CYCLE_MAX = _XL_A429_MSG_CYCLE_MAX
XL_A429_MSG_GAP_DEFAULT = _XL_A429_MSG_GAP_DEFAULT
XL_A429_MSG_GAP_MAX = _XL_A429_MSG_GAP_MAX
XL_A429_MSG_PARITY_DEFAULT = _XL_A429_MSG_PARITY_DEFAULT
XL_A429_MSG_PARITY_DISABLED = _XL_A429_MSG_PARITY_DISABLED
XL_A429_MSG_PARITY_ODD = _XL_A429_MSG_PARITY_ODD
XL_A429_MSG_PARITY_EVEN = _XL_A429_MSG_PARITY_EVEN
XL_A429_EV_TX_MSG_CTRL_ON_REQUEST = _XL_A429_EV_TX_MSG_CTRL_ON_REQUEST
XL_A429_EV_TX_MSG_CTRL_CYCLIC = _XL_A429_EV_TX_MSG_CTRL_CYCLIC
XL_A429_EV_TX_ERROR_ACCESS_DENIED = _XL_A429_EV_TX_ERROR_ACCESS_DENIED
XL_A429_EV_TX_ERROR_TRANSMISSION_ERROR = _XL_A429_EV_TX_ERROR_TRANSMISSION_ERROR
XL_A429_EV_RX_ERROR_GAP_VIOLATION = _XL_A429_EV_RX_ERROR_GAP_VIOLATION
XL_A429_EV_RX_ERROR_PARITY = _XL_A429_EV_RX_ERROR_PARITY
XL_A429_EV_RX_ERROR_BITRATE_LOW = _XL_A429_EV_RX_ERROR_BITRATE_LOW
XL_A429_EV_RX_ERROR_BITRATE_HIGH = _XL_A429_EV_RX_ERROR_BITRATE_HIGH
XL_A429_EV_RX_ERROR_FRAME_FORMAT = _XL_A429_EV_RX_ERROR_FRAME_FORMAT
XL_A429_EV_RX_ERROR_CODING_RZ = _XL_A429_EV_RX_ERROR_CODING_RZ
XL_A429_EV_RX_ERROR_DUTY_FACTOR = _XL_A429_EV_RX_ERROR_DUTY_FACTOR
XL_A429_EV_RX_ERROR_AVG_BIT_LENGTH = _XL_A429_EV_RX_ERROR_AVG_BIT_LENGTH
XL_A429_QUEUE_OVERFLOW = _XL_A429_QUEUE_OVERFLOW
XL_A429_RX_FIFO_QUEUE_SIZE_MAX = _XL_A429_RX_FIFO_QUEUE_SIZE_MAX
XL_A429_RX_FIFO_QUEUE_SIZE_MIN = _XL_A429_RX_FIFO_QUEUE_SIZE_MIN

# driver status
XL_SUCCESS                       = _XL_SUCCESS
XL_PENDING                       = _XL_PENDING
XL_ERR_QUEUE_IS_EMPTY            = _XL_ERR_QUEUE_IS_EMPTY
XL_ERR_QUEUE_IS_FULL             = _XL_ERR_QUEUE_IS_FULL
XL_ERR_TX_NOT_POSSIBLE           = _XL_ERR_TX_NOT_POSSIBLE
XL_ERR_NO_LICENSE                = _XL_ERR_NO_LICENSE
XL_ERR_WRONG_PARAMETER           = _XL_ERR_WRONG_PARAMETER
XL_ERR_TWICE_REGISTER            = _XL_ERR_TWICE_REGISTER
XL_ERR_INVALID_CHAN_INDEX        = _XL_ERR_INVALID_CHAN_INDEX
XL_ERR_INVALID_ACCESS            = _XL_ERR_INVALID_ACCESS
XL_ERR_PORT_IS_OFFLINE           = _XL_ERR_PORT_IS_OFFLINE
XL_ERR_CHAN_IS_ONLINE            = _XL_ERR_CHAN_IS_ONLINE
XL_ERR_NOT_IMPLEMENTED           = _XL_ERR_NOT_IMPLEMENTED
XL_ERR_INVALID_PORT              = _XL_ERR_INVALID_PORT
XL_ERR_HW_NOT_READY              = _XL_ERR_HW_NOT_READY
XL_ERR_CMD_TIMEOUT               = _XL_ERR_CMD_TIMEOUT
XL_ERR_CMD_HANDLING              = _XL_ERR_CMD_HANDLING
XL_ERR_HW_NOT_PRESENT            = _XL_ERR_HW_NOT_PRESENT
XL_ERR_NOTIFY_ALREADY_ACTIVE     = _XL_ERR_NOTIFY_ALREADY_ACTIVE
XL_ERR_INVALID_TAG               = _XL_ERR_INVALID_TAG
XL_ERR_INVALID_RESERVED_FLD      = _XL_ERR_INVALID_RESERVED_FLD
XL_ERR_INVALID_SIZE              = _XL_ERR_INVALID_SIZE
XL_ERR_INSUFFICIENT_BUFFER       = _XL_ERR_INSUFFICIENT_BUFFER
XL_ERR_ERROR_CRC                 = _XL_ERR_ERROR_CRC
XL_ERR_BAD_EXE_FORMAT            = _XL_ERR_BAD_EXE_FORMAT
XL_ERR_NO_SYSTEM_RESOURCES       = _XL_ERR_NO_SYSTEM_RESOURCES
XL_ERR_NOT_FOUND                 = _XL_ERR_NOT_FOUND
XL_ERR_INVALID_ADDRESS           = _XL_ERR_INVALID_ADDRESS
XL_ERR_REQ_NOT_ACCEP             = _XL_ERR_REQ_NOT_ACCEP
XL_ERR_INVALID_LEVEL             = _XL_ERR_INVALID_LEVEL
XL_ERR_NO_DATA_DETECTED          = _XL_ERR_NO_DATA_DETECTED
XL_ERR_INTERNAL_ERROR            = _XL_ERR_INTERNAL_ERROR
XL_ERR_UNEXP_NET_ERR             = _XL_ERR_UNEXP_NET_ERR
XL_ERR_INVALID_USER_BUFFER       = _XL_ERR_INVALID_USER_BUFFER
XL_ERR_NO_RESOURCES              = _XL_ERR_NO_RESOURCES
XL_ERR_WRONG_CHIP_TYPE           = _XL_ERR_WRONG_CHIP_TYPE
XL_ERR_WRONG_COMMAND             = _XL_ERR_WRONG_COMMAND
XL_ERR_INVALID_HANDLE            = _XL_ERR_INVALID_HANDLE
XL_ERR_RESERVED_NOT_ZERO         = _XL_ERR_RESERVED_NOT_ZERO
XL_ERR_INIT_ACCESS_MISSING       = _XL_ERR_INIT_ACCESS_MISSING
XL_ERR_CANNOT_OPEN_DRIVER        = _XL_ERR_CANNOT_OPEN_DRIVER
XL_ERR_WRONG_BUS_TYPE            = _XL_ERR_WRONG_BUS_TYPE
XL_ERR_DLL_NOT_FOUND             = _XL_ERR_DLL_NOT_FOUND
XL_ERR_INVALID_CHANNEL_MASK      = _XL_ERR_INVALID_CHANNEL_MASK
XL_ERR_NOT_SUPPORTED             = _XL_ERR_NOT_SUPPORTED
XL_ERR_CONNECTION_BROKEN         = _XL_ERR_CONNECTION_BROKEN
XL_ERR_CONNECTION_CLOSED         = _XL_ERR_CONNECTION_CLOSED
XL_ERR_INVALID_STREAM_NAME       = _XL_ERR_INVALID_STREAM_NAME
XL_ERR_CONNECTION_FAILED         = _XL_ERR_CONNECTION_FAILED
XL_ERR_STREAM_NOT_FOUND          = _XL_ERR_STREAM_NOT_FOUND
XL_ERR_STREAM_NOT_CONNECTED      = _XL_ERR_STREAM_NOT_CONNECTED
XL_ERR_QUEUE_OVERRUN             = _XL_ERR_QUEUE_OVERRUN
XL_ERROR                         = _XL_ERROR
XL_ERR_INVALID_DLC               = _XL_ERR_INVALID_DLC
XL_ERR_INVALID_CANID             = _XL_ERR_INVALID_CANID
XL_ERR_INVALID_FDFLAG_MODE20     = _XL_ERR_INVALID_FDFLAG_MODE20
XL_ERR_EDL_RTR                   = _XL_ERR_EDL_RTR
XL_ERR_EDL_NOT_SET               = _XL_ERR_EDL_NOT_SET
XL_ERR_UNKNOWN_FLAG              = _XL_ERR_UNKNOWN_FLAG
XL_ERR_ETH_PHY_ACTIVATION_FAILED = _XL_ERR_ETH_PHY_ACTIVATION_FAILED
XL_ERR_ETH_MAC_RESET_FAILED      = _XL_ERR_ETH_MAC_RESET_FAILED
XL_ERR_ETH_MAC_NOT_READY         = _XL_ERR_ETH_MAC_NOT_READY
XL_ERR_ETH_PHY_CONFIG_ABORTED    = _XL_ERR_ETH_PHY_CONFIG_ABORTED
XL_ERR_ETH_RESET_FAILED          = _XL_ERR_ETH_RESET_FAILED
XL_ERR_ETH_SET_CONFIG_DELAYED    = _XL_ERR_ETH_SET_CONFIG_DELAYED
XL_ERR_ETH_UNSUPPORTED_FEATURE   = _XL_ERR_ETH_UNSUPPORTED_FEATURE
XL_ERR_ETH_MAC_ACTIVATION_FAILED = _XL_ERR_ETH_MAC_ACTIVATION_FAILED
XL_ERR_ETH_FILTER_INVALID        = _XL_ERR_ETH_FILTER_INVALID
XL_ERR_ETH_FILTER_UNAVAILABLE    = _XL_ERR_ETH_FILTER_UNAVAILABLE
XL_ERR_ETH_FILTER_NO_INIT_ACCESS = _XL_ERR_ETH_FILTER_NO_INIT_ACCESS
XL_ERR_ETH_FILTER_TOO_COMPLEX    = _XL_ERR_ETH_FILTER_TOO_COMPLEX

XL_ACTIVATE_NONE        = _XL_ACTIVATE_NONE
XL_ACTIVATE_RESET_CLOCK = _XL_ACTIVATE_RESET_CLOCK

XL_CAN_EXT_MSG_ID            = _XL_CAN_EXT_MSG_ID
XL_CAN_MSG_FLAG_ERROR_FRAME  = _XL_CAN_MSG_FLAG_ERROR_FRAME
XL_CAN_MSG_FLAG_OVERRUN      = _XL_CAN_MSG_FLAG_OVERRUN
XL_CAN_MSG_FLAG_NERR         = _XL_CAN_MSG_FLAG_NERR
XL_CAN_MSG_FLAG_WAKEUP       = _XL_CAN_MSG_FLAG_WAKEUP
XL_CAN_MSG_FLAG_REMOTE_FRAME = _XL_CAN_MSG_FLAG_REMOTE_FRAME
XL_CAN_MSG_FLAG_RESERVED_1   = _XL_CAN_MSG_FLAG_RESERVED_1
XL_CAN_MSG_FLAG_TX_COMPLETED = _XL_CAN_MSG_FLAG_TX_COMPLETED
XL_CAN_MSG_FLAG_TX_REQUEST   = _XL_CAN_MSG_FLAG_TX_REQUEST
XL_CAN_MSG_FLAG_SRR_BIT_DOM  = _XL_CAN_MSG_FLAG_SRR_BIT_DOM
XL_EVENT_FLAG_OVERRUN        = _XL_EVENT_FLAG_OVERRUN
XL_LIN_MSGFLAG_TX            = _XL_LIN_MSGFLAG_TX
XL_LIN_MSGFLAG_CRCERROR      = _XL_LIN_MSGFLAG_CRCERROR
