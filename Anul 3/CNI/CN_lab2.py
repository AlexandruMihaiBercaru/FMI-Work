"""
Calcul Numeric - Laborator 2
Bercaru Alexandru-Mihai
Grupa 331
"""

import numpy as np

# eliminarea gaussiana
def EG(A, b):
    n = b.size
    for k in range(0,n-1):
        for i in range(k+1,n):
            
            # Calculeaza multiplicatorii Gaussieni
            A[i][k] = -A[i][k] / A[k][k]   # Se suprascriu in triunghiul inferior
            
            # Aplica multiplicatorii pe linia curenta
            for j in range(k+1,n):
                A[i][j] = A[i][j] + A[k][j] * A[i][k]
                
            # modificarea elementului corespunzator liniei i in vectorul termen-liber b:
            b[i] = b[i] + b[k] * A[i][k]
            
    print(f"Dupa triangularizare:\n {A} \n vectorul termen-liber: {b}\n")        
    return A, b
      

# rezolvarea sistemelor superior triunghiulare
def UTRIS(U, b):
    n = b.size
    x = np.copy(b)
    for i in range(n-1, -1, -1):
        for j in range(i+1, n):
            x[i] = x[i] - U[i][j] * x[j]
        x[i] = x[i] / U[i][i]
    return x
          

# generam A si x aleator, calculam b-ul
d = 6
A = np.random.randn(d,d)

x_init = np.random.randn(d)

b = np.dot(A, x_init)

np.set_printoptions(precision = 6)
print(f'Inainte de triangularizare:\n {A} \n vectorul termen-liber: {b}\n')


A, b = EG(A, b) # triangularizare
sol = UTRIS(A, b) # rezolvare sistem

# am modificat precizia pentru a observa de la a cata zecimala apare eroarea
with np.printoptions(precision=15):
    print(f'Solutia generata: {x_init}\n')
    print(f'Solutia calculata: {sol}\n')

print(np.equal(sol, x_init))
            

            
            
