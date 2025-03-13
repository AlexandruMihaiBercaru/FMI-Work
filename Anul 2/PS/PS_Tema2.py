import numpy as np
import matplotlib.pyplot as plt


#Exercitiul 6
# =============================================================================
# Cerinta: Un jucator are m lei, m > 0, pentru un joc.
# Jucatorul arunca un zar corect. Daca pica orice numar intre 2 si 5,
# atunci jucatorul primeste 2 lei. Daca pica 1 sau 6, jucatorul pierde 3 lei.
# Jocul se termina cand jucatorul nu mai are bani sau cand a atins cel putin 
# suma dorita de M lei, M > m.
# a) simulati jocul propus
# b) estimati numeric probabilitatea ca jucatorul sa atinga suma de M lei
# c) afisati histograma corespunzatoare duratei jocurilor simulate
# =============================================================================


# a)
nr_jocuri = 50000

def joc_zar(m, M):
    nr_pasi = 0
    # jocul se opreste cand m devine <= 0 sau cand m >= M
    while m > 0 and m < M:
        aruncare = np.random.randint(1, 7)
        #print(f"Pas {nr_pasi + 1} - aruncare {aruncare} - suma {m}")
        if aruncare == 1 or aruncare == 6:
            m -= 3
        else:
            m += 2
        nr_pasi += 1
    return m, nr_pasi


# suma_start = 3, suma_target = 30
# suma_start = 1, suma_target = 10      
suma_start = int(input("Suma cu care incepe: "))
suma_target = int(input("Suma de atins: "))


# a)
# suma_final, durata = joc_zar(suma_start, suma_target)
# if suma_final <= 0:
#     print("Jucatorul a pierdut.")
# else:
#     print("Jucatorul a castigat.")
# print(f"Jocul a durat {durata} pasi")    


# b), c)
nr_castiguri = 0
durate_jocuri = []
for j in range(1, nr_jocuri + 1):
    suma_final, durata = joc_zar(suma_start, suma_target)
    if suma_final <= 0:
        continue
    else:
        nr_castiguri += 1
    durate_jocuri.append(durata)

probab_castig = nr_castiguri/ nr_jocuri
v_durate = np.array(durate_jocuri)


fig, ax = plt.subplots()
ax.set_ylabel("Numarul de jocuri")
ax.set_xlabel("Durata jocurilor")
plt.hist(v_durate, bins = 100)
plt.show()

print(f'\nProbabilitatea de castig: {probab_castig}')

# =============================================================================
