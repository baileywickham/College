from stack_array import * #Needed for Depth First Search
from queue_array import * #Needed for Breadth First Search

class Vertex:
    '''Add additional helper methods if necessary.'''
    def __init__(self, key):
        '''Add other attributes as necessary'''
        self.id = key
        self.adjacent_to = []
        self.seen = False
        self.color = None


class Graph:
    '''Add additional helper methods if necessary.'''
    def __init__(self, filename):
        '''reads in the specification of a graph and creates a graph using an adjacency list representation.  
           You may assume the graph is not empty and is a correct specification.  E.g. each edge is 
           represented by a pair of vertices.  Note that the graph is not directed so each edge specified 
           in the input file should appear on the adjacency list of each vertex of the two vertices associated 
           with the edge.'''
        self.verts = {}
        with open(filename, 'r') as f:
            for l in f.readlines():
                l = l.strip('\n')
                l = l.split(' ')
                self.add_vertex(l[0])
                self.add_vertex(l[1])
                self.add_edge(l[0],l[1])
                


    def add_vertex(self, key):
        '''Add vertex to graph, only if the vertex is not already in the graph.'''
        if key not in self.verts:
            self.verts[key] = Vertex(key)

    def get_vertex(self, key):
        '''Return the Vertex object associated with the id. If id is not in the graph, return None'''
        if key not in self.verts:
            return None
        return self.verts[key]
            

    def add_edge(self, v1, v2):
        '''v1 and v2 are vertex id's. As this is an undirected graph, add an 
           edge from v1 to v2 and an edge from v2 to v1.  You can assume that
           v1 and v2 are already in the graph'''
        self.verts[v1].adjacent_to.append(v2)
        self.verts[v2].adjacent_to.append(v1)

    def get_vertices(self):
        '''Returns a list of id's representing the vertices in the graph, in ascending order'''
        return sorted(list(set([x for x in self.verts.keys()])))

    def conn_components(self): 
        '''Returns a list of lists.  For example, if there are three connected components 
           then you will return a list of three lists.  Each sub list will contain the 
           vertices (in ascending order) in the connected component represented by that list.
           The overall list will also be in ascending order based on the first item of each sublist.
           This method MUST use Depth First Search logic!'''
        start = min(self.verts)
        ret = self.conn_helper(start)
        returnList = [ret]
        l = list(set(self.verts) - set(ret))
        while len(l) > 0:
            r = self.conn_helper(l[0]) 
            returnList.append(r)
            l = list(set(l)-set(r))
        return sorted(returnList)
          
        
    def conn_helper(self, v):
        s = Stack(len(self.verts) + 1)
        s.push(v)
        self.verts[v].seen = True
        ret = []
        while not s.is_empty():
            r = s.pop()
            ret.append(r)
            for v in self.verts[r].adjacent_to:
                if not self.verts[v].seen:
                    s.push(v)
                    self.verts[v].seen = True
        return sorted(ret)

    def is_bipartite(self):
        '''Returns True if the graph is bicolorable and False otherwise.
           This method MUST use Breadth First Search logic!'''
        start = min(self.verts)
        s =  self.bi_helper(start)
        for x in self.verts.keys():
            self.verts[x] = None
        return s
       

    def bi_helper(self,v):
        q = Queue(250000)
        q.enqueue(v)
        self.verts[v].color = False 
        seen = {}
        while not q.is_empty():
            r = q.dequeue()
            seen[r] = r
            for v in self.verts[r].adjacent_to:
                cc = self.verts[r].color
                if v not in seen: 
                    q.enqueue(v)
                if self.verts[v].color == None or self.verts[v].color == (not cc):
                    self.verts[v].color = (not cc)
                elif self.verts[v].color == cc:
                    return False

        return True

