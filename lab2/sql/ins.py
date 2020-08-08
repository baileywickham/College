import csv
import sys
import argparse
import os

parser = argparse.ArgumentParser()
#rows = [0,5,6]

def get_type(n):
    try:
        f = float(n)
        if '.' in n:
            return 'DECIMAL(10,2)'
        return 'INT'
    except:
        return 'VARCHAR(100)'

def gen_table(table, filepath):
    with open(filepath, 'r') as f:
        r = csv.reader(f)
        header = next(r)
        data = next(r)
        s = f'CREATE TABLE {table} ('
        for i,item in enumerate(header):
                s += f'{item} {get_type(data[i])},\n'
        print(s)


def parse_data(table, filepath):
    seen = []
    with open(filepath, 'r') as f:
        r = csv.reader(f)
        header = next(r)
        # hack
        if 'rows' in globals(): #hack
            cols = ','.join([header[x] for x in rows])
        else:
            cols = ','.join(header)#.strip('\n')
        for line in r:
            if line == []:
                return
            if 'rows' in globals():
                line = [line[x] for x in rows]
            values = ','.join(f"'{w.strip()}'" if not w.isdigit() else f'{w}' for w in line)
            tmp = f'''INSERT INTO {table} ({cols}) VALUES ({values});'''
            if tmp not in seen:
                print(tmp)
                seen.append(tmp)

if __name__ == "__main__":
    parser.add_argument('filepath', help='path to file to parse')
    parser.add_argument('-t', '--table', help='table name')
    args = parser.parse_args()

    if args.table:
        parse_data(args.table, args.filepath)
    else:
        parse_data(os.path.basename(sys.argv[1]).split('.')[0], args.filepath)
