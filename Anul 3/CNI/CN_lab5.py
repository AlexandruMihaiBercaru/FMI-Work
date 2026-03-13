'''
    Calcul Numeric - Laboratorul 5
    Bercaru Alexandru-Mihai
    Grupa 331
'''

import numpy as np
import pandas as pd
import random
from sklearn import svm
from sklearn.decomposition import PCA
from sklearn.inspection import DecisionBoundaryDisplay # pentru plotare
import matplotlib.pyplot as plt

dataset = pd.read_csv('https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data')

data = dataset.to_numpy()
# print(data.shape)

# asociez numelor speciilor cate o eticheta
iris_species = {'Iris-setosa':1, 'Iris-versicolor':2, 'Iris-virginica':3}
species_names = data[:, 4]
for s in iris_species.keys():
    species_names[np.where(species_names==s)] = iris_species[s]
    
labels = np.copy(species_names).reshape(-1, 1)

# pe ultima coloana, in loc sa am string-uri cu numele, pun etichetele
data = np.append(data[:, :4], labels, axis=1)

# standardizez
mean = np.mean(data, axis = 0, dtype=np.float64)
stddev = np.std(data, axis = 0, dtype=np.float64)
data = (data-mean) / stddev

# PCA pentru a trece din 5 dimensiuni in 2 dimensiuni
pca = PCA(n_components=2)
components = pca.fit_transform(data)

# adaug etichetele la setul de date (pentru ca atunci cand extrag multimile de train si test, sa am si etichetele)
all_data = np.append(components,labels, axis=1)

# random.shuffle trebuie sa primeasca o lista
data_copy = all_data.tolist()
random.shuffle(data_copy)
all_data = np.copy(data_copy)

# extrag 100 de date de antrenare
train_data = random.sample(all_data.tolist(), k=100)

# iterez prin liniile matricei (nu m-am prins cum sa fac direct folosind numpy arrays)
test_data= []
for lin in all_data.tolist():
    if lin not in train_data:
        test_data.append(lin)
    
train_data = np.array(train_data)
test_data = np.array(test_data)

X_train = train_data[:, :-1]
Y_train = train_data[:, -1]

X_test = test_data[:, :-1]
Y_true = test_data[:, -1]

print(X_train.shape)
print(Y_train.shape)

print(X_test.shape)
print(Y_true.shape)


def apply_SVM(kernel_type):
    clf = svm.SVC(kernel=kernel_type)
    clf.fit(X_train, Y_train)
    
    Y_pred = clf.predict(X_test)
    
    # calculez matricea de confuzie si precizia
    
    confusion_matrix = np.zeros((4,4), np.int32)
    for i in range(1,4):
        for j in range(1,4):
            for k in range(Y_true.size):
                if Y_true[k] == i and Y_pred[k] ==j:
                    confusion_matrix[i][j] += 1
                    
    precision = np.size(np.where(Y_true==Y_pred))/np.size(Y_true)
    
    print(f'\nDimensiune date de test: {np.size(Y_true)}')
    print(f'Functie kernel folosita: {kernel_type}')
    print(f'Matrice de confuzie:\n {confusion_matrix[1:, 1:]}')
    print(f'Acuratete: {precision : .4f}')
    
    # codul pentru plotare este preluat si adaptat de aici:
    # https://scikit-learn.org/stable/auto_examples/svm/plot_iris_svc.html#sphx-glr-auto-examples-svm-plot-iris-svc-py
    
    X0, X1 = X_test[:, 0], X_test[:, 1]
    
    fig, ax = plt.subplots(figsize=(4,3))
    
    disp = DecisionBoundaryDisplay.from_estimator(
        clf,
        X_train,
        response_method="predict",
        cmap=plt.cm.coolwarm,
        alpha=0.8,
        ax=ax,
    )
    ax.scatter(X0, X1, c=Y_true, cmap=plt.cm.coolwarm, s=15, edgecolors="k")
    ax.set_xticks(())
    ax.set_yticks(())
    ax.set_title(f'Marginea de decizie, kernel={kernel_type}')

    plt.show()
        
apply_SVM('linear')
apply_SVM('rbf')



