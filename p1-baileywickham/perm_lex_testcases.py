import unittest
from perm_lex import *
from itertools import permutations

class TestAssign1(unittest.TestCase):

    def test_perm_gen_lex(self):
        self.assertEqual(perm_gen_lex('ab'),['ab','ba'])
        self.assertEqual(perm_gen_lex('abc'),['abc','acb','bac','bca','cab','cba'])
        
        self.assertEqual(perm_gen_lex('a'),['a'])
        self.assertEqual(perm_gen_lex(''),[])
        with self.assertRaises(ValueError):
            perm_gen_lex(None)

if __name__ == "__main__":
        unittest.main()
