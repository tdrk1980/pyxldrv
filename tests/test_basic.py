# *-* encoding: utf-8 *-*
# python -m unittest tests.test_basic
import unittest
import inspect
import vxlapi as xl

XL_SUCCESS = 0

XL_HWTYPE_VIRTUAL = 1

XL_BUS_TYPE_CAN = 0x00000001
XL_INTERFACE_VERSION_V3 = 3
XL_INTERFACE_VERSION_V4 = 4 # XL_INTERFACE_VERSION_V4 for MOST,CAN FD, Ethernet, FlexRay, ARINC429
XL_INTERFACE_VERSION = XL_INTERFACE_VERSION_V3 # XL_INTERFACE_VERSION for CAN, LIN, DAIO.
XL_INVALID_PORTHANDLE  = -1

XL_ACTIVATE_NONE        = 0 
XL_ACTIVATE_RESET_CLOCK = 8

class TestBasic(unittest.TestCase):
    # def setUp(self):
    #     print("setUp")

    # def tearDown(self):
    #     print("tearDown")

    # def doCleanups(self):
    #     print("cleanup")

    def test_opendriver_close_driver(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])

        status = xl.OpenDriver()
        self.assertEqual(status, XL_SUCCESS)

        status = xl.CloseDriver()
        self.assertEqual(status, XL_SUCCESS)
    
    def test_setapplconfig_getapplconfig(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])

        status = xl.OpenDriver()
        self.assertEqual(status, XL_SUCCESS)

        # CAN1 -- virtual can bus1.hwch1
        status = xl.SetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=[XL_HWTYPE_VIRTUAL], pHwIndex=[0], pHwChannel=[0], busType=XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)

        pHwType = [0xff]
        pHwIndex = [0xff]
        pHwChannel = [0xff]
        status = xl.GetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=pHwType, pHwIndex=pHwIndex, pHwChannel=pHwChannel, busType=XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)
        self.assertEqual(pHwType[0], XL_HWTYPE_VIRTUAL)
        self.assertEqual(pHwIndex[0], 0)
        self.assertEqual(pHwChannel[0], 0)

        # CAN2 -- virtual can bus1.hwch2
        status = xl.SetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=1, pHwType=[XL_HWTYPE_VIRTUAL], pHwIndex=[0], pHwChannel=[1], busType=XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)

        pHwType = [0xff]
        pHwIndex = [0xff]
        pHwChannel = [0xff]
        status = xl.GetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=1, pHwType=pHwType, pHwIndex=pHwIndex, pHwChannel=pHwChannel, busType=XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)
        self.assertEqual(pHwType[0], XL_HWTYPE_VIRTUAL)
        self.assertEqual(pHwIndex[0], 0)
        self.assertEqual(pHwChannel[0], 1)

        status = xl.CloseDriver()
        self.assertEqual(status, XL_SUCCESS)

    def test_getdriverconfig(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])
        from pprint import pprint

        status = xl.OpenDriver()
        self.assertEqual(status, XL_SUCCESS)

        status = xl.SetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=[XL_HWTYPE_VIRTUAL], pHwIndex=[0], pHwChannel=[0], busType=XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)

        driverConfig = {}
        status = xl.GetDriverConfig(driverConfig)
        self.assertEqual(status, XL_SUCCESS)
        pprint(driverConfig)

        status = xl.CloseDriver()
        self.assertEqual(status, XL_SUCCESS)

    def test_getchannelmask(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])
        
        status = xl.OpenDriver()
        self.assertEqual(status, XL_SUCCESS)

        status = xl.SetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=[XL_HWTYPE_VIRTUAL], pHwIndex=[0], pHwChannel=[0], busType=XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)
            
        pHwType = [0]
        pHwIndex = [0]
        pHwChannel = [0]
        status = xl.GetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=pHwType, pHwIndex=pHwIndex, pHwChannel=pHwChannel, busType=XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)

        accessMask = xl.GetChannelMask(pHwType[0],pHwIndex[0],pHwChannel[0])
        self.assertNotEqual(accessMask,0)

        status = xl.CloseDriver()
        self.assertEqual(status, XL_SUCCESS)

    def test_openport_closeport(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])
        
        status = xl.OpenDriver()
        self.assertEqual(status, XL_SUCCESS)

        status = xl.SetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=[XL_HWTYPE_VIRTUAL], pHwIndex=[0], pHwChannel=[0], busType=XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)
            
        pHwType = [0]
        pHwIndex = [0]
        pHwChannel = [0]
        status = xl.GetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=pHwType, pHwIndex=pHwIndex, pHwChannel=pHwChannel, busType=XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)

        accessMask = xl.GetChannelMask(pHwType[0],pHwIndex[0],pHwChannel[0])
        self.assertNotEqual(accessMask,0)

        portHandle = [XL_INVALID_PORTHANDLE]
        permission_mask = [accessMask]
        rx_queue_size = 2^10
        status = xl.OpenPort(portHandle, bytes("pyxldrv".encode()), accessMask, permission_mask, rx_queue_size, XL_INTERFACE_VERSION, XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)
        self.assertEqual(accessMask, permission_mask[0])
        self.assertNotEqual(portHandle, XL_INVALID_PORTHANDLE)

        status = xl.ClosePort(portHandle[0])
        self.assertEqual(status, XL_SUCCESS)

        status = xl.CloseDriver()
        self.assertEqual(status, XL_SUCCESS)


    def test_activate_deactivate(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])
        status = xl.OpenDriver()
        self.assertEqual(status, XL_SUCCESS)

        status = xl.SetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=[XL_HWTYPE_VIRTUAL], pHwIndex=[0], pHwChannel=[0], busType=XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)
            
        pHwType = [0]
        pHwIndex = [0]
        pHwChannel = [0]
        status = xl.GetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=pHwType, pHwIndex=pHwIndex, pHwChannel=pHwChannel, busType=XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)

        accessMask = xl.GetChannelMask(pHwType[0],pHwIndex[0],pHwChannel[0])
        self.assertNotEqual(accessMask,0)

        portHandle = [XL_INVALID_PORTHANDLE]
        permission_mask = [accessMask]
        rx_queue_size = 2^10
        status = xl.OpenPort(portHandle, bytes("pyxldrv".encode()), accessMask, permission_mask, rx_queue_size, XL_INTERFACE_VERSION, XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)
        self.assertNotEqual(portHandle, XL_INVALID_PORTHANDLE)

        status = xl.ActivateChannel(portHandle[0], accessMask, XL_BUS_TYPE_CAN, XL_ACTIVATE_RESET_CLOCK)
        self.assertEqual(status, XL_SUCCESS)

        status = xl.DeactivateChannel(portHandle[0], accessMask)
        self.assertEqual(status, XL_SUCCESS)


        status = xl.ClosePort(portHandle[0])
        self.assertEqual(status, XL_SUCCESS)

        status = xl.CloseDriver()
        self.assertEqual(status, XL_SUCCESS)

    def test_openport_closeport(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])
        
        status = xl.OpenDriver()
        self.assertEqual(status, XL_SUCCESS)

        status = xl.SetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=[XL_HWTYPE_VIRTUAL], pHwIndex=[0], pHwChannel=[0], busType=XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)
            
        pHwType = [0]
        pHwIndex = [0]
        pHwChannel = [0]
        status = xl.GetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=pHwType, pHwIndex=pHwIndex, pHwChannel=pHwChannel, busType=XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)

        accessMask = xl.GetChannelMask(pHwType[0],pHwIndex[0],pHwChannel[0])
        self.assertNotEqual(accessMask,0)

        portHandle = [XL_INVALID_PORTHANDLE]
        permission_mask = [accessMask]
        rx_queue_size = 2^10
        status = xl.OpenPort(portHandle, bytes("pyxldrv".encode()), accessMask, permission_mask, rx_queue_size, XL_INTERFACE_VERSION, XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)
        self.assertNotEqual(portHandle, XL_INVALID_PORTHANDLE)

        status = xl.ClosePort(portHandle[0])
        self.assertEqual(status, XL_SUCCESS)

        status = xl.CloseDriver()
        self.assertEqual(status, XL_SUCCESS)

class TestCanTransmit(unittest.TestCase):
    # def setUp(self):
    #     print("setUp")

    # def tearDown(self):
    #     print("tearDown")

    # def doCleanups(self):
    #     print("cleanup")
    def test_cantransmit_receive(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])
        status = xl.OpenDriver()
        self.assertEqual(status, XL_SUCCESS)

        status = xl.SetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=[XL_HWTYPE_VIRTUAL], pHwIndex=[0], pHwChannel=[0], busType=XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)
            
        pHwType = [0]
        pHwIndex = [0]
        pHwChannel = [0]
        status = xl.GetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=pHwType, pHwIndex=pHwIndex, pHwChannel=pHwChannel, busType=XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)

        accessMask = xl.GetChannelMask(pHwType[0],pHwIndex[0],pHwChannel[0])
        self.assertNotEqual(accessMask,0)

        portHandle = [XL_INVALID_PORTHANDLE]
        permission_mask = [accessMask]
        rx_queue_size = 2^10
        status = xl.OpenPort(portHandle, bytes("pyxldrv".encode()), accessMask, permission_mask, rx_queue_size, XL_INTERFACE_VERSION, XL_BUS_TYPE_CAN)
        self.assertEqual(status, XL_SUCCESS)
        self.assertNotEqual(portHandle, XL_INVALID_PORTHANDLE)

        status = xl.ActivateChannel(portHandle[0], accessMask, XL_BUS_TYPE_CAN, XL_ACTIVATE_RESET_CLOCK)
        self.assertEqual(status, XL_SUCCESS)

        message_count = [1]
        status = xl.CanTransmit(portHandle[0], accessMask, message_count, {"a":1})
        self.assertEqual(status, XL_SUCCESS)

        eventcount=[1]
        eventstring=[""]
        status = xl.Receive(portHandle[0],eventcount,eventstring)
        self.assertEqual(status, XL_SUCCESS)
        self.assertEqual(eventcount[0], 1)

        eventcount=[1]
        eventstring=[""]
        status = xl.Receive(portHandle[0],eventcount,eventstring)
        self.assertEqual(status, XL_SUCCESS)
        self.assertEqual(eventcount[0], 0)

        status = xl.DeactivateChannel(portHandle[0], accessMask)
        self.assertEqual(status, XL_SUCCESS)


        status = xl.ClosePort(portHandle[0])
        self.assertEqual(status, XL_SUCCESS)

        status = xl.CloseDriver()
        self.assertEqual(status, XL_SUCCESS)


if __name__ == '__main__':
    unittest.main()
