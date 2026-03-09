def frecventa_cuvinte(*nume_fisiere):
    d = {}  #cream dictionarul vid; Obs: pentru a crea multimea vida: s = set()
    for nume in nume_fisiere:
        f = open(nume)
        for cuv in f.read().split(): # .split() -> sparge la spatii si \n
            # if cuv not in d:
            #     d[cuv] = 1
            # else:
            #     d[cuv] += 1

            d[cuv] = d.get(cuv, 0) + 1    ## daca exista cuv get returneaza valoarea asociata cheii (frecventa deja existenta)

            ## daca nu exista cuv, get returneaza 0

        f.close()
    return d

# b)
d12 = frecventa_cuvinte("cuvinte1.in", "cuvinte2.in")
print(d12, '\n')
print(d12.items(), '\n')   #un obiect de tip dict.items -> nu e chiar o lista
print(sorted(d12.keys()), '\n')

# c)
d1 = frecventa_cuvinte("cuvinte1.in")
print(d1, '\n')
print(sorted(d1.items(), key = lambda t : -t[1]), '\n')  # minus pentru sortarea descrescatoare a datelor de tip numeric
## daca am mai multe criterii de comparare (in caz de egalitate la primul criteriu, sa treaca la al doilea), le pun intr-un tuplu

# d)
d2 = frecventa_cuvinte("cuvinte2.in")
print(d2, '\n')
print(min(d2.items(), key = lambda t:(-t[1], t[0]))[0], '\n')

#pt min si max --> parametrul key cu criteriu (ca la sorted)

# e)
suma12 = sum( [ d1.get(cuv, 0) * d2.get(cuv, 0) for cuv in d12.keys() ] )
suma1 = sum( [frecv**2 for frecv in d1.values()] ) ** 0.5
suma2 = sum( [frecv**2 for frecv in d2.values()] ) ** 0.5
rez =round(suma12 / (suma1 * suma2), 2)
print(rez)


## problema 3)
L_siruri = []
nota = 1
with open("test.in", 'r') as f:  ## f-ul este alias; nu trebuie sa mai apelam f.close()
    for linie in f:
        aux, rez = linie.split('=') ## prima data spargem prima linie din fisier la 'egal' --> 3*4   11
        x, y = aux.split('*')  ## am obtinut 3 stringuri
        if int(x) * int(y) == int(rez):
            L_siruri.append(f"{linie.strip()} Corect")  ## am eliminat \n de la capatul randului
            nota += 1
        else:
            L_siruri.append(f"{linie.strip()} Gresit {int(x) * int(y)}") ## am calculat si valoarea corecta
    L_siruri.append(f"Nota {nota}")

with open("test.out", 'w') as g: ## s-a creat fisierul test.out
    g.write("\n".join(L_siruri))


# problema 5

def negative_pozitive(L):
    pozitive = [ x for x in L if x > 0]
    negative = [ x for x in L if x < 0]
    return negative, pozitive

nume = input ("numere fisierului: ")    ## de la tastatura: numere.txt

with open (nume, 'r') as f:
    lista_nr = [int(x) for x in f.read().split()]

lista_neg, lista_poz = negative_pozitive(lista_nr)   ## sunt liste de integers

with open (nume, 'a') as g: ## acum vrem sa adaugam la fisierul din care am citit 'lista' de pozitive si 'lista' de negativw
    ## din numere trebuie sa facem stringuri, vrem un sir format din acele stringuri pe care il cream cu metoda join
    g.write("\n" + " ".join([str(x) for x in lista_neg]))
    g.write("\n" + " ".join([str(x) for x in lista_poz]))


# problema 8

def liste_x (x, *liste):
    global nr
    for L in liste:
        if x in L:
            nr += 1

nr = None
liste_x(3, [1, 5, 7], [3], [1, 8, 3], [4, 3])
print(nr)


## problema 9

def cif_max(*numere):
    rez = int("".join([ max(str(x)) for x in numere]))
    return rez

def binar(a, b, c):
    return cif_max(cif_max(a, b, c)) == 1

print(binar(1010, 10, 11), binar(24, 41, 10))


# #problema 7

def citire_a():
    n = int(input("n="))
    L = [int(x) for x in input("Numere cu spatiu: ").split()]
    return L

# L = citire_a()
# print(L)

#L = ['a', 'y', 'x']

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


# problema 10

def cautare_cuvant(cuv, nume_out, *nume_in):
    with open(nume_out, "w") as g:
        for nume in nume_in:
            with open(nume, "r") as f: #parcurg 1 fisier
                L_linii = []
                for poz, linie in enumerate(f):
                    for simbol in "-?!.,:;":
                        linie = linie.replace(simbol, " ")
                    if cuv.lower() in linie.lower().split():
                        L_linii.append(poz+1)

            g.write(f"{nume} {" ".join([str(x) for x in L_linii])}" + "\n")

cautare_cuvant("fLoArE", "rez.txt", "eminescu.txt", "paunescu.txt")


## problema 2

p = int(input("p= ")) #Numarul de litere de la final care tb sa fie identice
file_name = input("numele fisierului: ")
p_rime = {}
f = open(file_name, 'r')
for linie in f:
    aux = linie.split()
    for cuv in aux:
        rima = cuv[(len(cuv)-p):len(cuv)]
        if p_rime.get(rima, 0) == 0:
            p_rime[rima] = [cuv]
        else:
            p_rime[rima].append(cuv)
f.close()
with open("rime.txt", 'w') as g:
    liste_cuv = list(p_rime.values())
    liste_cuv.sort(key = lambda t : -len(t))
    for L in liste_cuv:
        g.write(f"{" ".join([x for x in sorted(L, reverse=True)])}" + "\n")

import string
import random


## problema 4

Students = []
with open("date.in") as f:
    for linie in f:
         aux = linie.lower().split()
         Students.append(aux)
def generate_pass():
    return random.choice(string.ascii_uppercase) + "".join(random.choices(string.ascii_lowercase, k=3)) + str(random.randrange(1000, 10000))

E_pass = []
for stud in Students:
    email = stud[1] + "." + stud[0] + "@s.unibuc.ro"
    passw = generate_pass()
    E_pass.append((email, passw))

with open("date.out", 'w') as g:
    for elem in E_pass :
        g.write("\n" + f"{elem[0]},{elem[1]}")


#problema 6

elevi = {}
with open ("elevi.in") as f:
    for linie in f:
        aux = linie.split()
        nume = aux[1] + " " + aux[2]
        lista_note = [int(n) for n in aux[3:]]
        elevi[int(aux[0])]=[nume, lista_note]
print(elevi)

# #b)
def add_punctoficiu(CNP, E): #E - structura in care s-au memorat date despre elevi (dictionarul)
    if E.get(CNP) is None:
        return None
    else:
        E[CNP][1][0] += 1
        return E[CNP][1][0]

#c)
def add_lista_note(CNP, L, E):
    if E.get(CNP) is None:
        return None
    else:
        E[CNP][1].extend(L)
        return E[CNP][1]
#l_note=[10, 8]

#d)
def sterge_elev(CNP, E):
    if E.get(CNP) is None:
        pass
    else:
        E[CNP].clear()

lista_elevi = []
for cod in elevi:
    elev = [elevi[cod][0].split()[0], elevi[cod][0].split()[1], elevi[cod][1]]
    lista_elevi.append(elev)
lista_elevi.sort(key = lambda t: (-(sum(t[2])/len(t[2])), t[0]) )
with open ("elevi.out", "w") as g:
    for elem in lista_elevi:
        g.write(f"{elem[0]} {elem[1]} - media {sum(elem[2])/len(elem[2])}" + "\n")

def genereaza_coduri(E):
    for key in E:
        cod = "".join(random.choices(string.ascii_lowercase, k=3)) + str(random.randrange(100, 1000))
        E[key].append(cod)

genereaza_coduri(elevi)
print(elevi)

