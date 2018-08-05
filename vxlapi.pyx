# *-* encoding: utf-8 *-*

from libc.string cimport memset

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

    int _XL_BUS_PARAMS_CANOPMODE_CAN20  "XL_BUS_PARAMS_CANOPMODE_CAN20"
    int _XL_BUS_PARAMS_CANOPMODE_CANFD  "XL_BUS_PARAMS_CANOPMODE_CANFD"


    int XL_A429_MSG_CHANNEL_DIR_TX
    int XL_A429_MSG_CHANNEL_DIR_RX


    XLstatus xlOpenDriver()
    XLstatus xlCloseDriver()

    XLaccess xlGetChannelMask(int hwType, int hwIndex, int hwChannel)

    XLstatus xlOpenPort(XLportHandle* portHandle, char* userName, XLaccess accessMask, XLaccess* permissionMask, unsigned int rxQueueSize, unsigned int xlInterfaceVersion, unsigned int busType)
    XLstatus xlClosePort(XLportHandle portHandle)

    XLstatus xlActivateChannel(XLportHandle portHandle, XLaccess accessMask, unsigned int busType, unsigned int flags)
    XLstatus xlDeactivateChannel(XLportHandle portHandle, XLaccess accessMask)

    XLstatus xlCanTransmit(XLportHandle portHandle, XLaccess accessMask, unsigned int* messageCount, void* pMessage)
    XLstatus xlReceive(XLportHandle portHandle, unsigned int *pEventCount, XLevent *pEventList)
    
    XLstringType xlGetEventString(XLevent* ev)
    const char* xlGetErrorString(XLstatus err)

    XLstatus xlGetApplConfig(char *appName, unsigned int appChannel, unsigned int *pHwType, unsigned int *pHwIndex, unsigned int *pHwChannel, unsigned int busType)
    XLstatus xlSetApplConfig(char *appName, unsigned int appChannel, unsigned int hwType, unsigned int hwIndex, unsigned int hwChannel, unsigned int busType)
    XLstatus xlGetDriverConfig(XLdriverConfig *pDriverConfig)

    XLstatus xlPopupHwConfig(char* callSign, unsigned int waitForFinish)



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

cpdef CanTransmit(XLportHandle portHandle, XLaccess accessMask, list messageCount, dict pMessage):
    cdef XLstatus status = 0
    cdef unsigned int message_count = messageCount[0]
    cdef XLevent xlEvent

    XL_TRANSMIT_MSG  = 10

    memset(&xlEvent, 0, sizeof(xlEvent))
    xlEvent.tag                 = <unsigned char>XL_TRANSMIT_MSG
    xlEvent.tagData.msg.id      = 0x123
    xlEvent.tagData.msg.dlc     = 8
    xlEvent.tagData.msg.flags   = 0
    xlEvent.tagData.msg.data[0] = 1
    xlEvent.tagData.msg.data[1] = 2
    xlEvent.tagData.msg.data[2] = 3
    xlEvent.tagData.msg.data[3] = 4
    xlEvent.tagData.msg.data[4] = 5
    xlEvent.tagData.msg.data[5] = 6
    xlEvent.tagData.msg.data[6] = 7
    xlEvent.tagData.msg.data[7] = 8
    
    status = xlCanTransmit(portHandle, accessMask, &message_count, &xlEvent)
    
    messageCount[0] = message_count
    return status



cpdef Receive(XLportHandle portHandle, list pEventCount, list pEventList):
    cdef XLstatus status = 0
    cdef XLevent xlEvent
    cdef unsigned int eventCount = 1
    memset(&xlEvent, 0, sizeof(xlEvent))

    statsus = xlReceive(portHandle, &eventCount, &xlEvent)

    pEventCount[0] = eventCount
    pEventList[0] = xlGetEventString(&xlEvent)
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
XL_BUS_TYPE_NONE = _XL_BUS_TYPE_NONE
XL_BUS_TYPE_CAN = _XL_BUS_TYPE_CAN
XL_BUS_TYPE_LIN = _XL_BUS_TYPE_LIN
XL_BUS_TYPE_FLEXRAY = _XL_BUS_TYPE_FLEXRAY
XL_BUS_TYPE_AFDX = _XL_BUS_TYPE_AFDX
XL_BUS_TYPE_MOST = _XL_BUS_TYPE_MOST
XL_BUS_TYPE_DAIO = _XL_BUS_TYPE_DAIO
XL_BUS_TYPE_J1708 = _XL_BUS_TYPE_J1708
XL_BUS_TYPE_ETHERNET = _XL_BUS_TYPE_ETHERNET
XL_BUS_TYPE_A429 = _XL_BUS_TYPE_A429

# interface version for our events
XL_INTERFACE_VERSION_V2 = _XL_INTERFACE_VERSION_V2
XL_INTERFACE_VERSION_V3 = _XL_INTERFACE_VERSION_V3 
XL_INTERFACE_VERSION_V4 = _XL_INTERFACE_VERSION_V4 # for MOST,CAN FD, Ethernet, FlexRay, ARINC429
XL_INTERFACE_VERSION = _XL_INTERFACE_VERSION       # forCAN, LIN, DAIO.


# defines for XLbusParams::data::can/canFD::canOpMode
XL_BUS_PARAMS_CANOPMODE_CAN20 = _XL_BUS_PARAMS_CANOPMODE_CAN20
XL_BUS_PARAMS_CANOPMODE_CANFD = _XL_BUS_PARAMS_CANOPMODE_CANFD
