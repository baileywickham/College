import unittest
from location import *

class TestLab1(unittest.TestCase):

    def test_repr(self):
        """tests the repr methon"""
        loc = Location("SLO", 36.3, -120.7)
        self.assertEqual(repr(loc),"Location('SLO', 36.3, -120.7)")

    # Add more tests!
    def test_eq(self):
        """tests the internal eq"""
        new = Location("SLO", 37.3, -120.7)
        self.assertNotEqual(new, Location("SO", 37.3, -120.7))
        self.assertEqual(new, Location("SLO", 37.3, -120.7))
if __name__ == "__main__":
        unittest.main()
