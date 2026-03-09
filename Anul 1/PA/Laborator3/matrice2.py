m = int(input("numarul de linii: "))
n = int(input("numarul de coloane: "))
M = [[0 for x in range(n)] for y in range(m)]
for i in range(m):
    for j in range(n):
        M[i][j] = int(input())

for linie in M:
    print(*linie)
for i in range(m-1):
    for k in range(i, m):
        if M[i][0] > M[k][0]:
            M[i][0], M[k][0] = M[k][0], M[i][0]
for linie in M:
    for element in linie:
        print(str(element).rjust(5), end = " ")
    print()

