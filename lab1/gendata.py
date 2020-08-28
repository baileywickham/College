import random

with open('data', 'w') as f:
    for _ in range(500):
        f.write(f'{random.randint(0, 100)}\n')

