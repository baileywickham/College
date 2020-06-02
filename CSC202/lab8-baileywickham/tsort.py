from sys import argv
from stack_array import *

def tsort(vertices):
    '''
    * Performs a topological sort of the specified directed acyclic graph.  The
    * graph is given as a list of vertices where each pair of vertices represents
    * an edge in the graph.  The resulting string return value will be formatted
    * identically to the Unix utility {@code tsort}.  That is, one vertex per
    * line in topologically sorted order.
    *
    * Raises a ValueError if:
    *   - vertices is emtpy with the message "input contains no edges"
    *   - vertices has an odd number of vertices (incomplete pair) with the
    *     message "input contains an odd number of tokens"
    *   - the graph contains a cycle (isn't acyclic) with the message 
    *     "input contains a cycle"'''
    if vertices == []:
        raise ValueError("input contains no edges")
    if len(vertices) % 2 != 0:
        raise ValueError("input contains an odd number of tokens")
    al = {}
    el = []
    s = Stack(len(vertices))
    outstr = ''
    for i in range(0,len(vertices),2):
        if vertices[i] not in al:
            al[vertices[i]] = [0, [], str(vertices[i])]
            el.append(vertices[i])

        if vertices[i+1] not in al:
            al[vertices[i+1]] = [0, [], str(vertices[i+1])]
        al[vertices[i]][1].append(vertices[i+1])
        al[vertices[i+1]][0] += 1 
    for i in el:
        if al[i][0] == 0:
            s.push(al[i])
            del al[i]

    while not s.is_empty():
        v = s.pop()
        for i in v[1]:
            al[i][0] -= 1
            if al[i][0] == 0:
                s.push(al[i])
                del al[i]
        outstr += v[2] + '\n'
    if al:
        raise ValueError("input contains a cycle")
    return outstr

