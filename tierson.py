from compiler import line_to_hex, biases_to_hex
import numpy as np

weight_scale = 1
x_scale = 1
bias_scale = weight_scale * x_scale
num_bias_bytes = 4

class Tierson:
    def __init__(self, chip_index):
        self.num_input = None
        self.num_output = None
        self.weights = None
        self.bias = None
        self.input = None
        self.output = None
        self.chip_index = chip_index
        self.weight_filename = "CHIP{}_WEIGHTS.list".format(chip_index)
        self.weight_index = 0

    def set_weights(self, weights):
        """
        it's better to have a separate method to set weights because there will probably SPI commands involved
        :param weights:
        :return:
        """
        self.weights = weights
        self.num_input = self.weights.shape[0]
        self.num_output = self.weights.shape[1]

    def set_bias(self, bias):
        """
        it's better to have a separate method to set bias because there will probably SPI commands involved
        :param bias:
        :return:
        """
        self.bias = bias

    def set_input(self, input):
        """
        it's better to have a separate input to set weights because there will probably SPI commands involved
        :param input:
        :return:
        """
        self.input = input

    def create_weights_file(self, ith_layer):
        """
        create files to store weights for each chip respectively
        :return:
        """

        array_data = []
        num_chunks = self.num_output // 4
        num_leftover = self.num_output % 4
        print(num_chunks)
        print(num_leftover)

        for ith_chunk in range(num_chunks):
            for nth_input_node in range(self.num_input):
                # every 4 weights constitute one line
                tmp_weight = self.weights[nth_input_node][ith_chunk * 4: ith_chunk * 4 + 4]
                # print(tmp_weight)
                array_data.append(line_to_hex(line=tmp_weight, scale=weight_scale, signed=True))
            # every bias is 32-bit
            tmp_bias = self.bias[ith_chunk * 4: ith_chunk * 4 + 4]
            # print(tmp_bias)
            array_data += biases_to_hex(biases=tmp_bias, scale=bias_scale, num_bytes=num_bias_bytes)
        if num_leftover > 0:  # in case number of neurons is not multiple of 4 in output layer
            for nth_input_node in range(self.num_input):
                # leftover weights appended with padding 0s to make 32-bit line
                tmp_weight = np.append(self.weights[nth_input_node][-num_leftover:], [0] * (4 - num_leftover))
                # print(tmp_weight)
                array_data.append(line_to_hex(line=tmp_weight, scale=weight_scale, signed=True))
                # every bias is 32-bit
            tmp_bias = self.bias[-num_leftover:]
            # print(tmp_bias)
            array_data += biases_to_hex(biases=tmp_bias, scale=bias_scale, num_bytes=num_bias_bytes)
        print(array_data)
        with open(self.weight_filename, 'a') as data_file:
            i = 0
            data_file.write('// ******************** layer {} weights and biases ********************'.format(ith_layer))
            data_file.write('\n')

            for line in array_data:
                data_file.write(line)
                if i % 2 == 0:
                    data_file.write(' ')
                else:
                    data_file.write('\n')
                i += 1
            if i % 2 == 1:
                data_file.write('\n')
