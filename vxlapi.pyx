# *-* encoding: utf-8 *-*

# vxlapi.h expects <windows.h>
cdef extern from "<windows.h>":
    pass

cdef extern from "vxlapi.h":
    ctypedef short XLstatus
    XLstatus xlOpenDriver()
    XLstatus xlCloseDriver()
    const char *xlGetErrorString(XLstatus err)

def OpenDriver():
    return xlOpenDriver()

def CloseDriver():
    return xlCloseDriver()

def GetErrorString(XLstatus err):
    return xlGetErrorString(err)


