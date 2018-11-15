
class MaxHeap:

    def __init__(self, capacity=50):
        """Constructor creating an empty heap with default capacity = 50 but allows heaps of other capacities to be created."""
        self.capacity = capacity
        self.size = 0
        self.items = [0]

    def enqueue(self, item):
        """inserts "item" into the heap, returns true if successful, false if there is no room in the heap"""
        if self.is_full():
            return False
        self.items.append(item)
        self.size += 1
        self.perc_up(self.size)
        return True


    def peek(self):
        """returns max without changing the heap, returns None if the heap is empty"""
        if self.is_empty():
            return None
        return self.items[1]


    def dequeue(self):
        """returns max and removes it from the heap and restores the heap property
           returns None if the heap is empty"""
        if self.is_empty():
            return None
        r = self.items[1]
        self.items[1] = self.items[self.size]
        self.items.pop(self.size)
        self.size -= 1
        self.perc_down(1)
        return r


    def contents(self):
        """returns a list of contents of the heap in the order it is stored internal to the heap.
        (This may be useful for in testing your implementation.)"""
        return self.items[1:]



    def build_heap(self, alist):
        """Builds a heap from the items in alist and builds a heap using the bottom up method.  
        If the capacity of the current heap is less than the number of 
        items in alist, the capacity of the heap will be increased"""
        if self.capacity < len(alist):
            self.capacity = len(alist) + 1
        self.size = len(alist)
        i = len(alist) // 2
        self.items = [0] + alist
        while i > 0:
            self.perc_down(i)
            i = i-1

    def is_empty(self):
        """returns True if the heap is empty, false otherwise"""
        if self.size == 0:
            return True
        return False 


    def is_full(self):
        """returns True if the heap is full, false otherwise"""
        if self.get_capacity() == self.size:
            return True
        return False

        
    def get_capacity(self):
        """this is the maximum number of a entries the heap can hold
        1 less than the number of entries that the array allocated to hold the heap can hold"""
        return self.capacity
    
    
    def get_size(self):
        """the actual number of elements in the heap, not the capacity"""
        return self.size

    def swap(self,a,b):
        self.items[a], self.items[b] = self.items[b], self.items[a]

    def perc_down(self, i):
        """where the parameter i is an index in the heap and perc_down moves the element stored
        at that location to its proper place in the heap rearranging elements as it goes."""
        '''
        l = 2*i 
        r = 2*i + 1
        m = self.items[i]
        if self.size < r:
            if self.size-1< l:
                return
            elif m < self.items[l]:
                self.swap(i,l)
        elif m < self.items[r] or m < self.items[l]:
            print('its less than one')
            if self.items[l] < self.items[r]:
                print('should be swapping',i)
                self.swap(i,r)
            else:
                self.swap(i,l)
        '''
        while i * 2 <= self.size:
            m = self.mc(i)
            if self.items[i] < self.items[m]:
                self.swap(i,m)
            i = m
    def mc(self, i):
        if i * 2 + 1 > self.size:
            return 2 * i
        if self.items[i * 2] > self.items[i * 2 + 1]:
            return i * 2
        return i * 2 + 1

    def perc_up(self, i):
        """where the parameter i is an index in the heap and perc_up moves the element stored
        at that location to its proper place in the heap rearranging elements as it goes."""
        item = self.items[i]
        while i//2>0:
            if item > self.items[i//2]:
                self.swap(i,i//2)
            i = i//2


    def heap_sort_ascending(self, alist):
        """perform heap sort on input alist in ascending order
        This method will discard the current contents of the heap, build a new heap using
        the items in alist, then mutate alist to put the items in ascending order"""
        s = len(alist)
        h = MaxHeap()
        h.build_heap(alist)
        #alist = []
        for i in range(h.size):
            alist.insert(0,h.dequeue())
            alist.pop()


