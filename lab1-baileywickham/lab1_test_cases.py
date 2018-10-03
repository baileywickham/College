import unittest
from lab1 import *

 # A few test cases.  Add more!!!
class TestLab1(unittest.TestCase):

    def test_max_list_iter(self):
        """Tests max list through iteration"""
        self.assertEqual(max_list_iter([1]), 1) #test a single
        self.assertEqual(max_list_iter([1,2,3]), 3) #test normal use case
        self.assertEqual(max_list_iter([-1,-2,-3]),-1) #test negitives
        self.assertEqual(max_list_iter([1,1,1]), 1) # test all same
        self.assertEqual(max_list_iter([2,1,3]),3) # test unordered
        self.assertEqual(max_list_iter([]), None) # empty
        self.assertEqual(max_list_iter([1,3,34,2,1,23,1,23,34]),34) #test 2 digit, copies
        with self.assertRaises(ValueError): #None
            max_list_iter(None)


    def test_reverse_rec(self):
        """tests reverse_rec, a methon for reculsivly reversing a list"""
        self.assertEqual(reverse_rec([1,2,3]),[3,2,1]) #normal
        self.assertEqual(reverse_rec([1,23,1]), [1,23,1]) # 2 digit, center
        self.assertEqual(reverse_rec([3]), [3]) # single
        self.assertEqual(reverse_rec([]), []) #empty
        self.assertEqual(reverse_rec([4,2333,23,1]), [1,23,2333,4]) #3 digit

        with self.assertRaises(ValueError): #None
            reverse_rec(None)

    def test_bin_search(self):
        """ A test of binary searches;"""
        list_val =[0,1,2,3,4,7,8,9,10]
        low = 0
        high = len(list_val)-1
        self.assertEqual(bin_search(4, 0, len(list_val)-1, list_val), 4 ) #normal use

        self.assertEqual(bin_search(1, 0, 1, [0,1]),1) #short
        self.assertEqual(bin_search(1,4,8,list_val),None) #not in list
        self.assertEqual(bin_search(4,3,8,list_val),4) #concat list

if __name__ == "__main__":
        unittest.main()

    
