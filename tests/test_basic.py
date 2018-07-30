# *-* encoding: utf-8 *-*
# python -m unittest tests.test_basic
import unittest
import inspect
import vxlapi as xl

XL_SUCCESS = 0

class Test(unittest.TestCase):
    def setUp(self):
        print("setUp")

    def tearDown(self):
        print("tearDown")

    def doCleanups(self):
        print("cleanup")

    def test_open(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])
        ret = xl.OpenDriver()
        self.assertEqual(ret, XL_SUCCESS)

    def test_close(self):
        print(inspect.getframeinfo(inspect.currentframe())[2])
        ret = xl.CloseDriver()
        self.assertEqual(ret, XL_SUCCESS)

if __name__ == '__main__':
    unittest.main()
