import csv
import sys
import argparse
import os

parser = argparse.ArgumentParser()
#rows = [0,5,6]

def parse(table, filepath):
    seen = []
    with open(filepath, 'r') as f:
        r = csv.reader(f)
        header = next(r)
        if rows:
            cols = ','.join([header[x] for x in rows])
        else:
            cols = ','.join(header)#.strip('\n')
        for line in r:
            if line == []:
                return
            if rows:
                line = [line[x] for x in rows]
            values = ','.join(f"'{w.strip()}'" if not w.isdigit() else f'{w}' for w in line)
            tmp = f'''INSERT INTO {table} ({cols}) VALUES ({values});'''
            if tmp not in seen:
                print(tmp)
                seen.append(tmp)

if __name__ == "__main__":
    parser.add_argument('filepath', help='table name')
    parser.add_argument('-t', '--table', help='table name')
    args = parser.parse_args()

    if args.table:
        parse(args.table, args.filepath)
    else:
        parse(os.path.basename(sys.argv[1]).split('.')[0], args.filepath)
