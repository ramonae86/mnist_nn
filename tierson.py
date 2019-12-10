

class Tierson:
    def __init__(self, num_input, num_output):
        self.num_input = num_input
        self.num_output = num_output
        self.weights = 0
        self.bias = 0


    def set_output(self, num_output):
        self.num_output = num_output


    def set_weights(self, weights):
        self.weights = weights


    def set_bias(self, bias):
        self.bias = bias


