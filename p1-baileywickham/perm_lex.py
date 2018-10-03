#import itertools; itertools.premutations(a)
def perm_gen_lex(a): 
    if a is None:
        raise ValueError
    if len(a) == 1: 
        return [a]
    li = []
    for key, char in enumerate(a):
        c = list(a)
        newlist = c.pop(key)
        nw = ''.join(carac for carac in c)
        for i in perm_gen_lex(nw):
            li.append(newlist + i)
        #li.append([char + perm_gen_lex(newlist)])
    
    return li        
