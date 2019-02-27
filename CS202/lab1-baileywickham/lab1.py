#import sys; sys.setrecursionlimit(10)
"""
def sort(f):
    def inner(*args):
        #overly complicated way to check values and ensure sorted list
        if args[3] is None:
            raise ValueError
        bin_search(args[0],args[1],args[2],sorted(args[3]))
    return inner
"""
def max_list_iter(int_list):  # must use iteration not recursion
    """finds the max of a list of numbers and returns the value (not the index)
    If int_list is empty, returns None. If list is None, raises ValueError"""
    
    if int_list is None: raise ValueError  
    if not int_list:
        return None
    else:
        m = int_list[0]
    #return max(int_list) not sure if this is allowed 
    for i in int_list:
        if i > m:
            m = i
    return m


def reverse_rec(int_list):   # must use recursion
    """recursively reverses a list of numbers and returns the reversed list
    If list is None, raises ValueError"""
    
    if int_list is None:
        raise ValueError

    if not int_list:
        return []
    return [int_list[-1]] + reverse_rec(int_list[:-1])

#@sort
def bin_search(target, low, high, int_list):  # must use recursion
    """searches for target in int_list[low..high] and returns index if found
    If target is not found returns None. If list is None, raises ValueError """
    middle = (low + high)//2
    if int_list[middle] == target: return middle

    if low >= high: return None

    elif int_list[middle] > target:
        return bin_search(target, low, middle - 1, int_list)
    
    elif int_list[middle] < target:
        return bin_search(target, middle + 1, high, int_list)
    

if __name__ == '__main__':
    pass
    #print(bin_search(4, 0, 10, [int(x) for x in input()]))
    #print(reverse_rec([1,2,3]))

