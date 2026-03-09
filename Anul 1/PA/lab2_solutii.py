
# problema 1
# s = input("cuvantul este: ")
# s2 = s.replace(s[0], "")
# print(f"Dupa stergerea literei '{s[0]}' sirul obtinut este \"{s2}\" de lungime {len(s2)}")
#
# s3 = "".join(s.split(s[0]))
# print(s.split(s[0]))
#
# print("Dupa stergerea literei '{}' sirul obtinut este {} de lungime {}".format(s[0], s2, len(s2)))

# problema 2
# s = input("sirul: ")
# t = input("subsirul de cautat: ")
# if s.find(t) == -1:
#      print("Subsirul '{subsir}' nu se afla in '{sir}'".format(subsir = t, sir = s))
# else:
#      for i in range(len(s)):
#         if s.startswith(t, i) == True:
#             print(i)
#
# try:
#     poz = s.index(t)
#     for i in range(len(s)):
#         if s.startswith(t, i) == True:
#             print(i)
# except ValueError:
#     print (f"Subsirul '{t}' nu apare in '{s}'")


# problema 3
# s = input("cuvantul este: ")
# for i in range(len(s)//2 + len(s)%2):
#     print(s[ i : len(s) - i].center(len(s), "."))

# #problema 4
# prop = input("propozitia: ")
# subsir_gresit = input("subsirul gresit este: ")
# subsir_corect = input("se va corecta cu: ")
# new_prop_a = prop.replace(subsir_gresit, subsir_corect)
# print(new_prop_a)
#
# nr_ap = prop.count(subsir_gresit)
# new_prop_b = prop.replace(subsir_gresit, subsir_corect, 2)
# if nr_ap > 2:
#     print ("textul contine prea multe greseli, doar 2 au fost corectate: ", new_prop_b)

#problema 5
# prop = input("Propozitia initiala: ")
# s = input("Cuvantul de inlocuit: ")
# t = input("Sa se inlocuiasca cu: ")
#
# new_sir = prop.split()
#
# for i in range(len(new_sir)):
#     if new_sir[i] == s:
#         new_sir[i] = t
#
# prop_final = " ".join(new_sir)
# print(prop_final)

#problema 6

# sir = input("dati sirul codificat: ")
# cuv = ""
# ultima_lit = 0
# for i in range(len(sir)):
#     l=sir[i]
#     if l.isalpha():
#         cuv = cuv + l * int(sir[ultima_lit:i])
#         ultima_lit = i + 1
# print(cuv)
#
# text = input("dati sirul ce trebuie codificat: ")
# cod = ""
# cnt = 1
# for j in range(1, len(text)):
#     if text[j] != text[j-1]:
#         cod = cod + str(cnt) + text[j-1]
#         cnt = 1
#     else:
#         cnt += 1
# cod = cod + str(cnt) + text[j-1]
# print(cod)

#problema 10
# sir1 = input("primul cuvant: ")
# cop1 = sir1
# sir2 = input("al doilea cuvant: ")
# cop2 = sir2
# sir1 = "".join(sorted(list(sir1)))
# sir2 = "".join(sorted(list(sir2)))
# if sir1 == sir2:
#     print(f"'{cop1}' si '{cop2}' sunt anagrame")
# else:
#     print("nu sunt anagrame")


#problema 7
# p = input("dati fraza: ")
# sum = 0
# for cuvant in p.split():
#     try:
#         val = int(cuvant)
#         sum += val
#     except:
#         pass
# print(f"totalul cheltuielilor este de {sum} RON")


#problema 8

nume_pren = input("numele:").split()
print(nume_pren)

if len(nume_pren) != 2:
    print("Numele nu este corect!")
else:
    for cuv in nume_pren:
        atomi = cuv.split("-")
        if len(atomi) > 2:
            print("Numele nu este corect!")
            break
        else:
            for unit in atomi:
                if len(unit)<3 or unit.istitle() is False:
                    print("Numele nu este corect!")
                    break

    else:
        print("Numele este corect!")


#problema 9
mesaj = input("Dati mesajul:")
cifru = ""
k = int(input("cheia:"))
k = k % 26
for i in range(len(mesaj)):
    if mesaj[i].isalpha() == True:
        if ord("z") - ord(mesaj[i]) < k:
            cifru = cifru + chr( ord("a") +  k - (ord("z") - ord(mesaj[i]) + 1 ))
        else:
            cifru = cifru + chr(ord(mesaj[i])+k)
    else:
        cifru += mesaj[i]


print("Mesajul codat este:", cifru)
#
# cod = input("Dati mesajul codat:")
# decod = ""
# k1 = int(input("cheia:"))
# k1 = k1 % 26
# for i in range(len(cod)):
#     if cod[i].isalpha() == True:
#         if ord(cod[i]) - ord("a") < k1:
#             decod = decod + chr( ord("z") - ( k1 - ord(cod[i]) - ord("a") + 1) )
#         else:
#             decod = decod + chr( ord(cod[i]) - k1)
#     else:
#         decod = decod + cod[i]
# print("Mesajul initial:", decod)

#problema 11a)

# text = input("Dati textul:")
# pasa = ""
# for i in range(len(text)):
#     litera = text[i].lower()
#     if litera == "a" or litera == "e" or litera == "i" or litera == "o" or litera == "u":
#         pasa = pasa + text[i] + "p" + litera
#     else:
#         pasa = pasa + text[i]
# print("In pasareasca:", pasa)
#
# cod = input("Textul in pasareasca:")
# decod = ""
# i = 0
# while i < len(cod):
#     lit_mic = cod[i].lower()
#     if lit_mic == "a" or lit_mic == "e" or lit_mic == "i" or lit_mic == "o" or lit_mic == "u":
#         decod = decod + cod[i]
#         cod = cod[:i + 1] + cod[i + 3:]
#     else:
#         decod += cod[i]
#     i += 1
# print("Text normal:", decod)

#problema 11b)
# text = input("Dati textul:")
# pasa1 = ""
# pasa2 = ""
# cuvinte = text.split()
# for cuv in cuvinte:
#     silabe = cuv.split("-")
#     for i in range(len(silabe)):
#         silabe[i] = silabe[i] + "p" + silabe[i][len(silabe[i])-1]
#     pasa1 = pasa1 + "-".join(silabe) + " "
#     pasa2 = pasa2 + "".join(silabe) + " "
# print("In pasareasca:", pasa1, '\n', pasa2)

