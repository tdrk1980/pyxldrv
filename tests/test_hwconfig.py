# *-* encoding: utf-8 *-*

import unittest
import inspect
import vxlapi as xl

# python -m unittest tests.test_hwconfig
class Test(unittest.TestCase):
    def test_popup(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])

        ret = xl.PopupHwConfig()
        self.assertEqual(ret, xl.XL_SUCCESS)

if __name__ == '__main__':
    unittest.main()
