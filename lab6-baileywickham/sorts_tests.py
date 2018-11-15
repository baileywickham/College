import unittest
from sorts import *

class TestLab4(unittest.TestCase):

    def test_simple(self):
        """Simple test for selection sort"""
        nums = [23, 10]
        comps = selection_sort(nums)
        self.assertEqual(comps, 1)
        self.assertEqual(nums, [10, 23])

    def test_selection_sort(self):
        """Test comparisons and sorting for selection sort"""
        nums = [8,7,6,5,4,3,2,1]
        comparisons = selection_sort(nums)
        self.assertEqual(comparisons, 28)
        self.assertEqual(nums, [1,2,3,4,5,6,7,8])
        random.seed(1234) 
        # Generate 5000 random numbers from 0 to 999,999
        randoms = random.sample(range(1000000), 1000)
        randoms_answer = randoms.copy()
        randoms_answer.sort()
        comparisons = selection_sort(randoms)
        self.assertEqual(comparisons, (len(randoms) * (len(randoms) - 1)) / 2)
        self.assertEqual(randoms_answer, randoms)

    def test_insertion_sort(self):
        """Test comparisons and sorting for insertion sort"""
        nums = [8,7,6,5,4,3,2,1]
        comparisons = insertion_sort(nums)
        self.assertEqual(comparisons, 28)
        self.assertEqual(nums, [1,2,3,4,5,6,7,8])

        nums = [0, 15, 5, 1, 0, 20, 25, 30, 35, 40]
        comparisons = insertion_sort(nums)
        self.assertEqual(comparisons, 15)
        self.assertListEqual(nums, [0, 0, 1, 5, 15, 20, 25, 30, 35, 40])
        random.seed(1234) 
        # Generate 5000 random numbers from 0 to 999,999
        randoms = random.sample(range(1000000), 500)
        randoms_answer = randoms.copy()
        randoms_answer.sort()
        comparisons = insertion_sort(randoms)
        # self.assertEqual(comparisons, (len(randoms) * (len(randoms) - 1)) / 2)
        self.assertEqual(randoms_answer, randoms)

        n = 1000
        nums = random.sample(range(10000000), n)
        randoms_answer = nums.copy()
        randoms_answer.sort()
        comparisons = insertion_sort(nums)
        self.assertListEqual(randoms_answer, nums)

    def test_insertion_sort_empty_list(self):
        nums = []
        comparisons = insertion_sort(nums)
        self.assertListEqual(nums, [])
        self.assertEqual(comparisons, 0)

    def test_selection_sort_empty_list(self):
        nums = []
        comparisons = selection_sort(nums)
        self.assertListEqual(nums, [])
        self.assertEqual(comparisons, 0)


if __name__ == '__main__': 
    unittest.main()
