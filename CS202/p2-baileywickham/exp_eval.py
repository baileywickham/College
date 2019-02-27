from stack_array import Stack

# You do not need to change this class
class PostfixFormatException(Exception):
    pass

def postfix_eval(input_str):
    """Input argument:  a string containing a postfix expression where tokens 
    are space separated.  Tokens are either operators + - * / ^ or numbers
    Returns the result of the expression evaluation. 
    Raises an PostfixFormatException if the input is not well-formed"""
    sep = input_str.split(" ")
    stack = Stack(len(sep)+1) # bad practice but safe
    for char in sep:
        if num(char):
            stack.push(intorfloat(char))
        elif opp(char):
            if stack.size() < 2:
                raise PostfixFormatException('Insufficient operands')
            above = stack.pop()
            below = stack.pop()
            stack.push(do(above,below,char))
        else:
            raise PostfixFormatException("Invalid token")
    if stack.size() > 1:
        raise PostfixFormatException("Too many operands")
    final = stack.pop()
    final = int(final) if final % 1 == 0 else final
    return final

def infix_to_postfix(input_str):
    """Input argument:  a string containing an infix expression where tokens are 
    space separated.  Tokens are either operators + - * / ^ parentheses ( ) or numbers
    Returns a String containing a postfix expression """
    input_str = input_str.split(" ")
    output_str = ''
    inStack = Stack(len(input_str) + 1)
    for char in input_str:
        if num(char):
            output_str = output_str + char + ' '
        if char is '(':
            inStack.push(char)
        if char is ')':
            while True:
                r = inStack.pop()
                if opp(r):
                    output_str = output_str + r + ' '
                if r is '(':
                    break
                #raise PostfixFormatException
            
        if opp(char):
            while True:
                try:
                    if not opp(inStack.peek()):
                        raise IndexError
                    op = inStack.peek()
                    if char != '**' and precidence(char,op):
                        output_str = output_str + op + ' '
                        inStack.pop()
                    elif char == '**' and precidence(char,op,True):
                        output_str = output_str + op + ' '
                        inStack.pop()
                    else:
                        break
                except:
                    break
            inStack.push(char)

    for i in range(inStack.size()):
        finals = inStack.pop()
        output_str = output_str + finals  + ' '
    return output_str.strip() 

def prefix_to_postfix(input_str):
    """Converts a prefix expression to an equivalent postfix expression"""
    """Input argument: a string containing a prefix expression where tokens are 
    space separated.  Tokens are either operators + - * / ^ parentheses ( ) or numbers
    Returns a String containing a postfix expression(tokens are space separated)"""
    rstr = input_str[::-1].split(' ')
    s = Stack(len(rstr) + 1) # I hope no one sees this
    retstr = ''
    for char in rstr:
        if num(char):
            s.push(char)
        elif opp(char):
            op1 = s.pop()
            op2 = s.pop()
            s.push(f'{retstr} {op1} {op2} {char}')
    return ' '.join(s.pop().split())

def num(n):
    try:
        float(n)
        return True
    except:
        return False

def opp(n):
    oppSet = ('+','-','/','*','<<','>>','**')
    if n in oppSet:
        return n
    return False

def do(above,below,char):
    if char == '+':
        return below + above 
    if char == '-':
        return below - above
    if char == '*':
        return below * above
    if char == '/':
        return below / above
    if char == '<<':
        if type(below) is not int or type(above) is not int:
            raise PostfixFormatException("Illegal bit shift operand")
        return below << above
    if char == '>>':
        if type(below) is not int or type(above) is not int:
            raise PostfixFormatException("Illegal bit shift operand")
        return below >> above
    if char == '**':
        return below**above

def precidence(op1,op2,second=False):
    d = {'<<':5,'>>':5,'**':4,'*':3,'/':3,'+':1,'-':1}
    if not second:
        if d[op1] <= d[op2]:
            return True
        return False
    if second:
        if d[op1] < d[op2]:
            return True
        return False


def intorfloat(num):
    if float(num).is_integer():
        return int(float(num))
    return float(num)

