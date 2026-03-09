m = int(input("numarul de linii: "))
n = int(input("numarul de coloane: "))
M = []
for i in range(m):
    linie = [int(el) for el in input().split()]
    M.append(linie)
#matricea transpusa are n linii si m coloane
T = []

T = [[M[i][j] for i in range(m)] for j in range(n)]
for linie in T:
    print (*linie)



