def bears(n):
    #print(f"N IS {n}")
    if n == 42:
        return True
    if n < 42:
        return False
    
    if n % 5 == 0:
        #print('entering 5')
        if bears(n-42):
            return True
    if n % 3 == 0 or n % 4 == 0:
        # This would never be called below a 2 digit number.
        first = int(str(n)[-1:])
        sec = int(str(n)[-2:-1])
        if first * sec != 0:
            if  bears(n - (first * sec)):
                return True
    if n % 2 == 0:
        #print('entering even')
        if bears(int(n/2)):
            return True
    return False

