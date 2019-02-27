import unittest
from binary_search_tree import *

class TestLab4(unittest.TestCase):

    def test_simple(self):
        bst = BinarySearchTree()
        self.assertTrue(bst.is_empty())
        bst.insert(10, 'stuff')
        self.assertTrue(bst.search(10))
        self.assertEqual(bst.find_min(), (10, 'stuff'))
        bst.insert(10, 'other')
        self.assertEqual(bst.find_max(), (10, 'other'))
        self.assertEqual(bst.tree_height(), 0)
        self.assertEqual(bst.inorder_list(), [10])
        self.assertEqual(bst.preorder_list(), [10])
        self.assertEqual(bst.level_order_list(), [10])
    
    def test_complex(self):
        b = BinarySearchTree()
        b.insert(3,'hello')
        b.insert(2,'hi')
        b.insert(1,'123')
        b.insert(4,'aoeu')
        self.assertEqual(b.inorder_list(),[1,2,3,4])
        b.insert(7,'seven')
        b.insert(6,'six')
        b.insert(20,'twenty')
        self.assertEqual(b.find_min(),(1,'123'))
        self.assertEqual(b.find_max(),(20,'twenty'))

    def test_failures(self):
        b = BinarySearchTree()
        self.assertIsNone(b.search(999))
        self.assertIsNone(b.find_max())
        self.assertIsNone(b.find_min())
        self.assertEqual(b.tree_height(),None)
        b.insert(5)
        b.insert(3)
        b.insert(4)
        b.insert(2)
        b.insert(7)
        b.insert(6)
        b.insert(8)
        self.assertEqual(b.level_order_list(),[5,3,7,2,4,6,8])
        self.assertEqual(b.tree_height(),2)
        self.assertTrue(b.search(6))
    def test_cover(self):
        b = BinarySearchTree()
        b.insert(10)
        b.insert(9)
        self.assertEqual(b.tree_height(),1)
        b = BinarySearchTree()
        b.insert(10)
        b.insert(11)
        self.assertEqual(b.tree_height(),1)
        self.assertFalse(b.search(20))

if __name__ == '__main__': 
    unittest.main()
