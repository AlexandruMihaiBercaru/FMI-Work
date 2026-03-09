#list comprehensions

#a)
# L1 = [chr(litera) for litera in range(ord('a'), ord('z')+1)]
# print(L1)

#b)
# L2 = [ ((-1)**(x+1)*x) for x in range(1, int(input('n=')) + 1) ]
# print(L2)
# L2prim = [(x if x % 2 != 0 else -x) for x in range(1, int(input('n=')) + 1)]
# print(L2prim)

#c), d)
# L = [12, -4, 5, 54, 0, -3, 7, 14]
# Limpare = [elem for elem in L if elem % 2 != 0]
# print(Limpare)
# Lpoz = [L[i] for i in range(len(L)) if i % 2 != 0]
# print(Lpoz)

#e)
# L = [12, -4, 5, 54, 0, -3, 7, 14]
# Lparitate = [L[i] for i in range(len(L)) if L[i] % 2 == i % 2]
# print(Lparitate)
# Lparitate2 = [val for poz, val in enumerate(L) if poz % 2 == val % 2]
# print(Lparitate2)

#f)
# L = [1, 2, 3, 4]
# Tupluri = [(L[i],L[i+1]) for i in range(len(L)-1)]
# print(Tupluri)

#g)
# M = [[(linie, coloana) for coloana in range(4)]for linie in range(3)]
# print(*M, sep='\n')

# n = int(input('n='))
# M = [[f"{x}*{y}={x*y}" for y in range (1, n+1)] for x in range (1, n+1)]
# for linie in M:
#     print(*linie, sep='\t')

#h)
# cuvant = "ABCDE"
# Perm = [ cuvant[i:] + cuvant[:i] for i in range(len(cuvant))]
# print(Perm)

#i)
M = [[i]*i for i in range(int(input('n=')))]
print(M)
M2 = [[i for j in range(i)] for i in range(int(input('n=')))]
print(M2)
