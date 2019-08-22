
import numpy as np
def LUT(x, TYPE, xmax):
    def sigmoid(x):
        return 1/(1 + np.exp(-x)) 
    def tanh(x):
        return np.tanh(x)
    t = np.linspace(-1,1,25600)
    Q = 7
    mu = 255
    S = lambda x: (np.sign(x))*(np.log10(1 + mu * abs(x)))/np.log10(1+mu)
    Sinv  = lambda x: (np.sign(x))*(((1 + mu)**abs(x)-1)/mu)
    Qu = np.round_(t*(2**Q))/2**Q
    Qnu =np.sign(t)*Sinv(np.round_(S(abs(t))*(2**Q))/2**Q)
    z = np.unique(Qnu*xmax)
    if TYPE == 'SIGF':
        AF = np.round_(sigmoid(z)*256)
    elif TYPE == 'HYPF': 
        AF = np.round_(tanh(z)*128)
    else:
        AF = np.round_(sigmoid(z)*256)
    if x < np.round_(z[0]*256):
        f = AF[0]
    elif x >= np.round_(z[255]*256):
        f = AF[255]
    else:
        for i in range(1, 256):
            if np.round_(z[i-1]*256) <= x and x < np.round_(z[i]*256):
                f = AF[i]
    return z

def main():
    table = LUT(1, 'SIGF', 5)
    print(table)

if __name__=="__main__":
    main()
