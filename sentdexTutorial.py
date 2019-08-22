import tensorflow as tf
import time
import numpy as np
import matplotlib.pyplot as plt
from tempfile import TemporaryFile
import sys
#from tensorflow.examples.tutorials.mnist import input_data

np.set_printoptions(threshold=sys.maxsize)

#mnist = input_data.read_data_sets("/tmp/data/", one_hot=True)
#print(mnist.train.images.shape)

(X_train, y_train), (X_test, y_test) = tf.keras.datasets.mnist.load_data()

y_train = tf.keras.utils.to_categorical(y_train)
y_test = tf.keras.utils.to_categorical(y_test)

X_train = X_train.astype('float32')
y_train = y_train.astype('float32')
X_test = X_test.astype('float32')
y_test = y_test.astype('float32')

num_train_samples = y_train.shape[0]
num_test_samples = y_test.shape[0]

X_train = X_train.reshape(num_train_samples, 784)
X_test = X_test.reshape(num_test_samples, 784)

n_node_hl1 = 512
n_node_hl2 = 128
n_node_hl3 = 64

n_classes = 10
batch_size = 100

x = tf.placeholder(tf.float32, [None, 784])
y = tf.placeholder(tf.float32)

batch_index = 0

def neural_network_model(data):
    hidden_1_layer = {'weights': tf.Variable(tf.random_normal([784, n_node_hl1]), name='l1_weights'),
                      'bias': tf.Variable(tf.random_normal([n_node_hl1]), name='l1_bias')}
    hidden_2_layer = {'weights': tf.Variable(tf.random_normal([n_node_hl1, n_node_hl2]), name='l2_weights'),
                      'bias': tf.Variable(tf.random_normal([n_node_hl2]), name='l2_bias')}
    hidden_3_layer = {'weights': tf.Variable(tf.random_normal([n_node_hl2, n_node_hl3]), name='l3_weights'),
                      'bias': tf.Variable(tf.random_normal([n_node_hl3]), name='l3_bias')}
    output_layer = {'weights': tf.Variable(tf.random_normal([n_node_hl3, n_classes]), name='out_weights'),
                    'bias': tf.Variable(tf.random_normal([n_classes]), name='out_bias')}

    l1 = tf.add(tf.matmul(data, hidden_1_layer['weights']), hidden_1_layer['bias'])
    l1 = tf.nn.sigmoid(l1)
    l2 = tf.add(tf.matmul(l1, hidden_2_layer['weights']), hidden_2_layer['bias'])
    l2 = tf.nn.sigmoid(l2)
    l3 = tf.add(tf.matmul(l2, hidden_3_layer['weights']), hidden_3_layer['bias'])
    l3 = tf.nn.sigmoid(l3)
    output = tf.add(tf.matmul(l3, output_layer['weights']), output_layer['bias'])

    return output

def next_batch(batch_size):
    global batch_index
    batch_index += batch_size
    if (batch_index <= num_train_samples):
        return X_train[batch_index-batch_size : batch_index], y_train[batch_index-batch_size : batch_index]
    else:
        return X_train[batch_index-batch_size : num_train_samples+1], y_train[batch_index-batch_size : num_train_samples+1]

def train_neural_network(x, y, lr):
    prediction = neural_network_model(x)
    cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits_v2(logits=prediction, labels=y))
    optimizer = tf.train.AdamOptimizer(learning_rate=lr).minimize(cost)
    accuracy_list = []

    hm_epochs = 100
    with tf.Session() as sess:
        sess.run(tf.global_variables_initializer())
        all_vars = tf.global_variables()

        def get_var(name):
            for i in range(len(all_vars)):
                if all_vars[i].name.startswith(name):
                    return all_vars[i]
            return None

        for epoch in range(hm_epochs):
            epoch_loss = 0
            for _ in range(int(num_train_samples/batch_size)):
                epoch_x, epoch_y = next_batch(batch_size)
                #print(epoch_x)
                _, c = sess.run([optimizer, cost], feed_dict={x: epoch_x, y: epoch_y})
                epoch_loss = c
            global batch_index
            batch_index = 0
            print("Epoch {} completed out of {}, loss: {}".format(epoch+1, hm_epochs, epoch_loss))
            # correct = tf.equal(tf.argmax(prediction, 1), tf.argmax(y, 1))
            # accuracy = tf.reduce_mean(tf.cast(correct, tf.float32))
            # accuracy = accuracy.eval({x: X_test, y: y_test})
            # print('Accuracy: ', accuracy)
            # accuracy_list.append(accuracy)

        # t = time.time()
        # correct = tf.equal(tf.argmax(prediction, 1), tf.argmax(y, 1))
        # accuracy = tf.reduce_mean(tf.cast(correct, tf.float32))
        # accuracy = accuracy.eval({x: X_test, y: y_test})
        # print('Accuracy: ', accuracy)
        # accuracy_list.append(accuracy)
        # print("time elapsed for testing: {}".format(time.time()-t))

        saver = tf.train.Saver()
        save_path = saver.save(sess, './saved_models/model.ckpt')
        print("Model saved in path: {}".format(save_path))

        # tf.compat.v1.saved_model.simple_save(
        #     session = sess,
        #     export_dir = './saved_models/model',
        #     inputs={"x": x},
        #     outputs={"y": y},
        #     legacy_init_op=None
        # )

        l1weights = get_var('l1_weights').eval()
        np.save("L1Weights", l1weights)
        l2weights = get_var('l2_weights').eval()
        np.save("L2Weights", l2weights)
        l3weights = get_var('l3_weights').eval()
        np.save("L3Weights", l3weights)
        outweights = get_var('out_weights').eval()
        np.save("outWeights", outweights)

        l1bias = get_var('l1_bias').eval()
        np.save("L1Bias", l1bias)
        l2bias = get_var('l2_bias').eval()
        np.save("L2Bias", l2bias)
        l3bias = get_var('l3_bias').eval()
        np.save("L3Bias", l3bias)
        outbias = get_var('out_bias').eval()
        np.save("outBias", outbias)

        # a = tf.global_variables
        # print(a)

    file_writer = tf.summary.FileWriter('./graph', sess.graph)
    return accuracy_list


t = time.time()

# learning_rate_list = [0.0001, 0.0005, 0.001, 0.005, 0.01, 0.05, 0.1]
learning_rate_list = [0.001, ]
for lr in learning_rate_list:
    accu_list = train_neural_network(x = x, y = y, lr = lr)
    # plt.plot(accu_list, label = 'lr={}'.format(lr))
plt.legend(loc=0)
plt.show()
print(time.time()-t)
