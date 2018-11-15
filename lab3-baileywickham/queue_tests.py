import unittest
from queue_array import Queue
#from queue_linked import Queue

class TestLab1(unittest.TestCase):
    def test_queue(self):
        '''Trivial test to ensure method names and parameters are correct'''
        q = Queue(5)
        self.assertTrue(q.is_empty())
        self.assertFalse(q.is_full())
        q.enqueue('thing')
        self.assertEqual(q.dequeue(),'thing') 
        self.assertEqual(q.size(),0)
        for i in range(5): q.enqueue(i)
        self.assertTrue(q.is_full())
        self.assertFalse(q.is_empty())
        with self.assertRaises(IndexError):
            q.enqueue(1)
        self.assertEqual(q.size(),5)
        with self.assertRaises(IndexError):
            e = Queue(1)
            e.dequeue()

    def test_two(self):
        r = Queue(5)
        r.enqueue(1)
        r.enqueue(2)
        r.enqueue(3)
        self.assertEqual(r.num_items,3)
        self.assertEqual(r.dequeue(),1)
        self.assertEqual(r.dequeue(),2)
        self.assertEqual(r.num_items,1)
        with self.assertRaises(IndexError):
            while True:
                r.enqueue(1)

        self.assertEqual(r.num_items, r.capacity)
if __name__ == '__main__': 
    unittest.main()
