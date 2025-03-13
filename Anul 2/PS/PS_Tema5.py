# Tema Laborator 8 Probabilitati si Statistica
# Bercaru Alexandru Mihai
# Grupa 231


import numpy as np
import matplotlib.pyplot as plt
import scipy.stats

# Exercitiul 2

# =============================================================================

N = 10000
mu = 1                                            
sigma = 2
X = np.random.normal(mu, sigma, size = N)

alfa, beta = 5, 10

Y1 = alfa + X
Y2 = beta * X
Y3 = alfa + beta * X

# histograma pentru Y = alfa + X
plt.hist(Y1, density = True, alpha = 0.6, color = 'C2', bins = 30)
xmin, xmax = plt.xlim()
xs = np.linspace(xmin, xmax, 1000)
ys = scipy.stats.norm.pdf(xs, alfa + mu, sigma)
plt.title('Y = α + X')
plt.plot(xs, ys, color = 'C3', linewidth = 2)
plt.show()


# histograma pentru Y = beta * X
plt.hist(Y2, density = True, alpha = 0.6, color = 'C1', bins = 30)
xmin, xmax = plt.xlim()
xs = np.linspace(xmin, xmax, 1000)
ys = scipy.stats.norm.pdf(xs, beta * mu, beta * sigma)
plt.title('Y = β * X')
plt.plot(xs, ys, color = 'C3', linewidth = 2)
plt.show()


# histograma pentru Y = alfa + beta * X
plt.hist(Y3, density = True, alpha = 0.6, color = 'C4', bins = 30)
xmin, xmax = plt.xlim()
xs = np.linspace(xmin, xmax, 1000)
ys = scipy.stats.norm.pdf(xs, alfa + beta * mu, beta * sigma)
plt.title('Y = α + β * X')
plt.plot(xs, ys, color = 'C3', linewidth = 2)
plt.show()

# =============================================================================


# Exercitiul 5

# =============================================================================

# punctul a)
def rand_walk_2(pasi):
    xs = np.random.choice([-1 / np.sqrt(0.5), 0, 1 / np.sqrt(0.5)], size = pasi, p = [0.25, 0.5, 0.25])
    poz_finala = np.sum(xs) 
    return poz_finala, xs


# apel pentru a)
nr_pasi = 300
poz_fin, xs = rand_walk_2(nr_pasi)
pozitii_intermediare = np.concatenate(([0], np.cumsum(xs)))
plt.scatter(np.arange(0, nr_pasi+1), pozitii_intermediare, marker = '.')
plt.plot(np.arange(0, nr_pasi+1), pozitii_intermediare)
plt.title("Traiectoria mersului aleator")
plt.show()



# b), c)
N = 10000
nr_pasi = 300
pozitii = np.array([])
for i in range(N):
    poz_fin, xs = rand_walk_2(nr_pasi)
    pozitii = np.append(pozitii, poz_fin)

# afisarea histogramei
plt.hist(pozitii, density = True, color = 'C1', alpha = 0.6, bins = 30)

# afisarea graficului pdf
expected_val = -1 / np.sqrt(0.5) * 0.25 + 0 * 0.5 + 1 / np.sqrt(0.5) * 0.25
var = (2 * 0.25 + 0 * 0.5 + 2 * 0.25) - expected_val ** 2

xmin, xmax = plt.xlim()
xs = np.linspace(xmin, xmax, 100)

scale = np.sqrt(nr_pasi * var)
loc = nr_pasi * expected_val

ys = scipy.stats.norm.pdf(xs, loc, scale)
plt.plot(xs, ys, color = 'C3', linewidth = 3)
plt.title("Distributia pozitiilor finale - Ex#5")
plt.show()


# d) - comparatie cu histograma de la Ex. 4 pentru cazul p = 0.5
def rand_walk(pasi, prob):
    xs = np.random.choice([-1, 1], size = pasi, p = [1-prob, prob])
    poz_finala = np.sum(xs)
    return poz_finala
p = 0.5
pozitii = np.array([])
for i in range(N):
    pozitii = np.append(pozitii, rand_walk(300, p))
plt.hist(pozitii, density = True, color = 'C1', alpha = 0.6, bins = 30)
expected_val = 2 * p - 1
var = 4 * p * (1 - p)
xmin, xmax = plt.xlim()
xs = np.linspace(xmin, xmax, 100)
scale = np.sqrt(nr_pasi * var)
loc = nr_pasi * expected_val
ys = scipy.stats.norm.pdf(xs, loc, scale)
plt.plot(xs, ys, color = 'C3', linewidth = 3)
plt.title("Distributia pozitiilor finale - Ex#4")
plt.show()


# Ambele distributii ale pozitiilor finale sunt modelate de variabile 
# aleatoare cu o repartitie normala cu media 0 si varianta = sqrt(n) * sigma, 
# unde sigma = varianta variabilei aleatoare care modeleaza pasul

# =============================================================================




