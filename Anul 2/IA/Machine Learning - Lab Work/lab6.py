from colorama import init
from sklearn.neural_network import MLPClassifier # importul clasei
import numpy as np
import matplotlib.pyplot as plt
from sklearn.utils import shuffle


# mlp_classifier_model = MLPClassifier(hidden_layer_sizes=(100, ), activation='relu', solver='adam', alpha=0.0001, batch_size='auto', 
#                                      learning_rate='constant', learning_rate_init=0.001, power_t=0.5, 
#                                      max_iter=200, shuffle=True, random_state=None, tol=0.0001,
#                                      momentum=0.9, early_stopping=False, validation_fraction=0.1, n_iter_no_change=10)

# import torch
# x = torch.rand(5, 3)
# print(x)


def compute_y(x, W, bias):
    # dreapta de decizie
    # [x, y] * [W[0], W[1]] + b = 0
    return (-x * W[0] - bias) / (W[1] + 1e-10)
    
def plot_decision_boundary(X, y , W, b, current_x, current_y):
    x1 = -0.5
    y1 = compute_y(x1, W, b)
    x2 = 0.5
    y2 = compute_y(x2, W, b)
    # sterge continutul ferestrei
    plt.clf()
    # ploteaza multimea de antrenare
    color = 'r'
    if(current_y == -1):
        color = 'b'
    plt.ylim((-1, 2))
    plt.xlim((-1, 2))
    plt.plot(X[y == -1, 0], X[y == -1, 1], 'b+')
    plt.plot(X[y == 1, 0], X[y == 1, 1], 'r+')
    # ploteaza exemplul curent
    plt.plot(current_x[0], current_x[1], color+'s')
    # afisarea dreptei de decizie
    plt.plot([x1, x2] ,[y1, y2], 'black')
    plt.show(block=False)
    plt.pause(0.3)


def accuracy_score(y_true, y_pred):
    return np.size(np.where(y_true == y_pred)) / y_true.size


def Widrow_Hoff():
    # problema XOR
    training_data = np.array([[0, 0], [0, 1], [1, 0], [1, 1]])
    y_true = np.array([-1, 1, 1, -1])
    y_pred = np.zeros(y_true.size)
    # initializarea ponderilor
    W = np.zeros(len(training_data[0]))
    b = 0

    numar_epoci = 70
    learning_rate = 0.1
    for e in range(numar_epoci):
        shuffle(training_data, y_true, y_pred, random_state=0)
        
        for t in range(y_true.size):
            y_hat = np.dot(training_data[t], W) + b
            y_pred[t] = y_hat

            loss = (y_hat - y_true[t]) ** 2 / 2

            W = W - learning_rate * (y_hat - y_true[t]) * training_data[t]
            b = b - learning_rate * (y_hat - y_true[t])

            # afisam dreapta de decizie la fiecare pas

            plot_decision_boundary(training_data, y_true, W, b, training_data[t], y_true[t])
        
        if e % 10 == 0:
            acc = accuracy_score(y_true, y_pred)
            print(f'Acuratete dupa {e} epoci : {acc}')



'''
In cadrul laboratorului vom antrena o retea cu un strat ascuns cu
num_hidden_neurons neuroni si functia de activare tanh si un neuron pe stratul de
iesire cu functie de activare logistic (sigmoid) pentru rezolvarea problemei XOR.
Predictia retelei pentru un exemplu X este
𝑦ℎ𝑎𝑡 = 𝑠𝑖𝑔𝑚𝑜𝑖𝑑(𝑡𝑎𝑛ℎ( 𝑋 * 𝑊1 + 𝑏1) * 𝑊2 + 𝑏2)

Functia de pierdere:
𝑙𝑜𝑔𝑖𝑠𝑡𝑖𝑐_ 𝑙𝑜𝑠𝑠(𝑦ℎ𝑎𝑡, 𝑦) = − (𝑦 * 𝑙𝑜𝑔(𝑦ℎ𝑎𝑡) + (1 − 𝑦) * 𝑙𝑜𝑔(1 − 𝑦ℎ𝑎𝑡))
'''

# pasul 1 : initializarea ponderilor
def initializare (num_hidden_neurons, miu, sigma):
    W_1 = np.random.normal(miu, sigma, (2, num_hidden_neurons))
    # generam aleator matricea ponderilor stratului ascuns (2 -
    # dimensiunea datelor de intrare, num_hidden_neurons - numarul
    # neuronilor de pe stratul ascuns), cu media miu si deviatia standard sigma.
    b_1 = np.zeros(num_hidden_neurons) # initializam bias-ul cu 0
    W_2 = np.random.normal(miu, sigma, (num_hidden_neurons, 1))
    # generam aleator matricea ponderilor stratului de iesire
    # (num_hidden_neurons - numarul neuronilor de pe stratul ascuns, 1
    # - un neuron pe stratul de iesire), cu media miu si deviatia standard sigma.
    b_2 = np.zeros(1) # initializam bias-ul cu 0
    return W_1, b_1, W_2, b_2


def sigmoid(z):
    return 1/(1 + np.exp(-z))

def forward(X, W_1, b_1, W_2, b_2):
    # X - datele de intrare, W_1, b_1, W_2 si b_2 sunt ponderile retelei
    z_1 = np.dot(X, W_1) + b_1
    a_1 = np.tanh(z_1)
    z_2 = np.dot(a_1, W_2) + b_2
    a_2 = sigmoid(z_2)
    return z_1, a_1, z_2, a_2 # vom returna toate elementele calculate


# pasul 4: backpropagation
def backward(a_1, a_2, z_1, W_2, X, Y, num_samples):
    dz_2 = a_2 - Y # derivata functiei de pierdere (logistic loss) in functie de z
    dw_2 = (np.dot(a_1.T, dz_2)) / num_samples # der(L/w_2) = der(L/z_2) * der(dz_2/w_2) = dz_2 * der((a_1 * W_1 + b_2)/ W_2)
    db_2 = np.sum(dz_2, axis = 0) / num_samples # der(L/b_2) = der(L/z_2) * der(z_2/b_2) = dz_2 * der((a_1 * W_2 + b_2)/ b_2)

    # primul strat
    da_1 = np.dot(dz_2, W_2.T)
    # der(L/a_1) = der(L/z_2) * der(z_2/a_1) = dz_2 * der((a_1 * W_2 + b_2)/ a_1)
    dz_1 = np.dot(da_1, (1- np.tanh(z_1) ** 2).T)
    # der(L/z_1) = der(L/a_1) * der(a_1/z1) = da_1 .* der((tanh(z_1))/ z_1)

    dw_1 = np.dot(X.T, dz_1) / num_samples
    # der(L/w_1) = der(L/z_1) * der(z_1/w_1) = dz_1 * der((X * W_1 + b_1)/ W_1)
    db_1 = np.sum(dz_1, axis = 0) / num_samples
    # der(L/b_1) = der(L/z_1) * der(z_1/b_1) = dz_1 * der((X * W_1 + b_1)/ b_1)
    return dw_1, db_1, dw_2, db_2


lr = 0.5
num_epochs = 50
mean, stddev = 0, 1
num_hidden_neurons = 5


def antrenare_retea():
    training_data = np.array([[0, 0], [0, 1], [1, 0], [1, 1]])
    y_true = np.array([0, 1, 1, 0]).reshape(4, 1)
    # y_pred = np.zeros(y_true.size)
    W_1, b_1, W_2, b_2 = initializare(num_hidden_neurons, mean, stddev)
    for e in range(num_epochs):
        shuffle(training_data, y_true, random_state=0)
        z_1, a_1, z_2, a_2 = forward(training_data, W_1, b_1, W_2, b_2)
        # a_2 = y_pred

        # pasul 3 - calculam loss-ul si acuratetea
        loss = (np.dot(-y_true.T , np.log(a_2)) - np.dot((1 - y_true.T), np.log(1 - a_2))).mean()
        predictions = (a_2 > 0.5).astype(int)
        accuracy = (predictions == y_true).mean()
        print(f'Epoca = {e} : loss {loss}, acc {accuracy}')

        # pasul 4 - backpropagation

        dw_1, db_1, dw_2, db_2 = backward(a_1, a_2, z_1, W_2, training_data, y_true, y_true.size)

        # pasul 5 : actualizarea ponderilor
        W_1 = W_1 -  lr * dw_1 # lr - rata de invatare (learning rate)
        b_1 = b_1 -  lr * db_1
        W_2 = W_2 -  lr * dw_2
        b_2 = b_2 -  lr * db_2
        plot_decision(training_data, W_1, W_2, b_1, b_2)


def plot_decision(X_, W_1, W_2, b_1, b_2):
    # sterge continutul ferestrei
    plt.clf()
    # ploteaza multimea de antrenare
    plt.ylim((-0.5, 1.5))
    plt.xlim((-0.5, 1.5))
    xx = np.random.normal(0, 1, (100000))
    yy = np.random.normal(0, 1, (100000))
    X = np.array([xx, yy]).transpose()
    X = np.concatenate((X, X_))
    _, _, _, output = forward(X, W_1, b_1, W_2, b_2)
    y = np.squeeze(np.round(output))
    plt.plot(X[y == 0, 0], X[y == 0, 1], 'b+')
    plt.plot(X[y == 1, 0], X[y == 1, 1], 'r+')
    plt.show(block=False)
    plt.pause(0.1)


antrenare_retea()
