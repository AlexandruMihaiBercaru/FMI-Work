
#1
# prop = input("dati propozitia:").split()
# cuvinte = [cuv for cuv in prop if len(cuv) >= 2]
# print(cuvinte)
# cuvinte.sort( key = lambda t : len(t), reverse = True)
# print(cuvinte)
# prop_nou = " ".join(cuvinte)
# prop_nou.capitalize()
# prop_nou += '.'
# print(prop_nou)


#2
# def suma(t):
#     s = 0
#     for c in str(t):
#         s += int(c)
#     return s
# v = [int(x) for x in input("dati numerele: ").split()]
# print(sorted(v, key = lambda t : (suma(t), -t)))

#4
# v = [int(x) for x in input("dati numerele: ").split()]
# v.sort(key = lambda t : (-(t%2), t if t % 2 == 1 else -t))
# print(v)

#3
# 3
# Marineanu Maria 22 10 9 5
# Mihaliu Dan 22 4 5 10 10
# Podaru Ilie 21 10 10 8 8

n = int(input("n="))
M = []
for i in range(n):
    aux = input().split()
    student = [aux[0], aux[1], int(aux[2]), [int(i) for i in aux[3:]]]
    M.append(student)
print(M)
for i in range(len(M)):
    M[i] = M[i] + [True] if min(M[i][3]) >= 5 else M[i] + [False]
print(M)

#c)
M = sorted(M, key = lambda x : (x[2], x[0]))
for linie in M:
    student = linie[0] + ' ' + linie[1]
    print(student)

#d)

def restante(L):
    nr = 0
    for elem in L:
        if elem < 5:
            nr += 1
    return nr


M = sorted(M, key = lambda x: (x[2], -x[4], -(sum(x[3])/len(x[3])), restante(x[3]) ) )
print(M)

#e)
val = max(M, key = lambda x : sum(x[3])/len(x[3]) )
print(val)

