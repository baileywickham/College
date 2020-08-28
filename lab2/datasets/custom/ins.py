import csv
import sys
import argparse
import os

parser = argparse.ArgumentParser()
rows = [3,4]



def parse_data(table, filepath):
    seen = []
    with open(filepath, 'r') as f:
        r = csv.reader(f)
        header = next(r)
        # hack
        if 'rows' in globals():
            cols = ','.join([header[x] for x in rows])
        else:
            cols = ','.join(header)#.strip('\n')
        for i, line in enumerate(r):
            if line == []:
                return
            if 'rows' in globals():
                line = [line[x] for x in rows]
            values = ','.join(f"'{w.strip()}'" if not w.isdigit() else f'{w}' for w in line)
            tmp = f'''INSERT INTO {table} (storeid, {cols}) VALUES ({i, values});'''
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
