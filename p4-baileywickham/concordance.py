#!/bin/python3
from hash_quad import *
import string

class Concordance:

    def __init__(self):
        self.stop_table = None          # hash table for stop words
        self.concordance_table = None   # hash table for concordance
        self.ttable = str.maketrans('-', ' ', '!"#$%&\'()*+,./:;<=>?@[\\]^_`{|}~0123456789')

    def load_stop_table(self, filename):
        """ Read stop words from input file (filename) and insert each word as a key into the stop words hash table.
        Starting size of hash table should be 191: self.stop_table = HashTable(191)
        If file does not exist, raise FileNotFoundError"""
        self.stop_table = HashTable(191)
        with open(filename, 'r') as f:
            for word in f.readlines():
                self.stop_table.insert(word.replace('\n',''),None)


    def load_concordance_table(self, filename):
        """ Read words from input text file (filename) and insert them into the concordance hash table, 
        after processing for punctuation, numbers and filtering out words that are in the stop words hash table.
        Do not include duplicate line numbers (word appearing on same line more than once, just one entry for that line)
        Starting size of hash table should be 191: self.concordance_table = HashTable(191)
        If file does not exist, raise FileNotFoundError"""
        self.concordance_table = HashTable(191)
        with open(filename, 'r') as f:
            for linenum,words in enumerate(f.readlines()):
                for i in words.translate(self.ttable).split():
                    i = i.casefold()
                    if not self.stop_table.in_table(i):
                        self.concordance_table.insert(i,linenum + 1)

    def write_concordance(self, filename):
        """ Write the concordance entries to the output file(filename)
        See sample output files for format."""
        out = ''
        values = [x for x in self.concordance_table.hash_table if x is not None]
        values.sort(key=lambda x: x[0])
        for v in values:
            out += f'{v[0]}: {" ".join(str(x) for x in sorted(set(v[1])))}\n' 
        with open(filename, 'w') as f:
            f.write(out.rstrip())

'''
conc = Concordance()
conc.load_stop_table("stop_words.txt")
conc.load_concordance_table("file_WAP.txt")
conc.write_concordance("wap.txt")
'''
