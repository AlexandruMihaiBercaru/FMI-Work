# -*- coding: utf-8 -*-
"""
Created on Tue Oct 22 23:00:01 2024

@author: Alex
"""

import numpy as np
import matplotlib.pyplot as plt
ax = plt.gca()
ax.set_aspect('equal', adjustable='box')




'''exercitiul 5'''
# =============================================================================
# N = 50000
# def intersectie(px, py, r, a, b):
#     xs = np.random.uniform(-4, 4, size = N)
#     ys = np.random.uniform(-4, 4, size = N)
#     in_disc = np.where(np.sqrt((xs - px) ** 2 + (ys - py) ** 2) <= np.sqrt(2))
#     in_elipsa = np.where(xs**2 / a**2 + ys**2 / b**2 <= 1)
#     intersect = np.intersect1d(in_disc, in_elipsa)
#     non = np.setdiff1d(np.array([x for x in range(0, N)]), np.union1d(in_disc, in_elipsa))
    
#     plt.scatter(xs[in_disc], ys[in_disc], marker = '.', color = 'C2', s = 3)
#     plt.scatter(xs[in_elipsa], ys[in_elipsa], marker = '.', color = 'C1', s = 3)
#     plt.scatter(xs[intersect], ys[intersect], marker = '.', color = 'C6', s = 3)
#     plt.scatter(xs[non], ys[non], marker = '.', color = 'C8', s = 3)

#     P = np.count_nonzero(intersect) / np.count_nonzero(xs)
#     return 64 * P 
#     # D = [-4, 4] * [-4, 4] => aria = 64
# print(f'Aria intersectiei:{intersectie(2, 2, np.sqrt(2), 3, 2)}')
# =============================================================================



'''exercitiul 6'''
# =============================================================================
N = 50000
f1 = lambda x, y : x ** 2 + y ** 4 + 2 * x * y - 1
f2 = lambda x, y : y ** 2 + x ** 2 * np.cos(x) - 1
f3 = lambda x, y : np.exp(x ** 2) + y ** 2 - 4 + 2.99 * np.cos(y)
def arii():
    p1 = np.random.uniform(-3, 3, size = (2, N))
    p2 = np.random.uniform(-5, 5, size = (2, N))
    p3 = np.random.uniform(-2.5, 2.5, size = (2, N))
    
    in_d1 = np.where(f1(p1[0], p1[1]) <= 0)
    in_d2 = np.where(f2(p2[0], p2[1]) <= 0)
    in_d3 = np.where(f3(p3[0], p3[1]) <= 0)

    plt.scatter(p1[0][in_d1], p1[1][in_d1], marker = '.', color = 'maroon', s = 5, alpha = 0.3)
    plt.scatter(p2[0][in_d2], p2[1][in_d2], marker = '.', color = 'greenyellow', s = 5, alpha = 0.3)
    plt.scatter(p3[0][in_d3], p3[1][in_d3], marker = '.', color = 'yellow', s = 5, alpha = 0.3)
    
    A_1 = 36 * (np.count_nonzero(in_d1) / N)
    A_2 = 100 * (np.count_nonzero(in_d2) / N)
    A_3 = 25 * (np.count_nonzero(in_d3) / N)
    return A_1, A_2, A_3

ad1, ad2, ad3 = arii()
print(f"Aria D1 = {ad1}\nAria D2 = {ad2}\nAria D3 = {ad3}")
# =============================================================================



'''exercitiul 7'''
# =============================================================================
N = 1000000
def estim_pi(R, r):
    pts = np.random.uniform(-R/2, R/2, size = (2, N))
    in_disc = np.where(np.sqrt(pts[0] ** 2 + pts[1] ** 2) <= r)
    P = np.count_nonzero(in_disc) / N
    estim = (P * R ** 2) / (r ** 2)
    return estim
print(f'O estimare a lui pi: {estim_pi(2, 1)}') 
# =============================================================================



'''exercitiul 8'''
# =============================================================================
#presupunem l <= t
N = 10000000
def Buffon(l, t):
    #distanta de la centrul acului la cea mai apropiata linie
    x = np.random.uniform(0, t/2, size = N) 
    #unghiul dintre ac si linie (intre 0 si pi/2 radiani) 
    angle = np.random.rand(N) * np.pi / 2 
    #verificarea ca acul sa intretaie o linie
    pe_linie = np.where(x <= (l / 2) * np.sin(angle))
    P = np.count_nonzero(pe_linie) / N
    return (2 * l) / (t * P)
aprox_pi = Buffon(2.6, 5)
print(f"O alta estimare a lui pi: {aprox_pi}")    
# =============================================================================

