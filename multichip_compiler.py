import numpy as np
import math
from compiler import *
from tierson import Tierson

LB_SIZE = 1024
weights, bias = extract_weight_bias_from_model()

def multichip_parse():
    # a sequence of numbers that represents number of chips needed for every pair of layers
    num_chips = []

    for layer_weights in weights:
        num_input = (layer_weights.shape)[0]
        num_output = (layer_weights.shape)[1]
        if num_input + num_output >= LB_SIZE:
            if num_input >= LB_SIZE or num_output >= LB_SIZE:
                print("ERROR: one single layer cannot exceed layer buffer size")
                exit(-1)
            else:
                num_chips.append(math.ceil(num_output/(LB_SIZE-num_input)))
        else:
            num_chips.append(1)

    return num_chips


def near_even_divide(dividend, divisor):
    residual= dividend
    floor_quotient = dividend//divisor
    result = []
    for i in range(divisor):
        if floor_quotient*(divisor-i) == residual:
            result.append(floor_quotient)
            residual -= floor_quotient
        else:
            result.append(floor_quotient+1)
            residual -= floor_quotient+1
    return result

'''
    Call this function for a SINGLE layer to allocate weights and bias in this layer to different chips
'''
def weights_bias_alloc(layer_num_chips, layer_weights, layer_bias):
    num_input = (layer_weights.shape)[0]
    num_output = (layer_weights.shape)[1]
    split_sizes = near_even_divide(num_output, layer_num_chips)
    chips_list = []
    for i in range(layer_num_chips):
        new_chip = Tierson(num_input=num_input, num_output=num_output)
        chip_weights = layer_weights[:][sum(split_sizes[:i]):sum(split_sizes[:i])+split_sizes[i]]
        chip_bias = layer_bias[sum(split_sizes[:i]):sum(split_sizes[:i])+split_sizes[i]]
        new_chip.set_weights(chip_weights)
        new_chip.set_bias(chip_bias)
        chips_list.append(new_chip)



def multichip_compile():
    num_chips_list = multichip_parse()
    print(num_chips_list)
    for ith_layer, num_chips in enumerate(num_chips_list):
        weights_bias_alloc(layer_num_chips=num_chips, layer_weights=weights[ith_layer], layer_bias=bias[ith_layer])


if __name__ == '__main__':
    multichip_compile()
    # print(near_even_divide(dividend=298, divisor=4))