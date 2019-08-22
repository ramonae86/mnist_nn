import matplotlib.pyplot as plt
import tensorflow as tf
import numpy as np
from sklearn.metrics import confusion_matrix

from tensorflow.examples.tutorials.mnist import input_data

data = input_data.read_data_sets("/tmp/data/", one_hot=True)
print(type(data.train))

# # The images are stored in one-dimensional arrays of this length.
# img_size_flat = data.img_size_flat
#
# # Tuple with height and width of images used to reshape arrays.
# img_shape = data.img_shape
#
# # Number of classes, one class for each of 10 digits.
# num_classes = data.num_classes