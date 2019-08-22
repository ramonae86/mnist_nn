import numpy as np
import time
import textwrap
import numbers

def bias_to_hex(biases, scale, num_bytes = 4):
    if len(biases) < 4:
        complete_biases = biases + [0] * (4 - len(biases))
    elif len(biases) == 4:
        complete_biases = biases
    else:
        print("bias_array length should be less than 4")
        return False

    hex_array = []
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
        hex_array.append(format(binary, '08x').upper())
    print(hex_array)
    # interleave array
    interleaved_array = []
    for i in range(num_bytes):
        interleaved_bias = hex_array[0][8 - 2*i - 2 :8 - 2*i] + hex_array[1][8 - 2*i - 2 :8 - 2*i] + hex_array[2][8 - 2*i - 2 :8 - 2*i] + hex_array[3][8 - 2*i - 2 :8 - 2*i]
        print(interleaved_bias)
        interleaved_array.append(interleaved_bias)
    print(interleaved_array)
    return complete_biases

a = [1, 2555, 9999142]
print(bias_to_hex(a, scale = 1, num_bytes=4))