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

class Test(unittest.TestCase):
    # def setUp(self):
    #     print("setUp")

    # def tearDown(self):
    #     print("tearDown")

    # def doCleanups(self):
    #     print("cleanup")

    def test_open(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])
        ret = xl.OpenDriver()
        self.assertEqual(ret, XL_SUCCESS)

    def test_close(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])
        ret = xl.CloseDriver()
        self.assertEqual(ret, XL_SUCCESS)
    
    def test_setapplconfig_getapplconfig(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])

        ret = xl.OpenDriver()
        self.assertEqual(ret, XL_SUCCESS)

        # CAN1 -- virtual can bus1.hwch1
        ret = xl.SetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=[XL_HWTYPE_VIRTUAL], pHwIndex=[0], pHwChannel=[0], busType=XL_BUS_TYPE_CAN)
        self.assertEqual(ret, XL_SUCCESS)

        pHwType = [0xff]
        pHwIndex = [0xff]
        pHwChannel = [0xff]
        ret = xl.GetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=pHwType, pHwIndex=pHwIndex, pHwChannel=pHwChannel, busType=XL_BUS_TYPE_CAN)
        self.assertEqual(ret, XL_SUCCESS)
        self.assertEqual(pHwType[0], XL_HWTYPE_VIRTUAL)
        self.assertEqual(pHwIndex[0], 0)
        self.assertEqual(pHwChannel[0], 0)

        # CAN2 -- virtual can bus1.hwch2
        ret = xl.SetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=1, pHwType=[XL_HWTYPE_VIRTUAL], pHwIndex=[0], pHwChannel=[1], busType=XL_BUS_TYPE_CAN)
        self.assertEqual(ret, XL_SUCCESS)

        pHwType = [0xff]
        pHwIndex = [0xff]
        pHwChannel = [0xff]
        ret = xl.GetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=1, pHwType=pHwType, pHwIndex=pHwIndex, pHwChannel=pHwChannel, busType=XL_BUS_TYPE_CAN)
        self.assertEqual(ret, XL_SUCCESS)
        self.assertEqual(pHwType[0], XL_HWTYPE_VIRTUAL)
        self.assertEqual(pHwIndex[0], 0)
        self.assertEqual(pHwChannel[0], 1)

        ret = xl.CloseDriver()
        self.assertEqual(ret, XL_SUCCESS)

    def test_getdriverconfig(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])
        from pprint import pprint

        ret = xl.OpenDriver()
        self.assertEqual(ret, XL_SUCCESS)

        ret = xl.SetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=[XL_HWTYPE_VIRTUAL], pHwIndex=[0], pHwChannel=[0], busType=XL_BUS_TYPE_CAN)
        self.assertEqual(ret, XL_SUCCESS)

        driverConfig = {}
        ret = xl.GetDriverConfig(driverConfig)
        self.assertEqual(ret, XL_SUCCESS)
        pprint(driverConfig)

        ret = xl.CloseDriver()
        self.assertEqual(ret, XL_SUCCESS)

    def test_getchannelmask(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])
        ret = xl.OpenDriver()
        self.assertEqual(ret, XL_SUCCESS)

        ret = xl.SetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=[XL_HWTYPE_VIRTUAL], pHwIndex=[0], pHwChannel=[0], busType=XL_BUS_TYPE_CAN)
        self.assertEqual(ret, XL_SUCCESS)
            
        pHwType = [0]
        pHwIndex = [0]
        pHwChannel = [0]
        ret = xl.GetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=pHwType, pHwIndex=pHwIndex, pHwChannel=pHwChannel, busType=XL_BUS_TYPE_CAN)
        self.assertEqual(ret, XL_SUCCESS)

        access_mask = xl.GetChannelMask(pHwType[0],pHwIndex[0],pHwChannel[0])
        self.assertNotEqual(access_mask,0)

        ret = xl.CloseDriver()
        self.assertEqual(ret, XL_SUCCESS)

    def test_openport_closeport(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])
        ret = xl.OpenDriver()
        self.assertEqual(ret, XL_SUCCESS)

        ret = xl.SetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=[XL_HWTYPE_VIRTUAL], pHwIndex=[0], pHwChannel=[0], busType=XL_BUS_TYPE_CAN)
        self.assertEqual(ret, XL_SUCCESS)
            
        pHwType = [0]
        pHwIndex = [0]
        pHwChannel = [0]
        ret = xl.GetApplConfig(appName=bytes("pyxldrv".encode()), appChannel=0, pHwType=pHwType, pHwIndex=pHwIndex, pHwChannel=pHwChannel, busType=XL_BUS_TYPE_CAN)
        self.assertEqual(ret, XL_SUCCESS)

        access_mask = xl.GetChannelMask(pHwType[0],pHwIndex[0],pHwChannel[0])
        self.assertNotEqual(access_mask,0)

        port_handle = [XL_INVALID_PORTHANDLE]
        permission_mask = [0]
        rx_queue_size = 2^10
        ret = xl.OpenPort(port_handle, bytes("pyxldrv".encode()), access_mask, permission_mask, rx_queue_size, XL_INTERFACE_VERSION, XL_BUS_TYPE_CAN)
        self.assertEqual(ret, XL_SUCCESS)
        self.assertNotEqual(port_handle, XL_INVALID_PORTHANDLE)

        ret = xl.ClosePort(port_handle[0])
        self.assertEqual(ret, XL_SUCCESS)

        ret = xl.CloseDriver()
        self.assertEqual(ret, XL_SUCCESS)

if __name__ == '__main__':
    unittest.main()
