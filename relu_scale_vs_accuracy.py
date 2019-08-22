from playWithSentdexWeightsBias import run
from matplotlib import pyplot as plt


if __name__=='__main__':
    scale_list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 25, 30, 40, 50, 60, 80, 100, 150, 200, 250, 300, 400, 500, 700, 1000, 2000]
    accuracy_list = [0]*len(scale_list)
    for idx, scale in enumerate(scale_list):
        accuracy_list[idx] = run(relu_scale=scale, AF='relu', plot=False)

    fig, ax = plt.subplots()
    ax.plot(scale_list, accuracy_list)
    ax.set_xticks(scale_list)
    plt.show()
