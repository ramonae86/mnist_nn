import numpy as np
import time
import textwrap
import numbers

a = []

for i in range(-20, 20, 1):
    a.append(i)

print(a)

a = np.array(a)
print([a<10])
# a[a<10] = 0
#
# print(a)

a = np.array([[17, 18, 19, 20, 21], [0, 0, 0, 0, 26], [27, 28, 0, 0, 0], [0, 0, 0, 0, 0]])

b = np.count_nonzero(a)/a.size < (8/19)

print(b)

print(np.count_nonzero(a[2][1:4]))

print(format(23, '0{}b'.format(10)))

a = [0] * 5
a[2] = 'd'
print(a)
