# *-* encoding: utf-8 *-*

# vxlapi.h expects <windows.h>
cdef extern from "<windows.h>":
    pass

cdef extern from "vxlapi.h":
    cdef:
        DEF XL_MAX_LENGTH          = 31
        DEF XL_CONFIG_MAX_CHANNELS = 64

        ctypedef short XLstatus
        ctypedef unsigned long long XLuint64
        ctypedef XLuint64 XLaccess
    
        struct st_can:
            unsigned int    bitRate
            unsigned char   sjw
            unsigned char   tseg1
            unsigned char   tseg2
            unsigned char   sam
            unsigned char   outputMode
            unsigned char   reserved[7]
            unsigned char   canOpMode

        struct st_canFD:
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

        struct st_most:
            unsigned int  activeSpeedGrade
            unsigned int  compatibleSpeedGrade
            unsigned int  inicFwVersion

        struct st_flexray:
            unsigned int  status
            unsigned int  cfgMode
            unsigned int  baudrate

        struct st_ethernet:
            unsigned char macAddr[6]
            unsigned char connector
            unsigned char phy
            unsigned char link
            unsigned char speed
            unsigned char clockMode
            unsigned char bypass

        struct st_tx:
            unsigned int bitrate
            unsigned int parity
            unsigned int minGap

        struct st_rx:
            unsigned int bitrate
            unsigned int minBitrate
            unsigned int maxBitrate
            unsigned int parity
            unsigned int minGap
            unsigned int autoBaudrate
    
        union union_dir:
            st_tx tx
            st_rx rx
            unsigned char raw[24]

        struct st_a429:
            unsigned short  channelDirection
            unsigned short  res1
            union_dir       dir
        
        union union_data:
            st_can      can
            st_canFD    canFD
            st_most     most
            st_flexray  flexray
            st_ethernet ethernet
            st_a429     a429
            unsigned char raw[28]

        struct XLbusParams:
            unsigned int    busType
            union_data      data

        struct XL_CHANNEL_CONFIG:
            char                name[XL_MAX_LENGTH + 1]
            unsigned char       hwType
            unsigned char       hwIndex
            unsigned char       hwChannel
            unsigned short      transceiverType
            unsigned short      transceiverState
            unsigned short      configError
            unsigned char       channelIndex
            XLuint64            channelMask
            unsigned int        channelCapabilities
            unsigned int        channelBusCapabilities      
            unsigned char       isOnBus
            unsigned int        connectedBusType
            XLbusParams         busParams
            unsigned int        _doNotUse                                             
            unsigned int        driverVersion
            unsigned int        interfaceVersion
            unsigned int        raw_data[10]       
            unsigned int        serialNumber
            unsigned int        articleNumber                 
            char                transceiverName [XL_MAX_LENGTH + 1]                    
            unsigned int        specialCabFlags
            unsigned int        dominantTimeout
            unsigned char       dominantRecessiveDelay
            unsigned char       recessiveDominantDelay
            unsigned char       connectionInfo
            unsigned char       currentlyAvailableTimestamps
            unsigned short      minimalSupplyVoltage
            unsigned short      maximalSupplyVoltage
            unsigned int        maximalBaudrate
            unsigned char       fpgaCoreCapabilities
            unsigned char       specialDeviceStatus
            unsigned short      channelBusActiveCapabilities
            unsigned short      breakOffset
            unsigned short      delimiterOffset
            unsigned int        reserved[3]

        struct XL_DRIVER_CONFIG:
            unsigned int        dllVersion
            unsigned int        channelCount
            unsigned int        reserved[10]
            XL_CHANNEL_CONFIG   channel[XL_CONFIG_MAX_CHANNELS]
    
        ctypedef XL_DRIVER_CONFIG  XLdriverConfig

