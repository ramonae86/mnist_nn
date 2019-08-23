import numpy as np
import time
import textwrap
import numbers

def biases_to_binary(biases, scale, num_bytes = 4):
    """

    :param biases: array of bias, type is ndarray!
    :param scale: bias scale
    :param num_bytes: number of bytes to encode each bias
    :return:
    """
    if len(biases) < 4:
        complete_biases = np.append(biases, [0] * (4 - len(biases)))
    elif len(biases) == 4:
        complete_biases = biases
    else:
        print("bias_array length should be less than 4")
        return False

    bin_array = []
    for ith_bias in complete_biases:
        if num_bytes == 4:
            if ith_bias * scale > 2 ** 31 - 1:
                entry = 2 ** 31 - 1
            elif ith_bias * scale < 0:
                entry = 0
            else:
                entry = ith_bias * scale
            binary = int(entry) & 0xFFFFFFFF
        elif num_bytes == 3:
            if ith_bias * scale > 2 ** 23 - 1:
                entry = 2 ** 23 - 1
            elif ith_bias * scale < 0:
                entry = 0
            else:
                entry = ith_bias * scale
            binary = int(entry) & 0xFFFFFF
        elif num_bytes == 2:
            if ith_bias * scale > 2 ** 15 - 1:
                entry = 2 ** 15 - 1
            elif ith_bias * scale < 0:
                entry = 0
            else:
                entry = ith_bias * scale
            binary = int(entry) & 0xFFFF
        else:
            if ith_bias * scale > 2 ** 7 - 1:
                entry = 2 ** 7 - 1
            elif ith_bias * scale < 0:
                entry = 0
            else:
                entry = ith_bias * scale
            binary = int(entry) & 0xFF
        bin_array.append(format(binary, '032b').upper())
    print(bin_array)
    # interleave array
    interleaved_array = []
    for i in range(num_bytes):
        interleaved_bias = bin_array[0][32 - 8*i - 8 :32 - 8*i] + bin_array[1][32 - 8*i - 8 :32 - 8*i] + bin_array[2][32 - 8*i - 8 :32 - 8*i] + bin_array[3][32 - 8*i - 8 :32 - 8*i]
        interleaved_array.append(interleaved_bias)
    return interleaved_array


a = np.array([1, 2555, 99142])
print(biases_to_binary(a, scale = 1, num_bytes=3))
print(biases_to_binary(a, scale = 1, num_bytes=4))

b = 234
print(format(b, '04x').upper())