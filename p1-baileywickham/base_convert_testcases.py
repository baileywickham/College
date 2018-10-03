import unittest
from  base_convert import *

class TestBaseConvert(unittest.TestCase):

    def test_base2(self):
        self.assertEqual(convert(45,2),"101101")

    def test_base4(self):
        self.assertEqual(convert(30,4),"132")

    def test_base16(self):
        self.assertEqual(convert(316,16),"13C")
    def test_others(self):
        self.assertEqual(convert(16,16),'10')
        self.assertEqual(convert(10,10),'10')
        self.assertEqual(convert(1,16),'1')
        self.assertEqual(convert(15,16),'F')
        self.assertEqual(convert(15,16),'F')
        self.assertEqual(convert(15,16),'F')
        
        with self.assertRaises(ValueError):
            convert(0,0)
         

if __name__ == "__main__":
    unittest.main()
