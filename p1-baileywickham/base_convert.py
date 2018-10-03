hexmap = {10:'A',11:'B',12:'C',13:'D',14:'E',15:'F'}
def convert(num, b):
    """Recursive function that returns a string representing num in the base b"""
    if num is None or b is None or b is 0:
        raise ValueError

    if num == 0:
        if num % b == 0:
            return ''

    q = int(num / b)
    r = num % b
    if r > 10:
        r = hexmap[r]
    return str(convert(q, b)) + str(r)
