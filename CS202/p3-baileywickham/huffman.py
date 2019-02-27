import pdb
class HuffmanNode:
    def __init__(self, char, freq):
        self.char = char   # stored as an integer - the ASCII character code value
        self.freq = freq   # the freqency associated with the node
        self.left = None   # Huffman tree (node) to the left
        self.right = None  # Huffman tree (node) to the right

    def set_left(self, node):
        self.left = node

    def set_right(self, node):
        self.right = node
    def __lt__(self,node):
        return comes_before(self,node)

def comes_before(a, b):
    """Returns True if tree rooted at node a comes before tree rooted at node b, False otherwise"""
    if a.freq == b.freq:
        return a.char < b.char
    return a.freq < b.freq


def combine(a, b):
    """Creates and returns a new Huffman node with children a and b, with the "lesser node" on the left
    The new node's frequency value will be the sum of the a and b frequencies
    The new node's char value will be the lesser of the a and b char ASCII values"""
    node0 = a; node1 = b
    if comes_before(node0,node1):
        newNode = HuffmanNode(min(node0.char,node1.char), node0.freq + node1.freq)
        newNode.left = node0
        newNode.right = node1
        return newNode 
    else:
        newNode = HuffmanNode(min(node0.char,node1.char), node0.freq + node1.freq)
        newNode.left = node1
        newNode.right = node0
        return newNode 

def cnt_freq(filename):
    """Opens a text file with a given file name (passed as a string) and counts the 
    frequency of occurrences of all the characters within that file"""
    bitlist = [0]*256
    with open(filename,'r') as f:
        for i in f.read():
            bitlist[ord(i)] += 1
    return bitlist


def create_huff_tree(char_freq):
    """Create a Huffman tree for characters with non-zero frequency
    Returns the root node of the Huffman tree"""
    huffs = []
    for char,freq in enumerate(char_freq):
        if int(freq) > 0:
            huffs.append(HuffmanNode(char,freq))

    while len(huffs) > 1:
        huffs.sort()
        node0 = huffs.pop(0)
        node1 = huffs.pop(0)
        huffs.append(combine(node0,node1))

    return huffs[0]


def create_code(node):
    """Returns an array (Python list) of Huffman codes. For each character, use the integer ASCII representation 
    as the index into the arrary, with the resulting Huffman code for that character stored at that location"""
    requiredl = ['']*256
    return trav(node,'',requiredl)
    


def create_header(freqs):
    """Input is the list of frequencies. Creates and returns a header for the output file
    Example: For the frequency list asscoaied with "aaabbbbcc, would return “97 3 98 4 99 2” """
    outstr = ''
    for char,freq in enumerate(freqs):
        if freq > 0:
            outstr = f'{outstr} {char} {freq}'
    return outstr.strip() 
            

def huffman_encode(in_file, out_file):
    """Takes inout file name and output file name as parameters
    Uses the Huffman coding process on the text from the input file and writes encoded text to output file
    Take not of special cases - empty file and file with only one unique character"""
    freq = cnt_freq(in_file)
    if max(freq) == 0:
        open(out_file,'w').write('')
        return

    outstr = create_header(freq)
    compression = ''

    codes = create_code(create_huff_tree(freq))

    with open(in_file, 'r') as i:
        for char in i.read():
            compression += codes[ord(char)]
    with open(out_file, 'w') as f:
        f.write(outstr + '\n' + compression)
        
def trav(node,code,requiredl):
    if node != None:
        if node.left == None and node.right == None:
            requiredl[node.char] = code
        else:
            if node.left != None:
                trav(node.left,code + '0', requiredl)
            if node.right != None:
                trav(node.right,code + '1', requiredl)
    return requiredl

def huffman_decode(encoded_file,decode_file):
    contents = []
    with open(encoded_file) as f:
        contents = f.readlines()
    if contents == []:
        open(decode_file,'w').write('')
        return
    contents = [i.strip('\n') for i in contents]
    outstr = ''
    ht = create_huff_tree(parse_header(contents[0]))
    node = ht
    if len(contents) == 1:
        with open(decode_file, 'w') as f:
            f.write(str(chr(ht.char))*ht.freq)
        return
    for char in list(contents[1]):
        if int(char) == 1:
            node = node.right
            if node.left == None and node.right == None:
                outstr += str(chr(node.char))
                node = ht
        elif int(char) == 0:
            node = node.left
            if node.left == None and node.right == None:
                outstr += str(chr(node.char))
                node = ht
    with open(decode_file, 'w') as f:
        f.write(outstr)

def parse_header(header_string):
    l = [0]*256
    header_string =  header_string.split(' ')
    for key, i in enumerate(header_string):
        l[int(i)] = int(header_string.pop(key+1))
    return l

