# *-* encoding: utf-8 *-*

# vxlapi.h expects <windows.h>
cdef extern from "<windows.h>":
    pass

cdef extern from "vxlapi.h":
    ctypedef short XLstatus
    XLstatus xlOpenDriver()


def OpenDriver():
    return xlOpenDriver()
