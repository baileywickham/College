import math
import time
from random import random


def selection_sort(A):
    for i in range(len(A)):
        min_idx = i
        for j in range(i+1, len(A)):
            if A[min_idx] > A[j]:
                min_idx = j

        # Swap the found minimum element with
        # the first element
        A[i], A[min_idx] = A[min_idx], A[i]
    return A


def merge_sort(A):
    if A is None or len(A) == 1:
        return A
    else:
        mid = len(A) // 2
        return merge(merge_sort(A[mid:]), merge_sort(A[:mid]))


def mergeSort(arr):
    if len(arr) > 1:
        mid = len(arr)//2  # Finding the mid of the array
        L = arr[:mid]  # Dividing the array elements
        R = arr[mid:]  # into 2 halves

        mergeSort(L)  # Sorting the first half
        mergeSort(R)  # Sorting the second half

        i = j = k = 0
        while i < len(L) and j < len(R):
            if L[i] < R[j]:
                arr[k] = L[i]
                i += 1
            else:
                arr[k] = R[j]
                j += 1
            k += 1

        while i < len(L):
            arr[k] = L[i]
            i += 1
            k += 1

        while j < len(R):
            arr[k] = R[j]
            j += 1
            k += 1


def merge(X, Y):
    if X is None or X == []:
        return Y
    if Y is None or Y == []:
        return X
    i, j = 0, 0
    l = []
    while i < len(X) and j < len(Y):
        if X[i] < Y[j]:
            l.append(X[i])
            i += 1
        else:
            l.append(Y[j])
            j += 1
    while i < len(X):
        l.append(X[i])
        i += 1
    while j < len(Y):
        l.append(Y[j])
        j += 1

    return l


def main():
    m()
    s()


def s():
    with open('selection', 'w') as f:
        for i in range(10000, 20000, 20):
            start = time.time()
            l = [random()*1000 for _ in range(i)]
            l = selection_sort(l)
            print('{}'.format(time.time() - start))
            f.write('{}\n'.format(time.time() - start))
    print('selection  complete')


def m():
    with open('merge', 'w') as f:
        for i in range(10000, 20000, 20):
            start = time.time()
            l = [random() for _ in range(i)]
            mergeSort(l)
            print('{}'.format(time.time() - start))
            f.write('{}\n'.format(time.time() - start))

    print('Merge completed')


if __name__ == '__main__':
    main()
