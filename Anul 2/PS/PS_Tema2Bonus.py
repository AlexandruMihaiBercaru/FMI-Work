
import numpy as np
import matplotlib.pyplot as plt

# Tema Bonus 2
# Laborator 8
# Bercaru Alexandru-Mihai
# Grupa 231



# Fie mersul aleator:
# Y_0 = 0,
# Y_n = Y_n-1 + X_n,  X_n ~ ( -2   0      3)
#                           (0.3   0.4  0.3)
# Simulati si afisati graficul unei traiectorii a mersului
# aleatoriu propus. Afisati histograma pozitiilor finale dupa n pasi.


def random_walk_3(pasi):
    xs = np.random.choice([-2, 0, 3], size = pasi, p = [0.3, 0.4, 0.3])
    poz_finala = np.sum(xs) 
    return poz_finala, xs

nr_pasi = 300

# graficul traiectoriei
poz_fin, xs = random_walk_3(nr_pasi)
pozitii_intermediare = np.concatenate(([0], np.cumsum(xs)))
plt.scatter(np.arange(0, nr_pasi+1), pozitii_intermediare, marker = '.', color = 'C6')
plt.plot(np.arange(0, nr_pasi+1), pozitii_intermediare)
plt.title("Traiectoria mersului aleator")
plt.show()


N = 10000
pozitii = np.array([])
for i in range(N):
    poz_fin, xs = random_walk_3(nr_pasi)
    pozitii = np.append(pozitii, poz_fin)

plt.hist(pozitii, density = True, color = 'C4', alpha = 0.6, bins = 30)
plt.show()

# variabila X_n are media 0.9 - 0.6 = 0.3
# histograma pozitiilor finale dupa n = 300 pasi este modelata de o variabila
# aleatoare cu media n * E(X_n) = 300 * 0.3 = 100

