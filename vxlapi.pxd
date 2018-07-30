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

    ctypedef struct canFD:
      unsigned int  arbitrationBitRate
      unsigned char sjwAbr
      unsigned char tseg1Abr
      unsigned char tseg2Abr
      unsigned char samAbr
      unsigned char outputMode
      unsigned char sjwDbr
      unsigned char tseg1Dbr
      unsigned char tseg2Dbr
      unsigned int  dataBitRate
      unsigned char canOpMode

    ctypedef struct most:
      unsigned int  activeSpeedGrade
      unsigned int  compatibleSpeedGrade
      unsigned int  inicFwVersion

    ctypedef struct flexray:
      unsigned int  status
      unsigned int  cfgMode
      unsigned int  baudrate

    ctypedef struct ethernet:
      unsigned char macAddr[6]
      unsigned char connector
      unsigned char phy
      unsigned char link
      unsigned char speed
      unsigned char clockMode
      unsigned char bypass

    struct tx:
        unsigned int bitrate
        unsigned int parity
        unsigned int minGap

    struct rx:
        unsigned int bitrate
        unsigned int minBitrate
        unsigned int maxBitrate
        unsigned int parity
        unsigned int minGap
        unsigned int autoBaudrate

    ctypedef struct XLbusParams:
        unsigned int busType
