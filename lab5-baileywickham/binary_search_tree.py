from queue_array import Queue

class TreeNode:
    def __init__(self, key, data, left=None, right=None):
        self.key = key
        self.data = data
        self.left = left
        self.right = right

class BinarySearchTree:

    def __init__(self): # Returns empty BST
        self.root = None

    def is_empty(self): # returns True if tree is empty, else False
        if self.root == None:
            return True
        return False


    def search(self, key): # returns True if key is in a node of the tree, else False
        if self.is_empty():
            return None
        return search_helper(self.root,key)

    def insert(self, key, data=None): # inserts new node w/ key and data
        # If an item with the given key is already in the BST, 
        # the data in the tree will be replaced with the new data
        # Example creation of node: temp = TreeNode(key, data)
        temp = TreeNode(key,data)
        if self.is_empty():
            self.root = temp
            return
        node = self.root
        while True:
            if key > node.key:
                if node.right == None:
                    node.right = temp
                    return
                else:
                    node = node.right
            elif key < node.key:
                if node.left == None:
                    node.left = temp
                    return
                else:
                    node = node.left 
            elif key == node.key:
                node.data = data
                return
            

    def find_min(self): # returns a tuple with min key and data in the BST
        # returns None if the tree is empty
        if self.is_empty():
            return None
        node = self.root
        while True:
            if node.left == None:
                return (node.key, node.data)
            else:
                node = node.left

    def find_max(self): # returns a tuple with max key and data in the BST
        # returns None if the tree is empty
        if self.is_empty():
            return None
        node = self.root
        while True:
            if node.right == None:
                return (node.key, node.data)
            else:
                node = node.right

    def tree_height(self): # return the height of the tree
        # returns None if tree is empty
        if self.is_empty():
            return None
        return tree_height_helper(self.root) 

    def inorder_list(self): # return Python list of BST keys representing in-order traversal of BST
        return inorder_list_helper(self.root)

    def preorder_list(self):  # return Python list of BST keys representing pre-order traversal of BST
        return preorder_list_helper(self.root) 

    def level_order_list(self):  # return Python list of BST keys representing level-order traversal of BST
        # You MUST use your queue_array data structure from lab 3 to implement this method
        q = Queue(25000) # Don't change this!
        q.enqueue(self.root)
        l = []
        while not q.is_empty():
            node = q.dequeue()
            l.append(node.key)
            if node.left != None:
                q.enqueue(node.left)
            if node.right != None:
                q.enqueue(node.right)
        return l

        
def tree_height_helper(node):
    if node.left is None and node.right is None:
        return 0
    if node.left is None:
        return 1 + tree_height_helper(node.right)
    if node.right is None:
        return 1 + tree_height_helper(node.left)
    return 1 + max(tree_height_helper(node.left),tree_height_helper(node.right))

def search_helper(node, key):
    if node is None:
        return False
    if node.key == key:
        return True
    if search_helper(node.left,key) or search_helper(node.right,key):
        return True
    return False

def inorder_list_helper(node):
    if node is None:
        return []
    return inorder_list_helper(node.left) + [node.key] + inorder_list_helper(node.right)

def preorder_list_helper(node):
    if node is None:
        return []
    return [node.key] + preorder_list_helper(node.left) + preorder_list_helper(node.right)


b = BinarySearchTree()
b.insert(10,'first')
b.insert(11)
b.insert(9)

