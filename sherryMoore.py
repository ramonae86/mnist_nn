## sherry moore presentaiton(unfinished)

import tensorflow as tf
import numpy as np

import matplotlib.pyplot as plt

x_data = np.random.rand(100).astype(np.float32)
noise = np.random.normal(scale=0.01, size=len(x_data))
y_data = x_data * 0.1 + 0.3 + noise


W = tf.Variable(tf.random_uniform([1], 0.0, 1.0), name='weight')
b = tf.Variable(tf.zeros([1]), name='bias')
y = W * x_data + b

loss = tf.reduce_mean(tf.square(y-y_data))
optimizer = tf.train.GradientDescentOptimizer(learning_rate=0.5)
train = optimizer.minimize(loss)
init = tf.initialize_all_variables()

sess = tf.Session()
sess.run(init)
y_initial_values = sess.run(y)

print(y_initial_values)

for step in range(201):
    sess.run(train)
print(sess.run([W,b]))
