import unittest

# Use the imports below to test either your array-based stack
# or your link-based version
from stack_array import Stack
#from stack_linked import Stack

class TestLab2(unittest.TestCase):
    def test_simple(self):
        stack = Stack(5)
        self.assertTrue(stack.is_empty())
        stack.push(0)
        self.assertFalse(stack.is_empty())
        self.assertFalse(stack.is_full())
        self.assertEqual(stack.size(),1)
        stack.push(1)
        self.assertEqual(stack.size(),2)
        self.assertEqual(stack.capacity,5)
        self.assertEqual(stack.peek(),1)
        self.assertEqual(stack.pop(),1)
        self.assertEqual(stack.size(),1)
        for i in range(4): stack.push(1);
        with self.assertRaises(IndexError):
            stack.push(1)
        with self.assertRaises(IndexError):
            s = Stack(1)
            s.pop()
        with self.assertRaises(IndexError):
            e = Stack(1)
            e.peek()
        self.assertTrue(stack.is_full())

if __name__ == '__main__': 
    unittest.main()
