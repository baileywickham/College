import unittest
from graph import *

class TestList(unittest.TestCase):

    def test_01(self):
        g = Graph('test1.txt')
        self.assertEqual(g.conn_components(), [['v1', 'v2', 'v3', 'v4', 'v5'], ['v6', 'v7', 'v8', 'v9']])
        self.assertTrue(g.is_bipartite())
        
    def test_02(self):
        g = Graph('test2.txt')
        self.assertEqual(g.conn_components(), [['v1', 'v2', 'v3'], ['v4', 'v6', 'v7', 'v8']])
        self.assertFalse(g.is_bipartite())
    
    def test_self(self):
        g = Graph('test3.txt')
        self.assertEqual(g.get_vertex('v1'), g.verts['v1']) #yikes
        self.assertEqual(g.get_vertex('hello'),None)
        self.assertEqual(g.conn_components(), [['v1','v2','v3','v4']])
        self.assertEqual(g.get_vertices(),['v1','v2','v3','v4'])
        self.assertTrue(g.is_bipartite())

    def test_other(self):
        g = Graph('test4.txt')
        self.assertEqual(g.conn_components(), [['v1','v11','v2'],['v3','v4'],['v5','v6']])
        self.assertTrue(g.is_bipartite())

if __name__ == '__main__':
   unittest.main()
