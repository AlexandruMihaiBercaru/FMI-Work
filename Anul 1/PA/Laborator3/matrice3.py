#triunghiul lui Pascal
n = int(input("numar de linii: "))
P = [[1] + [0] * k for k in range(n)]
for i in range(1, n):
    for j in range (1, i+1):
        if i == j:
            P[i][j] = 1
        else:
            P[i][j] = P[i-1][j-1] + P[i-1][j]
c = len(str(P[n-1][n//2]))
for linie in P:
    for element in linie:
        print(str(element).rjust(c+1), end = " ")
    print()