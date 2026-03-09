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

## b)
d12 = frecventa_cuvinte("cuvinte1.in", "cuvinte2.in")
print(d12, '\n')
print(d12.items(), '\n')   #un obiect de tip dict.items -> nu e chiar o lista
print(sorted(d12.keys()), '\n')

## c)
d1 = frecventa_cuvinte("cuvinte1.in")
print(d1, '\n')
print(sorted(d1.items(), key = lambda t : -t[1]), '\n')  # minus pentru sortarea descrescatoare a datelor de tip numeric
## daca am mai multe criterii de comparare (in caz de egalitate la primul criteriu, sa treaca la al doilea), le pun intr-un tuplu

## d)
d2 = frecventa_cuvinte("cuvinte2.in")
print(d2, '\n')
print(min(d2.items(), key = lambda t:(-t[1], t[0]))[0], '\n')

#pt min si max --> parametrul key cu criteriu (ca la sorted)

## e)
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

nr = 0
liste_x(3, [1, 5, 7], [3], [1, 8, 3], [4, 3])
print(nr)

## problema 9

def cif_max(*numere):
    rez = int("".join([ max(str(x)) for x in numere]))
    return rez

def binar(a, b, c):
    return cif_max(cif_max(a, b, c)) == 1

print(binar(1010, 10, 11), binar(24, 41, 10))

