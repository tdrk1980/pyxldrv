# *-* encoding: utf-8 *-*
# python -m unittest tests.test_hwconfig
import unittest
import inspect
import vxlapi as xl

XL_SUCCESS = 0

class Test(unittest.TestCase):
    def test_popup(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])

        ret = -1

        ret = xl.OpenDriver()
        self.assertEqual(ret, XL_SUCCESS)

        ret = xl.PopupHwConfig()
        self.assertEqual(ret, XL_SUCCESS)

        ret = xl.CloseDriver()
        self.assertEqual(ret, XL_SUCCESS)

if __name__ == '__main__':
    unittest.main()
