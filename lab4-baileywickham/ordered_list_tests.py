import unittest
from ordered_list import *

class TestLab4(unittest.TestCase):

    def test_simple(self):
        t_list = OrderedList()
        t_list.add(10)
        self.assertEqual(t_list.python_list(), [10])
        self.assertEqual(t_list.size(), 1)
        self.assertEqual(t_list.index(10), 0)
        self.assertTrue(t_list.search(10))
        self.assertFalse(t_list.is_empty())
        self.assertEqual(t_list.python_list_reversed(), [10])
        self.assertTrue(t_list.remove(10))
        self.assertTrue(t_list.is_empty())
        t_list.add(10)
        self.assertEqual(t_list.pop(0), 10)
        
        t = OrderedList()
        for i in range(10):
            t.add(i)
        self.assertEqual(t.size(),10)
    
    def test_add(self):
        t = OrderedList()
        t.add(10)
        t.add(5)
        self.assertEqual(t.python_list(),[5,10])
        self.assertEqual(t.size(),2)
        assert t.remove(10)
        t.add(1);t.add(5);t.add(15)
        self.assertEqual(t.python_list(),[1,5,5,15])
        t.add(7)
        self.assertEqual(t.python_list(),[1,5,5,7,15])
        assert t.remove(5)
        self.assertEqual(t.python_list(),[1,5,7,15])
        self.assertFalse(t.remove(19))
        self.assertIsNone(t.index(19))
        self.assertEqual(t.index(7),2)
        self.assertEqual(t.pop(2),7)
        self.assertFalse(t.search(16))
        self.assertEqual(t.python_list_reversed(),[15,7,5,1])

        e = OrderedList()
        self.assertEqual(e.python_list(),[])
        self.assertEqual(e.python_list_reversed(),[])
        with self.assertRaises(IndexError):
            e.remove(1)
        with self.assertRaises(IndexError):
            e.index(1)
        with self.assertRaises(IndexError):
            e.search(1)
        with self.assertRaises(IndexError):
            e.size()
        with self.assertRaises(IndexError):
            e.pop(1)
        e.add(1)
        with self.assertRaises(IndexError):
            e.pop(-1)
        with self.assertRaises(IndexError):
            e.pop(10)

if __name__ == '__main__': 
    unittest.main()
