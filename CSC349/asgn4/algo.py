import sys
import pprint


class te:
    def __init__(self, cost, x, y, last):
        self.cost = cost
        self.x = x
        self.y = y
        self.last = last

    def __repr__(self):
        return f'[{self.cost},{self.x},{self.y}]'


class table:
    def __init__(self, g):
        self.t = []
        self.rows = len(g.y)
        self.columns = len(g.x)
        for _ in range(self.rows):
            self.t.append([None]*self.columns)

        self.insert(0, 0, te(0, '-', '-', None))

        rt = 0
        for i in range(1, self.columns, 1):
            rt += g.lookup(g.x[i], '-')
            self.insert(i, 0, te(rt, g.x[i], '-', self.lookup(i-1, 0)))

        rt = 0
        for i in range(1, self.rows, 1):
            rt += g.lookup(g.y[i], '-')
            self.insert(0, i, te(rt, '-', g.y[i], self.lookup(0, i-1)))

    def lookup(self, i, j):
        return self.t[j][i]

    def insert(self, i, j, obj):
        self.t[j][i] = obj

    def __repr__(self):
        for row in range(self.rows):
            for col in range(self.columns):
                print(self.t[row][col], end='')
            print()
        return 'a'


class gene:
    def __init__(self, f):
        self.colookupmn = {'A': 1, 'C': 2, 'G': 3, 'T': 4, '-': 5}
        with open(f, 'r') as f:
            self.x = '-'+f.readline().strip('\n')
            self.y = '-'+f.readline().strip('\n')
            self.m = []
            for line in f:
                self.m.append(line.strip('\n').split(' '))

    def lookup(self, r, c):
        for row in self.m:
            if row[0] == str(r):
                return int(row[self.colookupmn[c]])


def calc(g, tbl):
    for i in range(1, tbl.columns, 1):
        for j in range(1, tbl.rows, 1):
            tbl.insert(i, j, max(g, tbl, i, j))


def max(g, tbl, i, j):
    m = 0
    matching = None
    a = tbl.lookup(i-1, j).cost + g.lookup(g.x[i], '-')
    b = tbl.lookup(i, j-1).cost + g.lookup('-', g.y[j])
    c = tbl.lookup(i-1, j-1).cost + g.lookup(g.x[i], g.y[j])

    if a >= b:
        m = a
        matching = (g.x[i], '-')
        last = tbl.lookup(i-1, j)
    else:
        m = b
        matching = ('-', g.y[j])
        last = tbl.lookup(i, j-1)
    if c > m:
        m = c
        matching = (g.x[i], g.y[j])
        last = tbl.lookup(i-1, j-1)

    return te(m, matching[0], matching[1], last)


def main():
    g = gene(sys.argv[1])
    tbl = table(g)

    calc(g, tbl)

    m = tbl.lookup(tbl.columns-1, tbl.rows-1)
    cost = m.cost

    outx = ''
    outy = ''
    while m != None:
        outx += m.x
        outy += m.y
        m = m.last
    outx = outx[:-1]
    outy = outy[:-1]

    if (len(g.x) == len(g.y) == 2):
        outx = g.x[1]
        outy = g.y[1]
        cost = g.lookup(outx, outy)

    print('x:', ' '.join(outx[::-1]))
    print('y:', ' '.join(outy[::-1]))
    print('Score:', cost)


if __name__ == "__main__":
    main()
