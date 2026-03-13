'''
    Calcul Numeric - Laboratorul 6 (Metode Bayesiene)
    Bercaru Alexandru-Mihai
    Grupa 331
'''

import numpy as np
import matplotlib.pyplot as plt
from scipy import stats


X = np.array([82, 106, 120, 68, 83, 89, 130, 92, 99, 89]) 
mu, sigma = 90, 10

# Exercitiul 1
def plot_normal_distribution(mean, stddev):
    x = np.linspace(0, 200, 10000)
    plt.plot(x, stats.norm.pdf(x, mean, stddev), 'g')
    plt.xlabel('x')
    plt.ylabel('pdf(x)')
    plt.show()
# plot_normal_distribution(mu, sigma)
    

# Exercitiul 2
def compute_likelihood_gaussian(data, mean, stddev):
    P = np.exp(- (data - mean) ** 2 / (2 * stddev ** 2)) / np.sqrt(2 * np.pi * stddev ** 2) 
    return P

data = X[0]
likelihood_1 = compute_likelihood_gaussian(data, mu, sigma)
likelihood_2 = stats.norm.pdf(data, mu, sigma)
# print(f'Verosimilitatea folosind formula: {likelihood_1}')
# print(f'Versomilitatea folosind scipy: {likelihood_2}')


# Exercitiul 3
def total_likelihood(X, mu, sigma):
    l = 1
    for x in X:
        l *= compute_likelihood_gaussian(x, mu, sigma)
    return l

total = total_likelihood(X, mu, sigma)
# print(total)


# Exercitiul 4+5
def prior_prob():
    model_mu= np.random.normal(100, 50, 1)[0]
    model_sigma = np.random.uniform(0, 70, 1)[0]
    # print(f'Folosesc o distributie uniforma de medie {new_mu} si deviatie standard {new_sigma}')
    
    pdf1 = stats.norm.pdf(model_mu, 100, 50)
    pdf2 = stats.uniform.pdf(model_sigma, 0, 70)
    prior = pdf1 * pdf2
    return prior

prior = prior_prob()

posterior = prior * total
print(f'A posteriori (medie = {mu}, stddev = {sigma}): {posterior}\n\n')


# Exercitiul 6
M = [70 + k for k in range (0,35,5)]
S = [k for k in range(5,25,5)]
best_m, best_s = -1, -1
max_post = 0
for m in M:
    for s in S:
        likelihood = total_likelihood(X, m, s)
        post = likelihood * prior
        print(f'A posteriori (medie = {m}, stddev = {s}): {post}')
        if post > max_post:
            max_post = post
            best_m = m
            best_s = s
        
print(f'Cel mai bun model: μ={best_m}, σ = {best_s}')
# media 95 si deviatia standard 20
