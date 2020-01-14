import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
# from tensorflow.examples.tutorials.mnist import input_data

from LUT_NN import LUT
import sys

weight_scale = 30
x_scale = 5
sum_scale = weight_scale * x_scale
look_up_table = [-4590,-4394,-4207,-4028,-3856,-3692,-3535,-3384,-3240,-3102,-2969,-2843
,-2721,-2605,-2494,-2388,-2286,-2188,-2094,-2005,-1919,-1837,-1758,-1683
,-1611,-1542,-1475,-1412,-1351,-1293,-1238,-1185,-1134,-1085,-1038,-993
,-950,-909,-870,-832,-796,-762,-728,-697,-666,-637,-610,-583
,-558,-533,-510,-487,-466,-445,-426,-407,-389,-372,-355,-339
,-324,-309,-296,-282,-270,-257,-246,-234,-224,-213,-204,-194
,-185,-177,-168,-160,-153,-145,-139,-132,-126,-119,-114,-108
,-103,-97,-93,-88,-83,-79,-75,-71,-67,-63,-60,-57
,-54,-50,-48,-45,-42,-39,-37,-35,-32,-30,-28,-26
,-24,-22,-21,-19,-18,-16,-15,-13,-12,-10,-9,-8
,-7,-6,-5,-4,-3,-2,-1,0,1,2
,3,4,5,6,7,8,9,10,12,13,15,16
,18,19,21,22,24,26,28,30,32,35,37,39
,42,45,48,50,54,57,60,63,67,71,75,79
,83,88,93,97,103,108,114,119,126,132,139,145
,153,160,168,177,185,194,204,213,224,234,246,257
,270,282,296,309,324,339,355,372,389,407,426,445
,466,487,510,533,558,583,610,637,666,697,728,762
,796,832,870,909,950,993,1038,1085,1134,1185,1238,1293
,1351,1412,1475,1542,1611,1683,1758,1837,1919,2005,2094,2188
,2286,2388,2494,2605,2721,2843,2969,3102,3240,3384,3535,3692
,3856,4028,4207,4394,4590]

np.set_printoptions(threshold=sys.maxsize)

# look_up_table = [-5200,-4978,-4766,-4563,-4369,-4183,-4005,-3834,-3670,-3514,-3364,-3221
# ,-3083,-2952,-2826,-2705,-2589,-2479,-2373,-2271,-2174,-2081,-1992,-1907
# ,-1825,-1747,-1672,-1600,-1531,-1465,-1402,-1342,-1284,-1229,-1176,-1125
# ,-1077,-1030,-985,-943,-902,-863,-825,-789,-755,-722,-691,-661
# ,-632,-604,-577,-552,-528,-505,-482,-461,-441,-421,-402,-384
# ,-367,-351,-335,-320,-305,-292,-278,-266,-253,-242,-231,-220
# ,-210,-200,-191,-182,-173,-165,-157,-149,-142,-135,-129,-122
# ,-116,-110,-105,-100,-94,-90,-85,-80,-76,-72,-68,-64
# ,-61,-57,-54,-51,-48,-45,-42,-39,-37,-34,-32,-30
# ,-28,-26,-24,-22,-20,-18,-17,-15,-13,-12,-11,-9
# ,-8,-7,-6,-4,-3,-2,-1,0,1,2,3,4
# ,6,7,8,9,11,12,13,15,17,18,20,22
# ,24,26,28,30,32,34,37,39,42,45,48,51
# ,54,57,61,64,68,72,76,80,85,90,94,100
# ,105,110,116,122,129,135,142,149,157,165,173,182
# ,191,200,210,220,231,242,253,266,278,292,305,320
# ,335,351,367,384,402,421,441,461,482,505,528,552
# ,577,604,632,661,691,722,755,789,825,863,902,943
# ,985,1030,1077,1125,1176,1229,1284,1342,1402,1465,1531,1600
# ,1672,1747,1825,1907,1992,2081,2174,2271,2373,2479,2589,2705
# ,2826,2952,3083,3221,3364,3514,3670,3834,4005,4183,4369,4563
# ,4766,4978,5200]


def recursiveBinarySearch(aList, target, start, end):
    #aList = sorted(aList)

    if target >= aList[len(aList)-1]:
        return len(aList)
    if end-start+1 <= 0:
        return 0
    else:
        midpoint = start + (end - start) // 2
        if midpoint <= end and aList[midpoint-1] <= target < aList[midpoint]:
            return midpoint
        else:
            if target < aList[midpoint]:
                return recursiveBinarySearch(aList, target, start, midpoint-1)
            else:
                return recursiveBinarySearch(aList, target, midpoint+1, end)


def LUTsigmoid(x):

    if type(x).__name__ == "ndarray":
        result = []
        for x1 in x:
            result.append(recursiveBinarySearch(look_up_table, x1, 0, len(look_up_table))/255.0)
        return np.array(result)
    else:
        return recursiveBinarySearch(look_up_table, x, 0, len(look_up_table))/255.0


def threshold(x):
    super_threshold_indices = abs(x) < 10
    x[super_threshold_indices] = 0
    return x


if __name__ == "__main__":
    
    # mnist = input_data.read_data_sets("/tmp/data/", one_hot=True)
    (X_train, y_train), (X_test, y_test) = tf.keras.datasets.mnist.load_data()
    y_train = tf.keras.utils.to_categorical(y_train)
    y_test = tf.keras.utils.to_categorical(y_test)
    print(y_test.size)
    # print(mnist.test.images.shape)

    w1 = np.load("L1Weights.npy")
    w2 = np.load("L2Weights.npy")
    w3 = np.load("L3Weights.npy")
    w4 = np.load("outWeights.npy")
    b1 = np.load("L1Bias.npy")
    b2 = np.load("L2Bias.npy")
    b3 = np.load("L3Bias.npy")
    b4 = np.load("outBias.npy")


    w1 = (w1 * weight_scale)
    w2 = (w2 * weight_scale)
    w3 = (w3 * weight_scale)
    w4 = (w4 * weight_scale)
    b1 = (b1 * sum_scale)
    b2 = (b2 * sum_scale)
    b3 = (b3 * sum_scale)
    b4 = (b4 * sum_scale)


    ############################################
    # display weights bias and av distribution #
    ############################################
    fig, ax = plt.subplots(4, 3)
    ax[0, 0].hist(w1.flatten(), 80)
    ax[0, 1].hist(b1.flatten(), 80)
#    ax[0, 2].hist(y1.flatten(), 80)
    ax[1, 0].hist(w2.flatten(), 80)
    ax[1, 1].hist(b2.flatten(), 80)
#    ax[1, 2].hist(y2.flatten(), 80)
    ax[2, 0].hist(w3.flatten(), 80)
    ax[2, 1].hist(b3.flatten(), 80)
#    ax[2, 2].hist(y3.flatten(), 80)
    ax[3, 0].hist(w4.flatten(), 80)
    ax[3, 1].hist(b4.flatten(), 80)
#    ax[3, 2].hist(x4.flatten(), 80)
    fig.savefig("distributions.png")
    plt.show()
