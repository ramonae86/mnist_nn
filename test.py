from __future__ import absolute_import, division, print_function, unicode_literals

import numpy as np
import time
import textwrap
import numbers

import tensorflow as tf
print("Num GPUs Available: ", len(tf.config.experimental.list_physical_devices('GPU')))
