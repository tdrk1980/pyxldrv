# *-* encoding: utf-8 *-*

# vxlapi.h expects <windows.h>
cdef extern from "<windows.h>":
    pass

cdef extern from "vxlapi.h":
    cdef:
        DEF XL_MAX_LENGTH          = 31
        DEF XL_CONFIG_MAX_CHANNELS = 64
        DEF XL_INVALID_PORTHANDLE  = -1
        DEF MAX_MSG_LEN = 8

        ctypedef short XLstatus
        ctypedef unsigned long long XLuint64
        ctypedef XLuint64 XLaccess
        ctypedef long XLportHandle
        ctypedef void* HANDLE
        ctypedef HANDLE XLhandle
    
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

        struct s_xl_can_msg:
            unsigned long     id
            unsigned short    flags
            unsigned short    dlc
            XLuint64          res1
            unsigned char     data[MAX_MSG_LEN]
            XLuint64          res2
        
        struct s_xl_chip_state:
            unsigned char busStatus
            unsigned char txErrorCounter
            unsigned char rxErrorCounter

        struct s_xl_transceiver:
            unsigned char  event_reason
            unsigned char  is_present

        struct s_xl_lin_msg:
            unsigned char id
            unsigned char dlc
            unsigned short flags
            unsigned char data[8]
            unsigned char crc

        struct s_xl_lin_sleep:
            unsigned char flag

        struct s_xl_lin_no_ans:
            unsigned char id

        struct s_xl_lin_wake_up:
            unsigned char flag
            unsigned char unused[3]
            unsigned int  startOffs
            unsigned int  width

        struct s_xl_lin_crc_info:
            unsigned char id
            unsigned char flags

        union  s_xl_lin_msg_api:
            s_xl_lin_msg           linMsg
            s_xl_lin_no_ans        linNoAns
            s_xl_lin_wake_up       linWakeUp
            s_xl_lin_sleep         linSleep
            s_xl_lin_crc_info      linCRCinfo

        ctypedef struct XL_IO_DIGITAL_DATA:
            unsigned int digitalInputData

        ctypedef struct XL_IO_ANALOG_DATA:
            unsigned int measuredAnalogData0
            unsigned int measuredAnalogData1
            unsigned int measuredAnalogData2
            unsigned int measuredAnalogData3

        union st_dio_data:
            XL_IO_DIGITAL_DATA  digital
            XL_IO_ANALOG_DATA   analog

        struct s_xl_daio_piggy_data:
            unsigned int daioEvtTag
            unsigned int triggerType
            st_dio_data  data

        struct s_xl_daio_data:
                unsigned short    flags
                unsigned int      timestamp_correction
                unsigned char     mask_digital
                unsigned char     value_digital
                unsigned char     mask_analog
                unsigned char     reserved0
                unsigned short    value_analog[4]
                unsigned int      pwm_frequency
                unsigned short    pwm_value
                unsigned int      reserved1
                unsigned int      reserved2

        struct s_xl_sync_pulse_ev:
            unsigned int      triggerSource
            unsigned int      reserved
            XLuint64          time

        struct s_xl_sync_pulse:
            unsigned char     pulseCode
            XLuint64          time

        union s_xl_tag_data:
            s_xl_can_msg           msg
            s_xl_chip_state        chipState
            s_xl_lin_msg_api       linMsgApi
            s_xl_sync_pulse        syncPulse
            s_xl_daio_data         daioData
            s_xl_transceiver       transceiver
            s_xl_daio_piggy_data   daioPiggyData

        ctypedef unsigned char  XLeventTag
        ctypedef struct s_xl_event:
            XLeventTag             tag
            unsigned char          chanIndex
            unsigned short         transId
            unsigned short         portHandle
            unsigned char          flags
            unsigned char          reserved
            XLuint64               timeStamp
            s_xl_tag_data          tagData
        
        ctypedef s_xl_event XLevent

        ctypedef char *XLstringType
        
        ctypedef struct XLchipParams:
            unsigned long bitRate
            unsigned char sjw
            unsigned char tseg1
            unsigned char tseg2
            unsigned char sam
