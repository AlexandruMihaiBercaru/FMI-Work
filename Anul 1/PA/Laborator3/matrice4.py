#ciurul lui eratostene

n = int(input("n="))
e_prim = [0] * (n+1)
e_prim[0], e_prim[1] = 1, 1
for i in range(4, n+1, 2):
    e_prim[i] = 1
for i in range(3, n+1, 2):
    if e_prim[i] == 0:
    #pana la pasul curent, e potential prim
        for j in range (i*i, n+1, i):
            e_prim[j] = 1
prime = [i for i in range(2, n) if e_prim[i] == 0]
print(prime)
print(f"Sunt {len(prime)} numere prime mai mici sau egale cu {n}")


