# *-* encoding: utf-8 *-*
# python -m unittest tests.test_basic
import unittest
import inspect
import vxlapi as xl
from pprint import pprint
import chardet


def decode_bin(bin):
    return bin.decode(chardet.detect(bin)["encoding"])

def get_can_bus_params(hwType, hwIndex, hwChannel, busType):
    driverConfig = {}
    xl.GetDriverConfig(driverConfig)
    can_bus_params = None
    for ch in driverConfig["channel"]:
        if (ch["hwType"] == hwType and ch["hwIndex"] == hwIndex and ch["hwChannel"] == hwChannel):
            if ch["busParams"]["busType"] == busType:
                can_bus_params = ch["busParams"]["data"]["can"]
                can_bus_params["name"] = ch["name"]
                can_bus_params["hwType"] = ch["hwType"]
                can_bus_params["hwIndex"] = ch["hwIndex"]
                can_bus_params["hwChannel"] = ch["hwChannel"]
    return can_bus_params

# python -m unittest tests.test_basic.TestOpenCloseDriver
class TestOpenCloseDriver(unittest.TestCase):
    def test_opendriver_close_driver(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])

        status = xl.OpenDriver()
        self.assertEqual(status, xl.XL_SUCCESS)

        status = xl.CloseDriver()
        self.assertEqual(status, xl.XL_SUCCESS)

# python -m unittest tests.test_basic.TestSetGetAppConfig
class TestSetGetAppConfig(unittest.TestCase):
    def setUp(self):
        xl.OpenDriver()

    def tearDown(self):
        xl.CloseDriver()

    def test_setapplconfig_getapplconfig(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])

        # CAN1 -- virtual can bus1.hwch1
        status = xl.SetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=[xl.XL_HWTYPE_VIRTUAL], pHwIndex=[0], pHwChannel=[0], busType=xl.XL_BUS_TYPE_CAN)
        self.assertEqual(status, xl.XL_SUCCESS)

        pHwType = [0xff]
        pHwIndex = [0xff]
        pHwChannel = [0xff]
        status = xl.GetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=pHwType, pHwIndex=pHwIndex, pHwChannel=pHwChannel, busType=xl.XL_BUS_TYPE_CAN)
        self.assertEqual(status, xl.XL_SUCCESS)
        self.assertEqual(pHwType[0], xl.XL_HWTYPE_VIRTUAL)
        self.assertEqual(pHwIndex[0], 0)
        self.assertEqual(pHwChannel[0], 0)

        # CAN2 -- virtual can bus1.hwch2
        status = xl.SetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=1, pHwType=[xl.XL_HWTYPE_VIRTUAL], pHwIndex=[0], pHwChannel=[1], busType=xl.XL_BUS_TYPE_CAN)
        self.assertEqual(status, xl.XL_SUCCESS)

        pHwType = [0xff]
        pHwIndex = [0xff]
        pHwChannel = [0xff]
        status = xl.GetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=1, pHwType=pHwType, pHwIndex=pHwIndex, pHwChannel=pHwChannel, busType=xl.XL_BUS_TYPE_CAN)
        self.assertEqual(status, xl.XL_SUCCESS)
        self.assertEqual(pHwType[0], xl.XL_HWTYPE_VIRTUAL)
        self.assertEqual(pHwIndex[0], 0)
        self.assertEqual(pHwChannel[0], 1)

# python -m unittest tests.test_basic.TestGetDriverConfig
class TestGetDriverConfig(unittest.TestCase):
    def setUp(self):
        xl.OpenDriver()

        self.appName    = bytes("pyxldrv".encode())
        self.appChannel = 0
        self.pHwType    = [xl.XL_HWTYPE_VIRTUAL]
        self.pHwIndex   = [0]
        self.pHwChannel = [0]
        self.busType    = xl.XL_BUS_TYPE_CAN

        xl.SetApplConfig(self.appName, self.appChannel, self.pHwType, self.pHwIndex, self.pHwChannel, self.busType)
        xl.GetApplConfig(self.appName, self.appChannel, self.pHwType, self.pHwIndex, self.pHwChannel, self.busType)

    def tearDown(self):
        xl.CloseDriver()

    def test_getdriverconfig(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])

        driverConfig = {}
        status = xl.GetDriverConfig(driverConfig)
        self.assertEqual(status, xl.XL_SUCCESS)
        # pprint(driverConfig)

# python -m unittest tests.test_basic.TestGetChannelMask
class TestGetChannelMask(unittest.TestCase):
    def setUp(self):
        xl.OpenDriver()

        self.appName    = bytes("pyxldrv".encode())
        self.appChannel = 0
        self.pHwType    = [xl.XL_HWTYPE_VIRTUAL]
        self.pHwIndex   = [0]
        self.pHwChannel = [0]
        self.busType    = xl.XL_BUS_TYPE_CAN

        xl.SetApplConfig(self.appName, self.appChannel, self.pHwType, self.pHwIndex, self.pHwChannel, self.busType)
        xl.GetApplConfig(self.appName, self.appChannel, self.pHwType, self.pHwIndex, self.pHwChannel, self.busType)

    def tearDown(self):
        xl.CloseDriver()

    def test_getchannelmask(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])
        
        accessMask = xl.GetChannelMask(self.pHwType[0], self.pHwIndex[0], self.pHwChannel[0])
        self.assertNotEqual(accessMask,0)

# python -m unittest tests.test_basic.TestOpenClosePort
class TestOpenClosePort(unittest.TestCase):
    def setUp(self):
        xl.OpenDriver()

        self.appName    = bytes("pyxldrv".encode())
        self.appChannel = 0
        self.pHwType    = [xl.XL_HWTYPE_VIRTUAL]
        self.pHwIndex   = [0]
        self.pHwChannel = [0]
        self.busType    = xl.XL_BUS_TYPE_CAN

        xl.SetApplConfig(self.appName, self.appChannel, self.pHwType, self.pHwIndex, self.pHwChannel, self.busType)
        xl.GetApplConfig(self.appName, self.appChannel, self.pHwType, self.pHwIndex, self.pHwChannel, self.busType)

        self.accessMask = xl.GetChannelMask(self.pHwType[0],self.pHwIndex[0],self.pHwChannel[0])

    def tearDown(self):
        xl.CloseDriver()

    def test_openport_closeport(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])

        portHandle      = [xl.XL_INVALID_PORTHANDLE]
        permissionMask  = [self.accessMask]
        rxQueueSize     = 2^10
        appName         = self.appName
        accessMask      = self.accessMask
        xlInterfaceVersion = xl.XL_INTERFACE_VERSION
        busType         = self.busType

        status = xl.OpenPort(portHandle, appName, accessMask, permissionMask, rxQueueSize, xlInterfaceVersion, busType)
        
        self.assertEqual(status, xl.XL_SUCCESS)
        self.assertNotEqual(portHandle, xl.XL_INVALID_PORTHANDLE)
        self.assertEqual(permissionMask[0], self.accessMask)


        status = xl.ClosePort(portHandle[0])
        self.assertEqual(status, xl.XL_SUCCESS)

        status = xl.CloseDriver()
        self.assertEqual(status, xl.XL_SUCCESS)

# python -m unittest tests.test_basic.TestCanSetChannelBitrate
class TestCanSetChannelBitrate(unittest.TestCase):
    def setUp(self):
        xl.OpenDriver()

        self.pHwType        = [xl.XL_HWTYPE_VIRTUAL]
        self.pHwIndex       = [0]
        self.pHwChannel     = [0]
        self.busType        = xl.XL_BUS_TYPE_CAN
        self.appName        = bytes("pyxldrv".encode())
        xl.SetApplConfig(appName=self.appName, appChannel=0, pHwType=self.pHwType, pHwIndex=self.pHwIndex, pHwChannel=self.pHwChannel, busType=self.busType)
        xl.GetApplConfig(appName=self.appName, appChannel=0, pHwType=self.pHwType, pHwIndex=self.pHwIndex, pHwChannel=self.pHwChannel, busType=self.busType)

        self.accessMask = 0
        self.accessMask = xl.GetChannelMask(self.pHwType[0],self.pHwIndex[0],self.pHwChannel[0])

        self.portHandle     = [0]
        self.permissionMask = [self.accessMask]
        self.rxQueueSize    = 2^10
        self.xlInterfaceVersion = xl.XL_INTERFACE_VERSION
        xl.OpenPort(self.portHandle, self.appName, self.accessMask, self.permissionMask, self.rxQueueSize, self.xlInterfaceVersion, self.busType)

    def tearDown(self):
        xl.ClosePort(self.portHandle[0])
        xl.CloseDriver()

    def test_CanSetChannelBitrate(self):

        # 1st
        bitrate = 250_000
        status = xl.CanSetChannelBitrate(self.portHandle[0], self.accessMask, 250_000)
        self.assertEqual(status, xl.XL_SUCCESS)

        # get driver's bitrate
        can_bus_params = get_can_bus_params(self.pHwType[0],self.pHwIndex[0],self.pHwChannel[0], self.busType)
        print(can_bus_params)

        # check result
        self.assertEqual(bitrate, can_bus_params["bitRate"])

        # 2nd
        bitrate = 500_000
        status = xl.CanSetChannelBitrate(self.portHandle[0], self.accessMask, bitrate)
        self.assertEqual(status, xl.XL_SUCCESS)

        # get driver's bitrate
        can_bus_params = get_can_bus_params(self.pHwType[0],self.pHwIndex[0],self.pHwChannel[0], self.busType)
        print(can_bus_params)

        # check result
        self.assertEqual(bitrate, can_bus_params["bitRate"])

        # 3rd
        bitrate = 1_000_000
        status = xl.CanSetChannelBitrate(self.portHandle[0], self.accessMask, bitrate)
        self.assertEqual(status, xl.XL_SUCCESS)

        # get driver's bitrate
        can_bus_params = get_can_bus_params(self.pHwType[0],self.pHwIndex[0],self.pHwChannel[0], self.busType)
        print(can_bus_params)

        # check result
        self.assertEqual(bitrate, can_bus_params["bitRate"])


# python -m unittest tests.test_basic.TestCanSetChannelParams
class TestCanSetChannelParams(unittest.TestCase):
    def setUp(self):
        xl.OpenDriver()

        self.pHwType        = [xl.XL_HWTYPE_VIRTUAL]
        self.pHwIndex       = [0]
        self.pHwChannel     = [0]
        self.busType        = xl.XL_BUS_TYPE_CAN
        self.appName        = bytes("pyxldrv".encode())
        xl.SetApplConfig(appName=self.appName, appChannel=0, pHwType=self.pHwType, pHwIndex=self.pHwIndex, pHwChannel=self.pHwChannel, busType=self.busType)
        xl.GetApplConfig(appName=self.appName, appChannel=0, pHwType=self.pHwType, pHwIndex=self.pHwIndex, pHwChannel=self.pHwChannel, busType=self.busType)

        self.accessMask = 0
        self.accessMask = xl.GetChannelMask(self.pHwType[0],self.pHwIndex[0],self.pHwChannel[0])

        self.portHandle     = [0]
        self.permissionMask = [self.accessMask]
        self.rxQueueSize    = 2^10
        self.xlInterfaceVersion = xl.XL_INTERFACE_VERSION
        xl.OpenPort(self.portHandle, self.appName, self.accessMask, self.permissionMask, self.rxQueueSize, self.xlInterfaceVersion, self.busType)

    def tearDown(self):
        xl.ClosePort(self.portHandle[0])
        xl.CloseDriver()

    def test_CanSetChannelParams(self):
        chipParams = {}
        chipParams["bitRate"] =250_000
        chipParams["sjw"] = 1
        chipParams["tseg1"] = 10
        chipParams["tseg2"] = 5
        chipParams["sam"] = 1
        # status = xl.CanSetChannelParams(self.portHandle[0], self.accessMask, chipParams)
        # self.assertEqual(status, xl.XL_SUCCESS)
        # .{'bitRate': 250000, 'sjw': 1, 'tseg1': 10, 'tseg2': 5, 'sam': 1, 'outputMode': 1, 'reserved[7]': bytearray(b'\x00\x00\x00\x00\x00\x00\x00'), 'canOpMode': 1, 'name': b'Virtual Channel 1', 'hwType': 1, 'hwIndex': 0, 'hwChannel': 0}
        # {'bitRate': 500000, 'sjw': 1, 'tseg1': 10, 'tseg2': 5, 'sam': 1, 'outputMode': 1, 'reserved[7]': bytearray(b'\x00\x00\x00\x00\x00\x00\x00'), 'canOpMode': 1, 'name': b'Virtual Channel 1', 'hwType': 1, 'hwIndex': 0, 'hwChannel': 0}
        # {'bitRate': 1000000, 'sjw': 1, 'tseg1': 5, 'tseg2': 2, 'sam': 1, 'outputMode': 1, 'reserved[7]': bytearray(b'\x00\x00\x00\x00\x00\x00\x00'), 'canOpMode': 1, 'name': b'Virtual Channel 1', 'hwType': 1, 'hwIndex': 0, 'hwChannel': 0}

        
        pass


# python -m unittest tests.test_basic.TestActivateDeactivate
class TestActivateDeactivate(unittest.TestCase):
    def setUp(self):
        xl.OpenDriver()

        self.appName    = bytes("pyxldrv".encode())
        self.appChannel = 0
        self.pHwType    = [xl.XL_HWTYPE_VIRTUAL]
        self.pHwIndex   = [0]
        self.pHwChannel = [0]
        self.busType    = xl.XL_BUS_TYPE_CAN

        xl.SetApplConfig(self.appName, self.appChannel, self.pHwType, self.pHwIndex, self.pHwChannel, self.busType)
        xl.GetApplConfig(self.appName, self.appChannel, self.pHwType, self.pHwIndex, self.pHwChannel, self.busType)

        self.accessMask = xl.GetChannelMask(self.pHwType[0],self.pHwIndex[0],self.pHwChannel[0])

        self.portHandle     = [0]
        self.permissionMask = [self.accessMask]
        self.rxQueueSize    = 2^10
        self.xlInterfaceVersion = xl.XL_INTERFACE_VERSION
        xl.OpenPort(self.portHandle, self.appName, self.accessMask, self.permissionMask, self.rxQueueSize, self.xlInterfaceVersion, self.busType)

    def tearDown(self):
        xl.ClosePort(self.portHandle[0])
        xl.CloseDriver()

    def test_activate_deactivate(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])

        portHandle = self.portHandle[0]
        accessMask = self.accessMask
        busType    = self.busType
        flags      = xl.XL_ACTIVATE_RESET_CLOCK

        status = xl.ActivateChannel(portHandle, accessMask, busType, flags)
        self.assertEqual(status, xl.XL_SUCCESS)

        status = xl.DeactivateChannel(portHandle, accessMask)
        self.assertEqual(status, xl.XL_SUCCESS)

# python -m unittest tests.test_basic.TestCanTransmitReceive
class TestCanTransmitReceive(unittest.TestCase):
    def setUp(self):
        xl.OpenDriver()

        self.pHwType        = [xl.XL_HWTYPE_VIRTUAL]
        self.pHwIndex       = [0]
        self.pHwChannel     = [0]
        self.busType        = xl.XL_BUS_TYPE_CAN
        self.appName        = bytes("pyxldrv".encode())
        xl.SetApplConfig(appName=self.appName, appChannel=0, pHwType=self.pHwType, pHwIndex=self.pHwIndex, pHwChannel=self.pHwChannel, busType=self.busType)
        xl.GetApplConfig(appName=self.appName, appChannel=0, pHwType=self.pHwType, pHwIndex=self.pHwIndex, pHwChannel=self.pHwChannel, busType=self.busType)

        self.accessMask = 0
        self.accessMask = xl.GetChannelMask(self.pHwType[0],self.pHwIndex[0],self.pHwChannel[0])

        self.portHandle     = [0]
        self.permissionMask = [self.accessMask]
        self.rxQueueSize    = 2^10
        self.xlInterfaceVersion = xl.XL_INTERFACE_VERSION
        xl.OpenPort(self.portHandle, self.appName, self.accessMask, self.permissionMask, self.rxQueueSize, self.xlInterfaceVersion, self.busType)

        self.flags      = xl.XL_ACTIVATE_RESET_CLOCK
        xl.ActivateChannel(self.portHandle[0], self.accessMask, self.busType, self.flags)

    def tearDown(self):
        xl.DeactivateChannel(self.portHandle[0], self.accessMask)
        xl.ClosePort(self.portHandle[0])
        xl.CloseDriver()

    def test_cantransmit_receive(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])

        msgs = []
        msgs.append({"flags":0, "id":0x321, "dlc":8, "data":bytearray([0x12,0x34,0x56,0x78,0x9A,0xBC,0xDE,0xF0])})
        msgs.append({"flags":0, "id":0x123, "dlc":3, "data":bytearray([0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF])})
        message_count = [len(msgs)]

        status = xl.CanTransmit(self.portHandle[0], self.accessMask, message_count, msgs)
        self.assertEqual(status, xl.XL_SUCCESS)

        eventcount=[1]
        events=[{}]
        evstr=[""]
        status = xl.Receive(self.portHandle[0],eventcount,events,evstr)
        print(decode_bin(evstr[0]))
        self.assertEqual(status, xl.XL_SUCCESS)

        status = xl.Receive(self.portHandle[0],eventcount,events,evstr)
        print(decode_bin(evstr[0]))
        self.assertEqual(status, xl.XL_SUCCESS)
        # self.assertEqual(eventcount[0], 0)

if __name__ == '__main__':
    unittest.main()
