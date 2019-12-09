import numpy as np
import tensorflow as tf
import random
import matplotlib.pyplot as plt

tf.logging.set_verbosity(tf.logging.INFO)

def cnn_model_fn(features,labels,mode):
    # Correct dimensions
    input_layer = tf.reshape(features["x"], [-1,28,28,1])

    # Define Model
    conv1 = tf.layers.conv2d(
        inputs = input_layer,
        filters=32,
        kernel_size=[5,5],
        padding="same",
        activation=tf.nn.relu)
    pool1 = tf.layers.max_pooling2d(inputs=conv1, pool_size=[2,2],strides=2)
    conv2 = tf.layers.conv2d(
        inputs=pool1,
        filters=64,
        kernel_size=[5,5],
        padding="same",
        activation=tf.nn.relu)
    pool2 = tf.layers.max_pooling2d(inputs=conv2, pool_size=[2,2],strides=2)
    pool2_flat = tf.reshape(pool2, [-1,7*7*64])
    dense = tf.layers.dense(inputs=pool2_flat, units=1024,activation=tf.nn.relu)
    dropout = tf.layers.dropout(
        inputs=dense, rate=0.4, training=mode == tf.estimator.ModeKeys.TRAIN)
    logits = tf.layers.dense(inputs=dropout,units=10)
    # Predictions
    predictions = {
        "classes":tf.argmax(input=logits,axis=1),
        "probabilities": tf.nn.softmax(logits, name="softmax_tensor")
    }
    # Predict Mode
    if mode == tf.estimator.ModeKeys.PREDICT :
        return tf.estimator.EstimatorSpec(mode=mode, predictions=predictions)
    # Loss (eval and train both)
    # One hot labels ?
    # onehot_labels = tf.one_hot(indices=tf.cast(labels,tf.int32), depth=10)
    loss = tf.losses.sparse_softmax_cross_entropy(labels=labels, logits=logits) # onehot_labels=onehot_labels
    #Train
    if mode == tf.estimator.ModeKeys.TRAIN :
        optimizer = tf.train.GradientDescentOptimizer(learning_rate=0.01)
        train_op = optimizer.minimize(
            loss = loss,
            global_step = tf.train.get_global_step())
        return tf.estimator.EstimatorSpec(mode=mode, loss=loss, train_op=train_op)
    # Eval
    eval_metric_ops = {
        "accuracy" : tf.metrics.accuracy(
            labels=labels, predictions=predictions["classes"])}
    return tf.estimator.EstimatorSpec(mode=mode, loss=loss, eval_metric_ops=eval_metric_ops)

