"""
Calcul Numeric - Laborator 3
Bercaru Alexandru-Mihai
Grupa 331
"""

#%%
import numpy as np
import pickle
# import networkx

# Exercitiul 1

def metoda_puterii(A, tol, max_iter):
    # calculeaza vectorul propriu asociat valorii proprii dominante
    
    y = np.random.randn(A.shape[0])
    y = y.reshape(-1, 1) # ca sa aiba forma (n, 1)
    
    # print(y.shape)
    iter, err = 0, 1
    
    while err > tol:
        if iter > max_iter:
            break
        
        y = y / np.linalg.norm(y)
        z = np.dot(A, y)
        # print(z.shape)
        z = z / np.linalg.norm(z)
        
        err = np.abs( 1 - np.abs( np.dot(z.T, y) ) )
        y = np.copy(z)
        
        iter += 1
    
    return y


n = 6
A = np.random.rand(n, n)
y = metoda_puterii(A, 10e-6, 100000)
print(y)


eigenvals, eigenvecs = np.linalg.eig(A)
'''
    extrag din matricea de eigenvectors pe vectorul 
    corespunzator valorii proprii dominante
'''
v = eigenvecs[:, np.argmax(eigenvals)]
print(v)


#%%
import networkx as nx
import pickle
import matplotlib.pyplot as plt
from networkx.algorithms import approximation
# Exercitiul 2


# a) obtinerea matricilor de adiacenta
with open('grafuri.pickle', 'rb') as f:
    mat1, mat2, mat3 = pickle.load(f)
    

def procesare_matrice(mat):
    
    G = nx.from_numpy_array(mat)
    
    # b) 
    plt.figure() # pentru a desena fiecaere graf intr o fereastra separata
    nx.draw(G, with_labels = True)
    plt.show()
    
    
    # c) obtinerea valorilor proprii

    
    '''am observat ca daca folosesc np.linalg.eig, obtin 
    cateva valori proprii complexe (cu parte imaginara foarte mica nenula),
    ceea ce in teorie nu ar trebui sa se intample, din moment ce matricea de adiacenta
    este reala si simetrica. Am presupus ca apar erori de calcul din cauza
    aritmeticii floating-point, asa ca am decis sa rotunjesc fiecare
    valoare proprie la a 8-a zecimala 
    '''
    eigenvals, eigenvecs = np.linalg.eig(mat)
    
    eigenvals_round = np.round(eigenvals, decimals = 8)
    
    # d) verificarea anumitor proprietati ale grafului
    
    min_eigval = np.min(eigenvals_round)
    #print(min_eigval)
    max_eigval = np.max(eigenvals_round)
    #print(max_eigval)
    
    distinct_eigvals = np.unique(eigenvals_round)
    #print(distinct_eigvals)
    #print(distinct_eigvals.size)
    
    if distinct_eigvals.size == 2:
        print('Este complet')
    else:
        print('Nu este complet')
        
        
    if min_eigval == -max_eigval:
        print('Este bipartit')
    else:
        print('Nu este bipartit')
        
    clica = nx.algorithms.approximation.clique.max_clique(G)
    print(f'Dimensiunea maxima a unei clici: {len(clica)}')
    print(max_eigval + 1)


M = [mat1, mat2, mat3]

for i in range(len(M)):
    print(f'-------GRAFUL {i+1}---------')
    procesare_matrice(M[i])

    
    








    