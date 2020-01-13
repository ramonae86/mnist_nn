

class Tierson:
    def __init__(self, num_input, num_output):
        self.num_input = num_input
        self.num_output = num_output
        self.weights = None
        self.bias = None
        self.input = None
        self.output = None

    def set_weights(self, weights):
        """
        it's better to have a separate method to set weights because there will probably SPI commands involved
        :param weights:
        :return:
        """
        self.weights = weights

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
