# *-* encoding: utf-8 *-*

# vxlapi.h expects <windows.h>
cdef extern from "<windows.h>":
    pass

cdef extern from "vxlapi.h":
    unsigned int XL_MAX_LENGTH
    unsigned int XL_CONFIG_MAX_CHANNELS

    ctypedef short XLstatus
    ctypedef unsigned long long XLuint64
    
    ctypedef struct can:
        unsigned int bitRate
        unsigned char sjw
        unsigned char tseg1
        unsigned char tseg2
        unsigned char sam
        unsigned char outputMode
        unsigned char reserved[7]
        unsigned char canOpMode
