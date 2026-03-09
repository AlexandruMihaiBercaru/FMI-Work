#
# ## laborator 5 - problema cuburi
#
# def citire():
#     f = open("cuburi.txt", "r")
#     n = f.readline()
#     cuburi = []
# #   for i in range(n):
# #       linie = f.readline()
#     for linie in f:
#         lat, cul = linie.split()
#         cuburi.append( (int(lat), cul) ) #elementele listei sunt tupluri de forma (latura, culoarea)
#     return cuburi
#
#
#
# def greedy (cuburi):
#     cuburi.sort( key = lambda t : -t[0])
#     #cuburi.sort( reverse = True)     -> compara dupa primul element, sorteaza descrescator
#     sol = [cuburi[0]]
#     hTurn = cuburi[0][0]
#     for latura, culoare in cuburi[1:]:
#         if culoare != sol[-1][1]:
#             sol.append((latura, culoare))
#             hTurn += latura
#     return hTurn, sol
#
# def afisare(h, Hanoi):
#     with open("turn.txt", "w") as g:
#         for cub in Hanoi:
#             #g.write("{} {} \n".format(cub[0], cub[1]))
#             g.write("{} {} \n".format(*cub))
#         g.write(f"\nInaltimea totala: {h}")
#
# L = citire()
# print(L)
# lungime, turn = greedy(L)
# print(turn, lungime)
# afisare(lungime, turn)


#problema 5

# def citire():
#     with open("activitati.txt") as f:
#         n = f.readline()
#         activitati = []
#         for linie in f:
#             durata, termen = linie.split()
#             activitati.append((int(durata), int(termen)))
#     return activitati
#
# def greedy(activitati):
#     activitati.sort( key = lambda t : t[1])
#     t_curent = 0
#     intarziere_max = 0
#     solutie = []
#     for durata, termen in activitati:
#         h = max(0, (t_curent + durata) - termen)
#         intarziere_max = max(intarziere_max, h)    #varianta 1
#         solutie.append((t_curent, durata, termen, h))
#         t_curent += durata
#     #intarziere_max = max(solutie, key = lambda t : t[1])      varianta 2
#     return solutie, intarziere_max
#
# def afisare_frumoasa(sol, hMax):
#     with open("intarzieri.txt", "w") as g:
#         g.write(f'{"Interval":<12}\t{"Termen":^8}\t{"Intarziere":>10}\n')
#         for start, durata, termen, intarziere in sol:
#             g.write(f'{f"({start}--->{start+durata})":<12}\t{termen:^8}\t{intarziere:>10}\n')
#         g.write(f"Intarziere maxima: {hMax}")
#
#
# L = citire()
# print(L)
#
#
# sol, intarzmax = greedy(L)
# afisare_frumoasa(sol, intarzmax)


# problema 7 - laboratorul 4

def citire_a():
    n = int(input("n="))
    L = [int(x) for x in input("Numere cu spatiu: ").split()]
    return L

# L = citire_a()
# print(L)

L = ['a', 'y', 'x']

def functie_b(secv, x, i = 0, j = None):
    if j is None:
        j = len(secv)
    for poz in range(i, j):
        if secv[poz] > x:
            return poz
    return -1


#print(functie_b([54, 39, -28, 0, 3, 522, 76], 3, j = 3))

L = citire_a()
for poz, x in enumerate(L):
    rez = functie_b(L, x, poz+1)
    if rez != -1:
        print("Nu este sortata descrescator!")
        break
    else:
        pass # nu se intampla nimic
else:
    print("este sortata descrescator!")



## problema 10 - laboratorul 4

def cautare_cuvant(cuv, nume_out, *nume_in):
    with open(nume_out, "w") as g:
        for nume in nume_in:
            with open(nume, "r") as f:
                L_linii = []
                for poz, linie in enumerate(f):
                    for simbol in "?!.,:;":
                        linie = linie.replace(simbol, " ")
                    if cuv.lower in linie.lower().split():
                        L_linii.append(poz+1)
            g.write(f"{nume} {' '.join([str(x) for x in L_linii])}")

cautare_cuvant("fLoArE", "rez.txt", "eminescu.txt", "paunescu.txt")
