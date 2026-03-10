# -*- coding: utf-8 -*-
"""
Created on Mon Mar 31 01:52:58 2025

@author: Alex
"""

"""
    Se da un sir de numere naturale s1, s2, ..., sn si K nr natural cu K >= si
    a) scrieti un alg pseudopolinomial care gaseste suma maxima, <= K, formata din elementele din S
    b) propuneti un alg aproximativ care calculeaza o suma cel putin pe jumatate de mare ca 
    cea optima , dar ruleaza in complexitate timp O(n) si spatiu O(1)
"""

import os
path = os.path.abspath("numere.in")

def afis_matr(M):
    for linie in M:
        for elem in linie:
            print(elem, end=" ")
        print()
    print("=================================")

def alg1(S, K):
    dp = [[0] * (K+1) for i in range(len(S))]
    for idx in range(1, len(S)):
        for k in range(1, K+1):
            if S[idx] > k: # numarul este mai mare decat suma curenta
                dp[idx][k] = dp[idx-1][k]
            else:
                dp[idx][k] = max(dp[idx-1][k], dp[idx-1][k - S[idx]] + S[idx])
    afis_matr(dp)
    return dp[len(S)-1][K]

def alg2(stream, K):
    suma = 0
    s_max = -1
    for s in [int(x) for x in nrstream.split()]:
        if s <= K:
            suma += s
            K -= s
        if s > s_max:
            s_max = s
    return max(suma, s_max)
    

file = open(path, 'r')
nrstream, stK = file.read().split("\n")
numere =[0] + [int(x) for x in nrstream.split()]
K = int(stK)

rez1 = alg1(numere, K)
rez2 = alg2(nrstream, K)
print(f'OPT={rez1}')
print(f'ALG={rez2}')