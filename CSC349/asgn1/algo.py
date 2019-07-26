import sys


def algo(l, minn, maxx):
    mid = (minn + maxx) // 2
    left = l[mid-1] if mid - 1 > 0 else None
    right = l[mid+1] if mid + 1 < len(l) else None
    if mid % 2 == 1:
        if right != l[mid]:
            if left != l[mid]:
                return l[mid]
            return algo(l, mid, maxx)
        return algo(l, minn, mid)
    if right != l[mid]:
        if left != l[mid]:
            return l[mid]
        return algo(l, minn, mid)
    return algo(l, mid, maxx)


def main():
    if len(sys.argv) > 1:
        with open(sys.argv[1], 'r') as f:
            line = f.readline().strip().split(', ')
        if len(line) == 1:
            print(line[0])
            return
    print(algo(line, 0, len(line)))


main()
