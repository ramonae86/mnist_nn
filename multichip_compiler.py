import numpy as np
import math
import tensorflow as tf
from compiler import *
from tierson import Tierson


def near_even_divide(dividend, divisor):
    residual = dividend
    floor_quotient = dividend // divisor
    result = []
    for i in range(divisor):
        if floor_quotient * (divisor - i) == residual:
            result.append(floor_quotient)
            residual -= floor_quotient
        else:
            result.append(floor_quotient + 1)
            residual -= floor_quotient + 1
    return result


class MultichipTierson:
    def __init__(self):
        self.chips_list = []
        self.LB_SIZE = 1024
        self.weights, self.bias = extract_weight_bias_from_model()

    def multichip_parse(self):
        # a sequence of numbers that represents number of chips needed for every pair of layers
        num_chips = []

        for layer_weights in self.weights:
            num_input = layer_weights.shape[0]
            num_output = layer_weights.shape[1]
            if num_input + num_output >= self.LB_SIZE:
                if num_input >= self.LB_SIZE or num_output >= self.LB_SIZE:
                    print("ERROR: one single layer cannot exceed layer buffer size")
                    exit(-1)
                else:
                    num_chips.append(math.ceil(num_output/(self.LB_SIZE-num_input)))
            else:
                num_chips.append(1)
        return num_chips

    def init_chips(self, layer_num_chips, layer_input, layer_weights, layer_bias):
        num_input = layer_weights.shape[0]
        num_output = layer_weights.shape[1]
        split_sizes = near_even_divide(num_output, layer_num_chips)
        for i in range(layer_num_chips):
            # input is duplicated across chips
            new_chip = Tierson(num_input=num_input, num_output=num_output)
            new_chip.set_input(layer_input)

            # weights and bias
            chip_weights = layer_weights[:, sum(split_sizes[:i]):sum(split_sizes[:i])+split_sizes[i]]
            chip_bias = layer_bias[sum(split_sizes[:i]):sum(split_sizes[:i])+split_sizes[i]]
            new_chip.set_weights(chip_weights)
            new_chip.set_bias(chip_bias)

            self.chips_list.append(new_chip)

    def layer_MAC(self):
        for ith_chip, chip in enumerate(self.chips_list):
            print("chip {} MACing".format(ith_chip) )
            chip.output = np.matmul(chip.input, chip.weights)

    def two_way_lb_copy(self):
        """
        merge output from all chips into one
        :return: merged result
        """
        output = np.array([])
        for ith_chip, chip in enumerate(self.chips_list):
            output = np.concatenate((output, chip.output))
        return output

    def multichip_compile(self, nn_input):
        num_chips_list = self.multichip_parse()
        print(num_chips_list)
        layer_input = nn_input
        for ith_layer, num_chips in enumerate(num_chips_list):
            print("-------------------------  layer {}  -------------------------".format(ith_layer))
            self.init_chips(layer_num_chips=num_chips, layer_input=layer_input, layer_weights=self.weights[ith_layer], layer_bias=self.bias[ith_layer])
            self.layer_MAC()
            layer_input = self.two_way_lb_copy()
            self.chips_list = []


if __name__ == '__main__':
    (X_train, y_train), (X_test, y_test) = tf.keras.datasets.mnist.load_data()
    y_train = tf.keras.utils.to_categorical(y_train)
    y_test = tf.keras.utils.to_categorical(y_test)
    num_train_samples = y_train.shape[0]
    num_test_samples = y_test.shape[0]
    X_train = X_train.reshape(num_train_samples, 784)
    X_test = X_test.reshape(num_test_samples, 784)

    tierson_array = MultichipTierson()

    tierson_array.multichip_compile(nn_input=X_train[0])
    print("yes")