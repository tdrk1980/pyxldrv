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
    XLstatus xlOpenDriver()
    XLstatus xlCloseDriver()

    const char *xlGetErrorString(XLstatus err)

    XLstatus xlGetApplConfig(char *appName, unsigned int appChannel, unsigned int *pHwType, unsigned int *pHwIndex, unsigned int *pHwChannel, unsigned int busType)
    XLstatus xlSetApplConfig(char *appName, unsigned int appChannel, unsigned int hwType, unsigned int hwIndex, unsigned int hwChannel, unsigned int busType)
    XLstatus xlGetDriverConfig(XLdriverConfig *pDriverConfig)

cpdef OpenDriver():
    return xlOpenDriver()

cpdef CloseDriver():
    return xlCloseDriver()

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

    pDriverConfig["dllVersion"] = driverConfig.dllVersion
    pDriverConfig["channelCount"] = driverConfig.channelCount

    channel = []
    for i in range(driverConfig.channelCount):
        ch = {}
        ch["name"]    = bytes(driverConfig.channel[i].name)
        ch["hwType"]  = driverConfig.channel[i].hwType
        ch["hwIndex"] = driverConfig.channel[i].hwIndex
        ch["transceiverType"] = driverConfig.channel[i].transceiverType
        ch["transceiverState"] = driverConfig.channel[i].transceiverState
        ch["configError"] = driverConfig.channel[i].configError
        ch["channelIndex"] = driverConfig.channel[i].channelIndex
        ch["channelMask"] = driverConfig.channel[i].channelMask
        ch["channelCapabilities"] = driverConfig.channel[i].channelCapabilities
        ch["channelBusCapabilities"] = driverConfig.channel[i].channelBusCapabilities
        ch["isOnBus"] = driverConfig.channel[i].isOnBus
        ch["connectedBusType"] = driverConfig.channel[i].connectedBusType
        busParams = {}
        busParams["busType"] = driverConfig.channel[i].busParams.busType
        data = {}
        if busParams["busType"]   == XL_BUS_TYPE_NONE:
            pass
        elif busParams["busType"] == XL_BUS_TYPE_CAN:
            can = {}
            can["bitRate"] = driverConfig.channel[i].busParams.data.can.bitRate
            can["sjw"] = driverConfig.channel[i].busParams.data.can.sjw
            can["tseg1"] = driverConfig.channel[i].busParams.data.can.tseg1
            can["tseg2"] = driverConfig.channel[i].busParams.data.can.tseg2
            can["sam"] = driverConfig.channel[i].busParams.data.can.sam
            can["outputMode"] = driverConfig.channel[i].busParams.data.can.outputMode
            can["reserved"] = bytearray([driverConfig.channel[i].busParams.data.can.reserved[j] for j in range(7)])
            can["canOpMode"] = driverConfig.channel[i].busParams.data.can.canOpMode
            data["can"] = can
        else:
            pass
        busParams["data"] = data
        ch["busParams"] = busParams

        channel.append(ch)
    pDriverConfig["channel"] = channel

    return status


