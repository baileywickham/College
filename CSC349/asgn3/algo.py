import sys

count = 1


class student:
    def __init__(self, args, count):
        args = list(map(int, args))
        self.swim = args[0]
        self.run = args[1]
        self.bike = args[2]
        self.count = count


def main():
    students = []
    with open(sys.argv[1], 'r') as f:
        for s in f:
            students.append(
                student(s[s.find('(')+1:s.find(')')].strip('\n').split(','), count))
            count += 1

    students.sort(key=lambda s: s.run+s.bike, reverse=True)
    print('sequence: ', end='')
    print(*(x.count for x in students), sep=',')

    rtime = 0
    t = 0
    while students:
        s = students.pop(0)
        t += s.swim
        rtime -= s.swim
        rtime = 0 if rtime < 0 else rtime
        rtime = max(rtime, s.bike + s.run)

    t += rtime
    print('completion time:', t,)
