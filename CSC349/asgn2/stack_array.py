class Stack:
    '''Implements an efficient last-in first-out Abstract Data Type using a Python List'''

    def __init__(self, capacity):
        '''Creates and empty stack with a capacity'''
        self.capacity = capacity
        self.items = [None]*capacity
        self.num_items = 0

    def is_empty(self):
        '''Returns True if the stack is empty, and False otherwise
        MUST have O(1) performance'''
        if self.num_items == 0:
            return True
        return False

    def is_full(self):
        '''Returns True if the stack is full, and False otherwise
        MUST have O(1) performance'''
        if self.capacity == self.num_items:
            return True
        return False

    def push(self, item):
        '''If stack is not full, pushes item on stack. 
        If stack is full when push is attempted, raises IndexError
        MUST have O(1) performance'''
        if self.is_full():
            raise IndexError
        self.items[self.num_items] = item
        self.num_items += 1

    def pop(self):
        '''If stack is not empty, pops item from stack and returns item.
        If stack is empty when pop is attempted, raises IndexError
        MUST have O(1) performance'''
        if self.is_empty():
            raise IndexError
        ret = self.items[self.num_items-1]
        self.items[self.num_items-1] = None
        self.num_items -= 1
        return ret

    def peek(self):
        if self.is_empty():
            raise IndexError
        return self.items[self.num_items - 1]

    def size(self):
        return self.num_items
