'''
    Calcul Numeric - Laboratorul 4
    Bercaru Alexandru-Mihai
    Grupa 331
'''

import numpy as np
import pandas as pd
import scipy
import matplotlib.image
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
import random

#%%
# Exercitiul 1

# a)
m, r = 10, 4
A = np.random.rand(m, r)
rang = np.linalg.matrix_rank(A)
print(f'Rang initial: {rang}')

# b)
nr_cols = A.shape[1]
new_cols_count = 4
for k in range(new_cols_count):
    # iau 3 coloane din cele existente
    col_idx = random.sample(range(nr_cols),3)
    # generez aleator 3 coeficienti pt combinatia liniara
    coeffs = np.random.randn(3,)
    # noua coloana
    new_col = A[:, col_idx[0]: col_idx[0]+1]  * coeffs[0] + A[:, col_idx[1]: col_idx[1]+1]  * coeffs[1] + A[:, col_idx[2]: col_idx[2]+1]  * coeffs[2]
    # concatenez coloana la matricea existenta
    A = np.append(A, new_col, axis = 1)
    # print(new_col)
    # print(new_col.size)

print(A.shape)
print(f'Rangul dupa adaugarea coloanelor: {np.linalg.matrix_rank(A)}')
'''
    Rangul a ramas 4 (coloanele adaugate nu sunt liniar independente)
'''

# c) adaug zgomot gaussian -> "maschez" rangul real al matricei
noise = np.random.normal(0, 0.2, A.shape)
A_nou = A + noise
print(f'Rangul dupa adaugarea de zgomot: {np.linalg.matrix_rank(A_nou)}')

# d) obtinerea valorilor singulare
U, S, V = np.linalg.svd(A_nou)
print(f'Valorile singulare:\n{S}')
    

'''
    In acest caz, pentru ca stim rangul real al matricei, putem considera ca
    cele mai mici 4 valori singulare sunt neglijabile.
    Daca nu am fi cunoscut de la inceput rangul matricei neafectate de zgomot, 
    ar fi fost mai greu sa il obtinem doar bazandu-ne pe valorile singulare.
    De exemplu, daca aplicam un prag epsilon = 1, am fi putut elimina
    mai mult de 4 valori singulare, deci am fi obtinut in mod eronat un rang mai mic
     
'''    
    
#%%
# Exercitiul 2

def show(caption, imag):
    plt.title(caption)
    plt.imshow(imag, cmap='gray')
    plt.show()
    

img = matplotlib.image.imread('casuta.jpg')
# transform imaginea in grayscale (pentru a avea un singur canal , iar matricea sa aiba forma (height, width))
img = img[:, :, 0] * 0.299 + img[:, :, 1] * 0.587 + img[:, :, 2] * 0.114 

h, w = img.shape
print(f'Dimensiuni initiale: height={h}, width={w}')

show('Imagine initiala', img)

U, S, V = np.linalg.svd(img)
print(U.shape)
print(S.shape)
print(V.shape)

k = random.sample(range(min(h, w)), 1)

def aproximare_rang_k(U, S_vect, V, k):
    
    S = np.diag(S_vect[:k]) # iau primele k valori singulare si formez o matrice diagonala
    A_aprox = np.matmul(np.matmul(U[:, :k], S), V[:k, ]) # V este deja transpusa!
    # print(A_aprox.shape)
    return A_aprox

img = aproximare_rang_k(U, S, V, int(k[0]))
show(f'Imagine comprimata (rang={k[0]})', img)

ranguri = [200, 100, 30]
img1 = aproximare_rang_k(U, S, V, ranguri[0])
img2 = aproximare_rang_k(U, S, V, ranguri[1])
img3 = aproximare_rang_k(U, S, V, ranguri[2])

show(f'Rang = {ranguri[0]}', img1)
show(f'Rang = {ranguri[1]}', img2)
show(f'Rang = {ranguri[2]}', img3)



#%%
# Exercitiul 3

dataset = pd.read_csv('https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data')

data = dataset.to_numpy()
print(data.shape)

# ultima coloana din setul de date contine specia de iris (sub forma de string), voi converti informatia la int
iris_species = {'Iris-setosa':1, 'Iris-versicolor':2, 'Iris-virginica':3}
col = data[:, 4]
for s in iris_species.keys():
    col[np.where(col==s)] = iris_species[s]
data[:, 4] = col

# standardizam datele: scadem media si impartim la deviatia standard pe fiecare coloana
# datele vor avea medie 0 si deviatie standard 1
mean = np.mean(data, axis = 0, dtype=np.float64)
stddev = np.std(data, axis = 0, dtype=np.float64)
data = (data-mean) / stddev

# analiza componentelor principale
pca = PCA(n_components=2)
components = pca.fit_transform(data)
X, Y = components[:, 0], components[:, 1]

plt.figure()
plt.scatter(X, Y, color='purple', marker = '.')
plt.title('Iris dataset - PCA')
plt.show()

print(f'Setul de date dupa PCA are dimensiunea: {components.shape}')


