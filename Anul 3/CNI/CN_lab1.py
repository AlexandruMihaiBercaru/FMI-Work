"""
Calcul Numeric - Laborator 1
Bercaru Alexandru-Mihai
Grupa 331
"""

import numpy as np
from scipy import linalg
import matplotlib.pyplot as plt


# Exercitiul 1

# a) x_60 = 0.6 (folosind periodicitatea sirului)
# b), c)
def sir(k, x):
    for i in range(k):
        if 0 <= x < 0.5:
            x = 2 * x
        else:
            if 0.5 < x <= 1:
                x = 2 * x - 1
        print(f"x_{i+1} = {x:.4f}")
    """
        La un anumit pas al executiei, apare o eroare in calcul, care va fi practic dublata
        cu fiecare iteratie. Din acest motiv, la un moment dat eroarea va ajunge suficient de mare
        incat sa "strice" periodicitatea sirului, iar termenii vor deveni egali cu 0.5 
        (din acel punct, sirul va deveni constant).
    """
sir(60, 0.1)


# Exercitiul 3

# a)
data_array = np.genfromtxt('regresie.csv', delimiter=',')
# print(data_array.shape)

b = data_array[:, 1]
A = data_array[:, 0:1]
A = np.append(A, np.ones((20, 1), dtype=int), axis=1)

# print(A)
# print(A.shape)
# print(b.shape)

# b)
x, _, _, _ = linalg.lstsq(A, b)
print(f'\nEcuatia dreptei: f(z) = {x[0]} * z + ({x[1]}) ')

# c)
z = A[:, 0]

fig, ax = plt.subplots()
ax.scatter(z, b, marker = '.', color='green')
ax.plot(z, x[0] * z + x[1], label = 'Dreapta de regresie', color = 'purple')
plt.legend()
plt.show()
