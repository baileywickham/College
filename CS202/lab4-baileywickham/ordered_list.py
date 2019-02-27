class Node:
    '''Node for use with doubly-linked list'''
    def __init__(self, item):
        self.item = item
        self.next = None
        self.prev = None

class OrderedList:
    '''A doubly-linked ordered list of items, from lowest (head of list) to highest (tail of list)'''

    def __init__(self):
        '''Use ONE dummy node as described in class
           ***No other attributes***
           Do not have an attribute to keep track of size'''
        self.head = Node(None)

    def is_empty(self):
        '''Returns back True if OrderedList is empty
            MUST have O(1) performance'''
        if self.head.next == None or self.head.next == self.head:
            return True
        return False

    def add(self, item):
        '''Adds an item to OrderedList, in the proper location based on ordering of items
           from lowest (at head of list) to highest (at tail of list)
           If the item is already in the list, do not add it again 
           MUST have O(n) average-case performance'''
        newNode = Node(item)
        if self.is_empty():
            self.head.next = newNode
            newNode.prev = self.head
            newNode.next = self.head
            self.head.prev = newNode
            return
        currentNode = self.head.next
        if item < currentNode.item and currentNode.prev == self.head:
            self.head.next = newNode
            currentNode.prev = newNode
            newNode.next = currentNode
            newNode.prev = self.head
            return
        while currentNode != self.head:
            if item >= currentNode.item and currentNode.next == self.head:
                self.head.prev = newNode
                currentNode.next = newNode
                newNode.next = self.head
                newNode.prev = currentNode
                break

            if item >= currentNode.item and item < currentNode.next.item:
                newNode.next = currentNode.next
                currentNode.next.prev = newNode
                currentNode.next = newNode
                newNode.prev = currentNode
                break
            currentNode = currentNode.next 

    def remove(self, item):
        '''Removes an item from OrderedList. If item is removed (was in the list) returns True
           If item was not removed (was not in the list) returns False
           MUST have O(n) average-case performance'''
        if self.is_empty():
            raise IndexError
        currentNode = self.head
        while currentNode.next != self.head:
            currentNode = currentNode.next
            if item == currentNode.item:
                currentNode.next.prev = currentNode.prev 
                currentNode.prev.next = currentNode.next
                return True
        return False


    def index(self, item):
        '''Returns index of an item in OrderedList (assuming head of list is index 0).
           If item is not in list, return None
           MUST have O(n) average-case performance'''
        if self.is_empty():
            raise IndexError
        counter = 0
        currentNode = self.head.next
        while True:
            if currentNode.item == item:
                return counter
            if currentNode.next == self.head:
                return None 
            currentNode = currentNode.next
            counter += 1

    def pop(self, index):
        '''Removes and returns item at index (assuming head of list is index 0).
           If index is negative or >= size of list, raises IndexError
           MUST have O(n) average-case performance'''
        if self.is_empty():
            raise IndexError
        if index < 0:
            raise IndexError
        counter = 0
        currentNode = self.head.next

        for i in range(index):
            if currentNode.next == self.head:
                raise IndexError
            counter += 1
            currentNode = currentNode.next
        return currentNode.item

    def search(self, item):
        '''Searches OrderedList for item, returns True if item is in list, False otherwise"
           To practice recursion, this method must call a RECURSIVE method that
           will search the list
           MUST have O(n) average-case performance'''
        if self.is_empty():
            raise IndexError
        return self.seachHelper(item,self.head) 


    def python_list(self):
        '''Return a Python list representation of OrderedList, from head to tail
           For example, list with integers 1, 2, and 3 would return [1, 2, 3]
           MUST have O(n) performance'''
        if self.is_empty():
            return []
        l = []
        currentNode = self.head.next
        while currentNode != self.head:
            l.append(currentNode.item)
            if currentNode.next == self.head:
                return l
            currentNode = currentNode.next


    def python_list_reversed(self):
        '''Return a Python list representation of OrderedList, from tail to head, using recursion
           For example, list with integers 1, 2, and 3 would return [3, 2, 1]
           To practice recursion, this method must call a RECURSIVE method that
           will return a reversed list
           MUST have O(n) performance'''
        if self.is_empty():
            return []
        l = []
        return self.lHelper(self.head.next,l)


    def size(self):
        '''Returns number of items in the OrderedList
           To practice recursion, this method must call a RECURSIVE method that
           will count and return the number of items in the list
           MUST have O(n) performance'''
        if self.is_empty():
            raise IndexError 
        return self.sizeHelper(1,self.head.next)

    def seachHelper(self,item,node):
        if node.item == item:
            return True 
        if node.next == self.head:
            return False
        return self.seachHelper(item,node.next)

    def sizeHelper(self,counter,node):
        if node.next == self.head:
            return counter
        return self.sizeHelper(counter+1,node.next)

    def lHelper(self,node,l):
        l.insert(0,node.item)
        if node.next != self.head:
           self.lHelper(node.next,l)
        return l
