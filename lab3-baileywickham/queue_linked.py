
class Node:
    def __init__(self,item):
        self.item = item
        self.next = None


class Queue:
    '''Implements an link-based ,efficient first-in first-out Abstract Data Type'''

    def __init__(self, capacity):
        '''Creates an empty Queue with a capacity'''
        self.capacity = capacity
        self.num_items = 0
        self.head = None 
        self.tail = None


    def is_empty(self):
        '''Returns True if the Queue is empty, and False otherwise'''
        if self.num_items == 0:
            return True
        return False


    def is_full(self):
        '''Returns True if the Queue is full, and False otherwise'''
        if self.num_items == self.capacity:
            return True
        return False


    def enqueue(self, item):
        '''If Queue is not full, enqueues (adds) item to Queue 
           If Queue is full when enqueue is attempted, raises IndexError'''
        if self.is_full():
            raise IndexError
        newNode = Node(item)
        if self.is_empty():
            self.head = newNode
            self.tail = newNode
        self.tail.next = newNode
        self.tail = newNode
        self.num_items += 1


    def dequeue(self):
        '''If Queue is not empty, dequeues (removes) item from Queue and returns item.
           If Queue is empty when dequeue is attempted, raises IndexError'''
        if self.is_empty():
            raise IndexError
        ret = self.head.item
        self.head = self.head.next
        self.num_items -= 1

        return ret

    def size(self):
        '''Returns the number of elements currently in the Queue, not the capacity'''
        return self.num_items

