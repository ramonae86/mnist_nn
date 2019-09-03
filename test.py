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