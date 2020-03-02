import numpy as np
import math
import tensorflow as tf
from compiler import extract_weight_bias_from_file, extract_weight_bias_from_model, line_to_hex, biases_to_hex, LUTsigmoid
from tierson import *
import os
import glob


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
        self.LB_SIZE = 18
        self.weights, self.bias = extract_weight_bias_from_file()
        self.array_address = None

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
        """
        initialize chips in a layer

        :param layer_num_chips:
        :param layer_input:
        :param layer_weights:
        :param layer_bias:
        :return:
        """
        # num_input = layer_weights.shape[0]
        num_output = layer_weights.shape[1]
        split_sizes = near_even_divide(num_output, layer_num_chips)
        chips_one_layer = []
        for i in range(layer_num_chips):
            # input is duplicated across chips
            new_chip = Tierson(chip_index=i)
            new_chip.set_input(layer_input)

            # weights and bias
            chip_weights = layer_weights[:, sum(split_sizes[:i]):sum(split_sizes[:i])+split_sizes[i]]
            chip_bias = layer_bias[sum(split_sizes[:i]):sum(split_sizes[:i])+split_sizes[i]]
            new_chip.set_weights(chip_weights)
            new_chip.set_bias(chip_bias)

            chips_one_layer.append(new_chip)
        return chips_one_layer

    def layer_MAC(self, ith_layer):
        """
        MAC for a single layer
        :param ith_layer:
        :return:
        """
        for ith_chip, chip in enumerate(self.chips_list[ith_layer]):
            with open('testbench_mc.v', 'a') as testbench:
                testbench.write('chip_active = {};\n'.format(ith_chip))
                testbench.write("TASK_ACCRST;\n")
                num_chunks = chip.num_output // 4
                num_leftover = chip.num_output % 4
                if ith_layer % 2 == 1:
                    lb_input_start_address = lb_output_start_address
                    lb_output_start_address = 0
                else:
                    lb_input_start_address = 0
                    lb_output_start_address = 1024 - chip.num_output
                lb_output_current_address = lb_output_start_address

                for ith_chunk in range(num_chunks):
                    lb_input_current_address = lb_input_start_address
                    for nth_input_node in range(chip.num_input):
                        testbench.write("TASK_MACCYC(0,32'h{}{});\n".format(format(self.array_address[ith_chip], '04x').upper(), format(lb_input_current_address, '04x').upper()))
                        self.array_address[ith_chip] += 1
                        lb_input_current_address += 1
                    testbench.write("TASK_BIASBUF({},16'h{});\n".format(num_bias_bytes, format(self.array_address[ith_chip], '04x').upper()))
                    self.array_address[ith_chip] += num_bias_bytes
                    for i in range(4):
                        testbench.write("TASK_NEURONACT(32'h{}{});\n".format(format(i, '04x').upper(), format(lb_output_current_address, '04x').upper()))
                        lb_output_current_address += 1
                    testbench.write("TASK_ACCRST;\n")

    def two_way_lb_copy(self):
        """
        merge output from all chips into one
        :return: merged result
        """
        output = np.array([])
        for ith_chip, chip in enumerate(self.chips_list):
            output = np.concatenate((output, chip.output), axis=0).astype(int)
        return output

    def multichip_compile(self, nn_input):
        num_chips_list = self.multichip_parse()
        print(num_chips_list)
        layer_input = nn_input

        # create a file to store the neural network input, sequential it will be updated during Verilog simulation
        with open('CHIPS_INPUT.list', 'w') as data_file:
            i = 0
            data_file.write('// neuron values to be stored in layer buffer')
            data_file.write('\n')
            for neuron in nn_input:
                # data_file.write(line_to_hex([neuron], scale=x_scale, signed=False))
                data_file.write(format(neuron * x_scale, '02x').upper())
                if i % 8 == 7:
                    data_file.write('\n')
                else:
                    data_file.write(' ')
                i += 1

        # create testbench
        with open('testbench_mc.v', 'w') as testbench:

            testbench.write('TASK_RSTEN;\n')
            testbench.write('TASK_RST;\n')
            testbench.write('// write input layer into LB\n\n')

            lb_start_address = 0

            for ith_chip in range(max(num_chips_list)):
                testbench.write('TASK_INIT_WRITE_MULTICHIP_INPUT;\n')
                testbench.write('index_data_array = 0;\n')
                testbench.write('chip_active = {};\n'.format(ith_chip))
                for i in range(len(nn_input)):
                    testbench.write("TASK_LBWR(16'h{});\n".format(format(lb_start_address + i, '04x').upper()))
                testbench.write('\n')

        # delete existing chip weight files
        file_list = glob.glob('./CHIP*_WEIGHTS.list')
        for file_path in file_list:
            try:
                os.remove(file_path)
            except:
                print("Error while deleting file : ", file_path)

        # for every layer, initialize chips(assign weights and bias accordingly)
        for ith_layer, layer_num_chips in enumerate(num_chips_list):
            print("-------------------------  layer {}  -------------------------".format(ith_layer))
            self.chips_list.append(self.init_chips(layer_num_chips=layer_num_chips, layer_input=layer_input, layer_weights=self.weights[ith_layer], layer_bias=self.bias[ith_layer]))

        # for each chip save weight data to file
        for ith_layer, chips_one_layer in enumerate(self.chips_list):
            for chip in chips_one_layer:
                chip.create_weights_file(ith_layer)

        # generate testbench commands to write weights to chip
        with open('testbench_mc.v', 'a') as testbench:
            memory_start_address = 0
            for ith_chip in range(max(num_chips_list)):
                index = 0
                testbench.write('index_data_array = 0;\n')
                for ith_layer in range(len(self.chips_list)):
                    if ith_chip < len(self.chips_list[ith_layer]):
                        testbench.write('TASK_INIT_WRITE_MULTICHIP_WEIGHTS({});\n'.format(self.chips_list[ith_layer][ith_chip].chip_index))
                        testbench.write('chip_active = {};\n'.format(self.chips_list[ith_layer][ith_chip].chip_index))
                        testbench.write('// weights for chip {} on layer {}\n'.format(ith_chip, ith_layer))
                        for i in range(self.chips_list[ith_layer][ith_chip].weights.size):
                            testbench.write("TASK_PP(16'h{},4);\n".format(format(memory_start_address + index, '04x').upper()))
                            index += 1
                        testbench.write('\n')

        # initialize array address index tracker for each chip
        self.array_address = [0] * max(num_chips_list)

        # MAC and merge input, layer by layer
        for ith_layer, chips_one_layer in enumerate(self.chips_list):
            with open('testbench_mc.v', 'a') as testbench:
                testbench.write('\n// layer {}\n'.format(ith_layer))

            self.layer_MAC(ith_layer)
            # self.layer_MAC()
            # layer_input = self.two_way_lb_copy()





if __name__ == '__main__':
    (X_train, y_train), (X_test, y_test) = tf.keras.datasets.mnist.load_data()
    y_train = tf.keras.utils.to_categorical(y_train)
    y_test = tf.keras.utils.to_categorical(y_test)
    num_train_samples = y_train.shape[0]
    num_test_samples = y_test.shape[0]
    X_train = X_train.reshape(num_train_samples, 784)
    X_test = X_test.reshape(num_test_samples, 784)

    tierson_array = MultichipTierson()

    # tierson_array.multichip_compile(nn_input=X_train[0])
    neu_num_in = 10
    neu_num_1 = 15
    neu_num_2 = 8
    neu_num_3 = 12
    neu_num_4 = 4

    np.random.seed(10)
    np.save("L1Weights", np.random.randint(-4, 4, size=(neu_num_in, neu_num_1)))
    np.save("L2Weights", np.random.randint(-4, 4, size=(neu_num_1, neu_num_2)))
    np.save("L3Weights", np.random.randint(-4, 4, size=(neu_num_2, neu_num_3)))
    np.save("outWeights", np.random.randint(-4, 4, size=(neu_num_3, neu_num_4)))
    np.save("L1Bias", np.random.randint(-4, 4, size=neu_num_1))
    np.save("L2Bias", np.random.randint(-4, 4, size=neu_num_2))
    np.save("L3Bias", np.random.randint(-4, 4, size=neu_num_3))
    np.save("outBias", np.random.randint(-4, 4, size=neu_num_4))
    layer_in = np.random.randint(0, 4, size=neu_num_in)

    tierson_array.multichip_compile(nn_input=layer_in)
