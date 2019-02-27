import unittest
import filecmp
import subprocess
from huffman import *

class TestList(unittest.TestCase):
    def test_cnt_freq(self):
        freqlist = cnt_freq("file2.txt")
        anslist = [2, 4, 8, 16, 0, 2, 0] 
        self.assertListEqual(freqlist[97:104], anslist)
        h = HuffmanNode(0,0)
        h.set_left(h)
        h.set_right(h)
        self.assertEqual(h.left,h)
        self.assertEqual(h.right,h)
        self.assertEqual(combine(HuffmanNode(10,10),HuffmanNode(1,1)).freq,11)


    def test_create_huff_tree(self):
        freqlist = cnt_freq("file2.txt")
        hufftree = create_huff_tree(freqlist)
        self.assertEqual(hufftree.freq, 32)
        self.assertEqual(hufftree.char, 97)
        left = hufftree.left
        self.assertEqual(left.freq, 16)
        self.assertEqual(left.char, 97)
        right = hufftree.right
        self.assertEqual(right.freq, 16)
        self.assertEqual(right.char, 100)

    def test_create_header(self):
        freqlist = cnt_freq("file2.txt")
        self.assertEqual(create_header(freqlist), "97 2 98 4 99 8 100 16 102 2")

    def test_create_code(self):
        freqlist = cnt_freq("file2.txt")
        hufftree = create_huff_tree(freqlist)
        codes = create_code(hufftree)
        self.assertEqual(codes[ord('d')], '1')
        self.assertEqual(codes[ord('a')], '0000')
        self.assertEqual(codes[ord('f')], '0001')

    def test_01_textfile(self):
        huffman_encode("file1.txt", "file1_out.txt")
        # capture errors by running 'diff' on your encoded file with a *known* solution file
        err = subprocess.call("diff -wb file1_out.txt file1_soln.txt", shell = True)
        self.assertEqual(err, 0)
        huffman_encode('multiline.txt','mout.txt')
        err = subprocess.call("diff -wb mout.txt multiline_soln.txt", shell = True)
        self.assertEqual(err,0)
    def test_decode(self):
        huffman_decode("file1_out.txt", 'file1_decoded.txt')
        err = subprocess.call(" diff -wb file1_decoded.txt file1.txt",shell = True)
        self.assertEqual(err,0)
        huffman_decode("singlechar_out.txt", 'single_decoded.txt')
        err = subprocess.call(" diff -wb single_decoded.txt singlechar.txt",shell = True)
        self.assertEqual(err,0)


if __name__ == '__main__': 
   unittest.main()
