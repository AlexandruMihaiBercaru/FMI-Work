# Tema 6
# Laborator 9
# Bercaru Alexandru-Mihai
# Grupa 231


import numpy as np
import matplotlib.pyplot as plt
import scipy.stats

# Exercitiul 2

func = lambda x : 10 * np.exp(-10 * x) * (x ** 2) * np.sin(x)


def monte_carlo_est(f, n, a, b, lmbd):
    pdf = lambda x : scipy.stats.expon.pdf(x, loc = 0, scale = (1/lmbd))

    rvars = np.random.exponential(scale = 1 / lmbd, size = n)
    weights = f(rvars) / pdf(rvars)
    estim = np.mean(weights)
    print(f'Aproximarea integralei: {round(estim, 6)}')
    
    plt.grid()
    nr_esantioane = np.arange(1, n + 1)
    # v_a: sume de variabile aleatoare de la 1 la i
    v_a = np.cumsum(f(rvars) / pdf(rvars))
    
    aproximari = np.array([])
    for i in range(n):
        aproximari = np.append(aproximari, (v_a[i] / (i+1)))
    plt.plot(nr_esantioane, aproximari, color = 'C4')
    plt.title("Graficul aproximarilor integralei")
    plt.show()

monte_carlo_est(func, 3500, 0, 100, 10)

