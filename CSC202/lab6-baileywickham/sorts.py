import random
import time

def selection_sort(l):
    comps = 0
    for i in range(len(l)):
        minIndex = i
        for j in range(i + 1,len(l)):
            comps += 1
            if l[minIndex] > l[j]:
                minIndex = j
        l[i], l[minIndex] = l[minIndex], l[i] 
    return comps

def insertion_sort(arr): 
    if len(arr) == 0:
        return 0
    count = 0 
    # Traverse through 1 to len(arr) 
    for i in range(1, len(arr)): 
        key = arr[i] 
        j = i-1
        while True: 
            if j >=0: 
                count += 1
                if key < arr[j]:
                    arr[j+1] = arr[j] 
                    j -= 1
                else: break
            else: break
        arr[j+1] = key 
    return count

