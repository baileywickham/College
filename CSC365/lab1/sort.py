#blksize = 4096 # One buffer/data block.
memsize = 100
def firstPass(infile):
    l = []
    n = 0 # Num of chunks
    with open(infile, 'r') as f:
        for line in f:
            l.append(int(line.strip('\n')))
            if len(l) == memsize:
                with open(f'chunks/outfile{n}', 'w') as outfile:
                    l.sort()
                    for i in l:
                        outfile.write(f'{i}\n')
                    n += 1
                    l = []
        # Write final bytes
        with open(f'chunks/outfile{n}', 'w') as outfile:
            l.sort()
            for i in l:
                outfile.write(f'{i}\n')
    return n + 1



# n num of chunks
def secondPass(n):
    buffer = []
    files = []
    outfile = open('sorted', 'w')
    bufsize = memsize//n

    for i in range(n):
        files.append(open(f'chunks/outfile{i}', 'r'))
        l = []
        for _ in range(bufsize):
            l.append(files[-1].readline().strip('\n'))
        buffer += map(int, filter(lambda x: x != '', l))

    buffer.sort()
    while files != []:
        for f in files:
            outfile.write(f'{buffer[0]}\n')
            i = f.readline().strip('\n')
            if i == '':
                f.close()
                files.remove(f)
            else:
                buffer.append(int(i))
                buffer.sort()

    for i in sorted(buffer):
        outfile.write(f'{i}\n')

if __name__ == "__main__":
    secondPass(firstPass('data'))
