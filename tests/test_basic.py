# *-* encoding: utf-8 *-*
# python -m unittest tests.test_basic
import unittest
import inspect
import vxlapi as xl
from pprint import pprint

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

        message_count = [1]
        status = xl.CanTransmit(self.portHandle[0], self.accessMask, message_count, {"a":1})
        self.assertEqual(status, xl.XL_SUCCESS)

        eventcount=[1]
        eventstring=[""]
        status = xl.Receive(self.portHandle[0],eventcount,eventstring)
        self.assertEqual(status, xl.XL_SUCCESS)
        self.assertEqual(eventcount[0], 1)

        eventcount=[1]
        eventstring=[""]
        status = xl.Receive(self.portHandle[0],eventcount,eventstring)
        self.assertEqual(status, xl.XL_SUCCESS)
        self.assertEqual(eventcount[0], 0)

if __name__ == '__main__':
    unittest.main()
