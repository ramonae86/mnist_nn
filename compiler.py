import numpy as np
import tensorflow as tf
# from util import *

# tf.reset_default_graph()

# Create some variables.
# variable name and shape has to be known beforehand
# v1 = tf.get_variable("l1_weights", shape=[768, 512])
# v2 = tf.get_variable("l2_weights", shape=[512, 128])

# Add ops to save and restore all the variables.
# saver = tf.train.Saver()

# Later, launch the model, use the saver to restore variables from disk, and
# do some work with the model.


def sigmoid(x):
    y = 1/(1+np.exp(-x))
    return y.round(decimals=2)


def extract_weight_bias_from_model():
    """
    read weights and bias from files

    :return: two matrix, one for weights and one for bias
    """
    weights = []
    bias = []
    with tf.Session() as sess:
        saver = tf.train.import_meta_graph('./saved_models/model.ckpt.meta')
        saver.restore(sess, tf.train.latest_checkpoint('./saved_models/'))
        weights.append(sess.run('l1_weights:0'))
        bias.append(sess.run('l1_bias:0'))
        weights.append(sess.run('l2_weights:0'))
        bias.append(sess.run('l2_bias:0'))
        weights.append(sess.run('l3_weights:0'))
        bias.append(sess.run('l3_bias:0'))
        weights.append(sess.run('out_weights:0'))
        bias.append(sess.run('out_bias:0'))
    return weights, bias


def extract_weight_bias_from_file():
    """
    read weights and bias from files

    :return: two matrix, one for weights and one for bias
    """
    weights = []
    bias = []
    weights.append(np.load("L1Weights.npy"))
    weights.append(np.load("L2Weights.npy"))
    weights.append(np.load("L3Weights.npy"))
    weights.append(np.load("outWeights.npy"))
    bias.append(np.load("L1Bias.npy"))
    bias.append(np.load("L2Bias.npy"))
    bias.append(np.load("L3Bias.npy"))
    bias.append(np.load("outBias.npy"))
    return weights, bias


def nn_compile_logic(nn_input):
    """
    running all MAC operations on pure software level

    :param nn_input: input layer matrix
    :return: output layer matrix
    """
    weights, bias = extract_weight_bias_from_model()

    # load input to layer buffer
    input_layer = nn_input

    if len(weights) == len(bias):
        # between each pair of layers
        for nth_layer in range(len(weights)):
            output_layer = np.zeros(len(bias[nth_layer]))
            for nth_output_node in range(weights[nth_layer].shape[1]):
                mac = 0
                for nth_input_node in range(weights[nth_layer].shape[0]):
                    mac += input_layer[nth_input_node] * weights[nth_layer][nth_input_node][nth_output_node]
                mac += bias[nth_layer][nth_output_node]
                mac = sigmoid(mac)
                output_layer[nth_output_node] = mac
            input_layer = output_layer
        return output_layer
    else:
        print("weights and bias length don't match!")
        print("weights length: ", len(weights))
        print("bias length: ", len(bias))


def line_to_binary(line, scale, signed):
    """
    Convert a line of weights or bias to 2's complement,

    :param line: input data
    :param scale: scale for normalization
    :param signed: True/False, whether line is signed calue
    :return: 32 bit 2's complement for weights/bias in string format
    """
    length = len(line)
    if length == 1 or length == 2 or length == 4:
        result = ''
        if signed:
            for item in line:
                # binary = bin(int(item * scale) & 0xFF)
                if item * scale > 127:
                    entry = 127
                elif item * scale < -128:
                    entry = -128
                else:
                    entry = item * scale
                binary = int(entry) & 0xFF
                result += format(binary, '0{}b'.format(32 // length))
            return result
        else:
            for item in line:
                # binary = bin(int(item * scale) & 0xFF)
                if item * scale > 255:
                    entry = 255
                elif item * scale < 0:
                    entry = 0
                else:
                    entry = item * scale
                binary = int(entry) & 0xFF
                result += format(binary, '0{}b'.format(32 // length))
            return result
    else:
        print("One line can only have 1, 2 or 4 entries!!!")
        print("Terminated")
        exit()


def biases_to_binary(biases, scale, num_bytes = 4):
    """
    convert an array of bias to an array of binary number, interleaved

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
    # print(bin_array)
    # interleave array
    interleaved_array = []
    for i in range(num_bytes):
        interleaved_bias = bin_array[0][32 - 8*i - 8 :32 - 8*i] + bin_array[1][32 - 8*i - 8 :32 - 8*i] + bin_array[2][32 - 8*i - 8 :32 - 8*i] + bin_array[3][32 - 8*i - 8 :32 - 8*i]
        interleaved_array.append(interleaved_bias)
    return interleaved_array


def line_to_hex(line, scale, signed):
    """
    Convert a line of weights or bias to four 2-digit hex number

    :param line: input data
    :param scale: scale for normalization
    :param signed: True/False, whether line is signed calue
    :return: four 2-digit hex number for weights/bias in string format
    """
    length = len(line)
    if length == 1 or length == 2 or length == 4:
        result = ''
        if signed:
            for item in line:
                # manage out of bound issue
                if length == 4:
                    if item * scale > 2 ** 7:
                        entry = 2 ** 7
                    elif item * scale < -2 ** 8:
                        entry = -2 ** 8
                    else:
                        entry = item * scale
                    binary = int(entry) & 0xFF
                elif length == 2:
                    if item * scale > 2 ** 15 - 1:
                        entry = 2 ** 15 - 1
                    elif item * scale < -2 ** 16:
                        entry = -2 ** 16
                    else:
                        entry = item * scale
                    binary = int(entry) & 0xFFFF
                else:
                    if item * scale > 2 ** 31 - 1:
                        entry = 2 ** 31 - 1
                    elif item * scale < -2 ** 32:
                        entry = -2 ** 32
                    else:
                        entry = item * scale
                    binary = int(entry) & 0xFFFFFFFF
                result += format(binary, '0{}x'.format(8 // length)).upper()
        else:
            for item in line:
                # manage out of bound issue
                if length == 4:
                    if item * scale > 2 ** 8 - 1:
                        entry = 2 ** 8 - 1
                    elif item * scale < 0:
                        entry = 0
                    else:
                        entry = item * scale
                    binary = int(entry) & 0xFF
                elif length == 2:
                    if item * scale > 2 ** 16 - 1:
                        entry = 2 ** 16 - 1
                    elif item * scale < 0:
                        entry = 0
                    else:
                        entry = item * scale
                    binary = int(entry) & 0xFFFF
                else:
                    if item * scale > 2 ** 32 - 1:
                        entry = 2 ** 32 - 1
                    elif item * scale < 0:
                        entry = 0
                    else:
                        entry = item * scale
                    binary = int(entry) & 0xFFFFFFFF
                result += format(binary, '0{}x'.format(8 // length)).upper()
        # convert to four 2-digit hex number separated by spaces
        result = result[0:2] + ' ' + result[2:4] + ' ' + result[4:6] + ' ' + result[6:8]
        return result
    else:
        print("One line can only have 1, 2 or 4 entries!!!")
        print("Terminated")
        exit()


def biases_to_hex(biases, scale, num_bytes=4):
    """
    convert an array of bias to an array of hex number, interleaved

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
    # print(hex_array)
    # interleave array
    interleaved_array = []
    for i in range(num_bytes):
        interleaved_bias = hex_array[0][8 - 2*i - 2 :8 - 2*i] + hex_array[1][8 - 2*i - 2 :8 - 2*i] + hex_array[2][8 - 2*i - 2 :8 - 2*i] + hex_array[3][8 - 2*i - 2 :8 - 2*i]
        interleaved_array.append(interleaved_bias)
    for i in range(len(interleaved_array)):
        interleaved_array[i] = interleaved_array[i][0:2] + ' ' + interleaved_array[i][2:4] + ' ' + interleaved_array[i][4:6] + ' ' + interleaved_array[i][6:8]
    return interleaved_array


def nn_compile_with_inference(input_layer):
    """Function Description:
    Suppose SPI block and inference block work, meaning we only need to write weights, bias and layer descriptions into memory array in the correct order.
    This is only for fully connected layer, for now.

    :return:
    array_data: to be stored in memory array will be called by another
    """
    weights, bias = extract_weight_bias_from_model()
    weight_scale = 30
    x_scale = 5
    bias_scale = weight_scale * x_scale
    num_bias_bytes = 2

    # flatten weights and load weights into memory array
    array_data = []

    if len(weights) == len(bias):
        # between each pair of layers
        for nth_layer in range(len(weights)):
            # layer descriptor
            # 31: layer mode
            # 30:29: bias count
            # 28: layer continue
            # 27: force address
            # 25:16: address offset
            if nth_layer == len(weights) - 1:
                array_data.append('00000000000000000000000000001001')
            else:
                array_data.append('00000000000000000000000000000001')

            num_in_neu = weights[nth_layer].shape[0]
            num_out_neu = weights[nth_layer].shape[1]
            num_chunks = num_out_neu//4
            num_leftover = num_out_neu % 4
            print(num_chunks)
            print(num_leftover)

            # weights and bias data
            for ith_chunk in range(num_chunks):
                for nth_input_node in range(num_in_neu):
                    # every 4 weights constitute one line
                    tmp_weight = weights[nth_layer][nth_input_node][ith_chunk * 4: ith_chunk * 4 + 4]
                    array_data.append(line_to_binary(line=tmp_weight, scale=weight_scale, signed=True))
                # every bias is 32-bit
                tmp_bias = bias[nth_layer][ith_chunk * 4 : ith_chunk * 4 + 4]
                array_data += biases_to_binary(biases=tmp_bias, scale=bias_scale, num_bytes=num_bias_bytes)

            if num_leftover > 0: # in case number of neurons is not multiple of 4 in output layer
                for nth_input_node in range(num_in_neu):
                    # leftover weights appended with padding 0s to make 32-bit line
                    tmp_weight = np.append(weights[nth_layer][nth_input_node][-num_leftover:], [0]*(4-num_leftover))
                    array_data.append(line_to_binary(line=tmp_weight, scale=weight_scale, signed=True))
                # every bias is 32-bit
                tmp_bias = bias[nth_layer][-num_leftover:]
                array_data += biases_to_binary(biases=tmp_bias, scale=bias_scale, num_bytes=num_bias_bytes)
    else:
        print("weights and bias length don't match!")
        print("weights length: ", len(weights))
        print("bias length: ", len(bias))
    with open('data_list.txt', 'w') as f:
        for item in array_data:
            print(item, file=f)


def nn_compile_with_spi(input_layer):
    """
    given a neural network, generate a testbench.v file that simulate the module with SPI command

    :return:
    """
    weights, bias = extract_weight_bias_from_file()
    weight_scale = 30
    x_scale = 5
    bias_scale = weight_scale * x_scale
    num_bias_bytes = 2

    array_data = []

    for nth_layer in range(len(weights)):
        num_in_neu = weights[nth_layer].shape[0]
        num_out_neu = weights[nth_layer].shape[1]
        num_chunks = num_out_neu // 4
        num_leftover = num_out_neu % 4
        print(num_chunks)
        print(num_leftover)

        # weights and bias data
        for ith_chunk in range(num_chunks):
            for nth_input_node in range(num_in_neu):
                # every 4 weights constitute one line
                tmp_weight = weights[nth_layer][nth_input_node][ith_chunk * 4: ith_chunk * 4 + 4]
                array_data.append(line_to_hex(line=tmp_weight, scale=weight_scale, signed=True))
            # every bias is 32-bit
            tmp_bias = bias[nth_layer][ith_chunk * 4: ith_chunk * 4 + 4]
            array_data += biases_to_hex(biases=tmp_bias, scale=bias_scale, num_bytes=num_bias_bytes)

        if num_leftover > 0:  # in case number of neurons is not multiple of 4 in output layer
            for nth_input_node in range(num_in_neu):
                # leftover weights appended with padding 0s to make 32-bit line
                tmp_weight = np.append(weights[nth_layer][nth_input_node][-num_leftover:], [0] * (4 - num_leftover))
                array_data.append(line_to_hex(line=tmp_weight, scale=weight_scale, signed=True))
                # every bias is 32-bit
                tmp_bias = bias[nth_layer][-num_leftover:]
                array_data += biases_to_hex(biases=tmp_bias, scale=bias_scale, num_bytes=num_bias_bytes)

    # print(array_data)
    with open('PI_BLOCK_512.list', 'w') as data_file:
        i = 0
        for neuron in input_layer:
            data_file.write(line_to_hex([neuron], scale=5, signed=False))
            if i % 2 == 0:
                data_file.write(' ')
            else:
                data_file.write('\n')
            i += 1

        for line in array_data:
            data_file.write(line)
            if i % 2 == 0:
                data_file.write(' ')
            else:
                data_file.write('\n')
            i += 1

    with open('testbench.vh', 'w') as testbench:
        testbench.write('`include "./banners/+runP_start.vh"\n')
        testbench.write('`include "./banners/+test1.vh"\n')
        testbench.write('TASK_RSTEN;\n')
        testbench.write('TASK_RST;\n')

        memory_start_address = 0

        lb_start_address = 0

        testbench.write('TASK_INIT_WRITE_PI;\n')
        for i in range(len(input_layer)):
            testbench.write("TASK_LBWR(16'h{});\n".format(format(lb_start_address+i, '04x').upper()))

        for i in range(len(array_data)):
            testbench.write("TASK_PP(16'h{},4);\n".format(format(memory_start_address + i, '04x').upper()))

        array_address = 0
        for nth_layer in range(len(weights)):
            if nth_layer % 2 == 1:
                lb_input_start_address = 512
                lb_output_start_address = 0
            else:
                lb_input_start_address = 0
                lb_output_start_address = 512
            num_in_neu = weights[nth_layer].shape[0]
            num_out_neu = weights[nth_layer].shape[1]
            num_chunks = num_out_neu // 4
            num_leftover = num_out_neu % 4
            lb_output_current_address = lb_output_start_address

            for ith_chunk in range(num_chunks):
                lb_input_current_address = lb_input_start_address
                for nth_input_node in range(num_in_neu):
                    testbench.write("TASK_MACCYC(0,32'h{}{});\n".format(format(array_address, '04x').upper(), format(lb_input_current_address, '04x').upper()))
                    array_address += 1
                    lb_input_current_address += 1
                testbench.write("TASK_BIASBUF({},16'h{});\n".format(num_bias_bytes, format(array_address, '04x').upper()))
                array_address += num_bias_bytes
                for i in range(4):
                    testbench.write("TASK_NEURONACT(32'h{}{});\n".format(format(i+1, '04x').upper(), format(lb_output_current_address, '04x').upper()))
                    lb_output_current_address += 1

            if num_leftover > 0:
                lb_input_current_address = lb_input_start_address
                for nth_input_node in range(num_in_neu):
                    testbench.write("TASK_MACCYC(0,32'h{}{});\n".format(format(array_address, '04x').upper(), format(lb_input_current_address, '04x').upper()))
                    array_address += 1
                    lb_input_current_address += 1
                testbench.write("TASK_BIASBUF({},16'h{});\n".format(num_bias_bytes, format(array_address, '04x').upper()))
                array_address += num_bias_bytes
                for i in range(num_leftover):
                    testbench.write("TASK_NEURONACT(32'h{}{});\n".format(format(i+1, '04x').upper(), format(lb_output_current_address, '04x').upper()))
                    lb_output_current_address += 1


if __name__ == '__main__':
    (X_train, y_train), (X_test, y_test) = tf.keras.datasets.mnist.load_data()

    y_train = tf.keras.utils.to_categorical(y_train)
    y_test = tf.keras.utils.to_categorical(y_test)

    num_train_samples = y_train.shape[0]
    num_test_samples = y_test.shape[0]
    X_train = X_train.reshape(num_train_samples, 784)
    X_test = X_test.reshape(num_test_samples, 784)

    for i in range(1):
        # print(X_train[i])
        predict = nn_compile_with_spi(X_train[i])
#        if np.argmax(predict) == np.argmax(y_train[i]):
#            print("correct")
#        else:
#            print("incorrect")
