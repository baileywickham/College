class HashTable:

    def __init__(self, table_size):         # can add additional attributes
        self.table_size = table_size        # initial table size
        self.hash_table = [None]*table_size # hash table
        self.num_items = 0                  # empty hash table

    def insert(self, key, value):
        """ Inserts an entry into the hash table (using Horner hash function to determine index,
        and quadratic probing to resolve collisions).
        The key is a string (a word) to be entered, and value is the line number that the word appears on.
        If the key is not already in the table, then the key is inserted, and the value is used as the first
        line number in the list of line numbers. If the key is in the table, then the value is appended to that
        key’s list of line numbers. If value is not used for a particular hash table (e.g. the stop words hash table),
        if the value is not used for a particular hash table eg the stop words hash table, can use the defualt of 0 for the value and just call the insert funciton with a key
        if load factor is greater than 0.5 after an insertion, hash table size should be increased (doubled + 1)."""
        oh = self.horner_hash(key)
        h = oh
        for i in range(self.table_size + 1):
            if self.hash_table[h] is None:
                self.hash_table[h] = (str(key), [value])
                self.num_items += 1
                break
            elif self.hash_table[h] is not None and self.hash_table[h][0] == key:
                self.hash_table[h][1].append(value)
                break
            h = (oh + (i * i)) % self.table_size
        if self.get_load_factor() > 0.5: 
            self.resize()

    def resize(self):
        pre = [x for x in self.hash_table if x is not None]
        self.table_size = self.table_size * 2 + 1
        self.hash_table = [None]*(self.table_size*2+1)
        self.num_items = 0
        for i in pre:
            for l in i[1]:
                self.insert(i[0],l)


    def horner_hash(self, key):
        """ Compute and return an integer from 0 to the (size of the hash table) - 1
        Compute the hash value by using Horner’s rule, as described in project specification."""
        n = min(len(key), 8)
        ret = 0
        for i in range(n):
            ret += (ord(key[i])) * (31 ** (n-1- i))
        return ret % self.table_size

    def in_table(self, key):
        """ Returns True if key is in an entry of the hash table, False otherwise."""

        oh = self.horner_hash(key)
        h = oh
        for i in range(0,self.table_size,1):
            if self.hash_table[h] == None:
                break
            elif self.hash_table[h][0] == key:
                return True
            else:
                h = (oh + i * i) % self.table_size

            '''
            if self.hash_table[h] is None 
            elif self.hash_table[h][0] != key:

                h = (oh + i * i) % self.table_size
            else:
                return True 
                #if self.hash_table[h][0] == key:
            '''
        return False

    def get_index(self, key):
        """ Returns the index of the hash table entry containing the provided key.
        If there is not an entry with the provided key, returns None."""
    
        oh = self.horner_hash(key)
        h = oh
        
        for i in range(0,self.table_size,1):
            if self.hash_table[h] is None or self.hash_table[h][0] != key:
                h = (oh + i * i) % self.table_size
            else:
                return h
                #if self.hash_table[h][0] == key:
        return None


    def get_all_keys(self):
        """(( Returns a Python list of all keys in the hash table."""
        return [x[0] for x in self.hash_table if x is not None]

    def get_value(self, key):
        """ Returns the value (list of line numbers) associated with the key.
        If key is not in hash table, returns None."""
        i = self.get_index(key)
        if i is None:
            return None
        return self.hash_table[i][1]

    def get_num_items(self):
        """ Returns the number of entries (words) in the table."""
        return self.num_items

    def get_table_size(self):
        """ Returns the size of the hash table."""
        return self.table_size

    def get_load_factor(self):
        """ ((Returns the load factor of the hash table (entries / table_size)."""
        return self.num_items / self.table_size

