import unittest
from huffman import *
import subprocess
class TestList(unittest.TestCase):
    def test_things(self):
        huffman_encode('empty.txt','empty.out')
        err = subprocess.call('diff -wb empty.txt empty.out',shell = True)
        self.assertEqual(err,0)
        huffman_encode('declaration.txt','dec.txt')
        err = subprocess.call('diff -wb declaration_soln.txt dec.txt',shell = True)
        self.assertEqual(err,0)
        huffman_encode('char.txt','charout.txt')
        err = subprocess.call('diff -wb char_s.txt charout.txt',shell = True)
        self.assertEqual(err,0)
        huffman_decode('empty.txt','empty.out')
        err = subprocess.call('diff -wb empty.txt empty.out',shell = True)
        self.assertEqual(err,0)
        

if __name__ == '__main__':
    unittest.main()
