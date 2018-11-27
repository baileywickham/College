# Start of unittest - add to completely test functions in exp_eval

import unittest
from exp_eval import *

class test_expressions(unittest.TestCase):
    def test_postfix_eval_01(self):
        self.assertAlmostEqual(postfix_eval("3 5 +"), 8)
        self.assertEqual(postfix_eval('5 3 + 2 /'),4)
        self.assertEqual(postfix_eval('3 4 * 2 5 + * 5 4 + *'),756)
        self.assertEqual(postfix_eval('2 2 << 8 *'), 64)
        self.assertEqual(postfix_eval('3 4 * 2 5 + / 3 4 + *'), 12)
        self.assertAlmostEqual(postfix_eval(infix_to_postfix('( 57.5 - .1 ) * ( 6 / 3.2 ) + 4.3')), 111.925)
        self.assertAlmostEqual(0.714285714, postfix_eval("5 7 /"))


    def rest_postfix_eval_02(self):
        try:
            postfix_eval("blah")
            self.fail()
        except PostfixFormatException as e:
            self.assertEqual(str(e), "Invalid token")

    def test_postfix_eval_03(self):
        try:
            postfix_eval("4 +")
            self.fail()
        except PostfixFormatException as e:
            self.assertEqual(str(e), "Insufficient operands")

    def test_postfix_eval_04(self):
        try:
            postfix_eval("1 2 3 +")
            self.fail()
        except PostfixFormatException as e:
            self.assertEqual(str(e), "Too many operands")
    def test_postfix_eval_05(self):        
        try:
            postfix_eval('4 3 2 3 4 - -')
            self.fail()
        except PostfixFormatException as e:
            self.assertEqual(str(e), "Too many operands")
    def test_postfix_eval_10(self):        
        self.assertEqual(infix_to_postfix('3 + 4 * 2 / ( 1 - 5 ) ** 2 ** 3'),'3 4 2 * 1 5 - 2 3 ** ** / +')

    def test_infix_to_postfix_02(self):        
        self.assertEqual(postfix_eval('5 1 2 + 4 ** + 3 -'), 83) 
    def test_postfix_eval_12(self):
        self.assertEqual(postfix_eval('6 3 + 2 *'), 18)
        self.assertEqual(postfix_eval('2 4 <<'),32)
    def test_aoeu(self):
        self.assertEqual(postfix_eval('3 3 *'),9)
        self.assertEqual(postfix_eval('3 3 /'),1)
    def test_bit(self):
        try:
            postfix_eval('2.22 2 >>')
            self.fail()
        except PostfixFormatException as e:
            self.assertEqual(str(e), "Illegal bit shift operand")
    def test_other_bit(self):
        try:
            postfix_eval('2.22 2 <<')
            self.fail()
        except PostfixFormatException as e:
            self.assertEqual(str(e), "Illegal bit shift operand")
    def test_bt(self):
        self.assertEqual(infix_to_postfix('1 << 1 ** 3'), '1 1 << 3 **')
        self.assertEqual(postfix_eval('1 1 << 3 **'),8)
        self.assertEqual(infix_to_postfix('2 >> 2 ** 6'),'2 2 >> 6 **')
        self.assertEqual(postfix_eval('1 1 >> 3 **'),0)
    def test_bad_token(self):
        try:
            postfix_eval(',')
            self.fail()
        except PostfixFormatException as e:
            self.assertEqual(str(e), 'Invalid token')

    def test_infix_to_postfix_01(self):
        self.assertEqual(infix_to_postfix("6 - 3"), "6 3 -")
        self.assertEqual(infix_to_postfix("6"), "6")
        self.assertEqual(infix_to_postfix('3 ** 2 / ( 5 * 2 ) + 10'),'3 2 ** 5 2 * / 10 +') 
        self.assertEqual(infix_to_postfix('3 * 23 ** 2 / ( 1 * 2 ) + 12 / 4'), '3 23 2 ** * 1 2 * / 12 4 / +') 
        self.assertEqual(infix_to_postfix('4 + 2 / 12 ( 23 ** 2 * ( 2 / 12 ) )'),'4 2 12 23 2 ** 2 12 / * / +') 
        self.assertEqual(infix_to_postfix("8 * 2 "), "8 2 *")
        self.assertEqual(infix_to_postfix("3 ** 12 ( 4 + 3 * 34 ) * ( 12 / 2 ( 2 / 34 ) ** 3 * 34 )"),'3 12 4 3 34 * + ** 12 2 2 34 / 3 ** / 34 * *')

    def test_prefix_to_postfix(self):
        self.assertEqual(prefix_to_postfix("* - 3 / 2 1 - / 4 5 6"), "3 2 1 / - 4 5 / 6 - *")

if __name__ == "__main__":
    unittest.main()
