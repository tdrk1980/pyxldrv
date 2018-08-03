# *-* encoding: utf-8 *-*

cdef extern from "vxlapi.h":
    int XL_BUS_TYPE_NONE
    int XL_BUS_TYPE_CAN
    int XL_BUS_TYPE_LIN
    int XL_BUS_TYPE_FLEXRAY
    int XL_BUS_TYPE_AFDX
    int XL_BUS_TYPE_MOST
    int XL_BUS_TYPE_DAIO
    int XL_BUS_TYPE_J1708
    int XL_BUS_TYPE_ETHERNET
    int XL_BUS_TYPE_A429

    int XL_BUS_PARAMS_CANOPMODE_CAN20
    int XL_BUS_PARAMS_CANOPMODE_CANFD

    int XL_A429_MSG_CHANNEL_DIR_TX
    int XL_A429_MSG_CHANNEL_DIR_RX


    XLstatus xlOpenDriver()
    XLstatus xlCloseDriver()
    XLaccess xlGetChannelMask(int hwType, int hwIndex, int hwChannel)
    XLstatus xlOpenPort(XLportHandle* portHandle, char* userName, XLaccess accessMask, XLaccess* permissionMask, unsigned int rxQueueSize, unsigned int xlInterfaceVersion, unsigned int busType)
    XLstatus xlClosePort(XLportHandle portHandle)

    XLstatus xlActivateChannel(XLportHandle portHandle, XLaccess accessMask, unsigned int busType, unsigned int flags)

    const char *xlGetErrorString(XLstatus err)

    XLstatus xlGetApplConfig(char *appName, unsigned int appChannel, unsigned int *pHwType, unsigned int *pHwIndex, unsigned int *pHwChannel, unsigned int busType)
    XLstatus xlSetApplConfig(char *appName, unsigned int appChannel, unsigned int hwType, unsigned int hwIndex, unsigned int hwChannel, unsigned int busType)
    XLstatus xlGetDriverConfig(XLdriverConfig *pDriverConfig)

cpdef OpenDriver():
    return xlOpenDriver()

cpdef CloseDriver():
    return xlCloseDriver()

cpdef GetChannelMask(int hwType, int hwIndex, int hwChannel):
    return xlGetChannelMask(hwType, hwIndex, hwChannel)

cpdef OpenPort(list portHandle, char* appName, XLaccess accessMask, list permissionMask, unsigned int rxQueueSize, unsigned int xlInterfaceVersion, unsigned int busType):
    cdef XLstatus status = 0
    cdef XLportHandle port_handle = -1 # XL_INVALID_PORTHANDLE
    cdef XLaccess permission_mask = 0

    status = xlOpenPort(&port_handle, appName, accessMask, &permission_mask, rxQueueSize, xlInterfaceVersion, busType)
    
    portHandle[0] = port_handle
    permissionMask[0] = permission_mask
    return status

cpdef ClosePort(XLportHandle portHandle):
    return xlClosePort(portHandle)

cpdef ActivateChannel(XLportHandle portHandle, XLaccess accessMask, unsigned int busType, unsigned int flags):
    return xlActivateChannel(portHandle, accessMask, busType, flags)

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


