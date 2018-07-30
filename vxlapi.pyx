# *-* encoding: utf-8 *-*

cdef extern from "vxlapi.h":

    XLstatus xlOpenDriver()
    XLstatus xlCloseDriver()

    const char *xlGetErrorString(XLstatus err)

    XLstatus xlGetApplConfig(char *appName, unsigned int appChannel, unsigned int *pHwType, unsigned int *pHwIndex, unsigned int *pHwChannel, unsigned int busType)
    XLstatus xlSetApplConfig(char *appName, unsigned int appChannel, unsigned int hwType, unsigned int hwIndex, unsigned int hwChannel, unsigned int busType)


cpdef OpenDriver():
    return xlOpenDriver()

cpdef CloseDriver():
    return xlCloseDriver()

cpdef GetErrorString(XLstatus err):
    return xlGetErrorString(err)

def GetApplConfig(char *appName, unsigned int appChannel, pHwType, pHwIndex, pHwChannel, unsigned int busType):
    cdef XLstatus status = 0
    cdef unsigned int hwType    = pHwType[0]
    cdef unsigned int hwIndex   = pHwIndex[0]
    cdef unsigned int hwChannel = pHwChannel[0]

    status = xlGetApplConfig(appName, appChannel, &hwType, &hwIndex, &hwChannel, busType)
    pHwType[0]    = hwType
    pHwIndex[0]   = hwIndex
    pHwChannel[0] = hwChannel

    return status

def SetApplConfig(char *appName, unsigned int appChannel, pHwType, pHwIndex, pHwChannel, unsigned int busType):
    return xlSetApplConfig(appName, appChannel, pHwType[0], pHwIndex[0], pHwChannel[0], busType)