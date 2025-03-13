# Tema Laborator 7 Probabilitati si Statistica
# Bercaru Alexandru Mihai
# Grupa 231


import scipy.stats


# Exercitiul 3

# Intr-un interval de 3 luni, serverul de baze de date al FMI pica, in medie, de 2 ori.
# Determinati probabilitatea ca, in intervalul 1 decembrie 2024 - 28 februarie 2025,
# serverul sa pice de cel putin 4 ori.

# lambda = numarul mediu de defectiuni ale serverului (= 2)
# X - "a picat serverul facultatii"
# P(X >= 4) = 1 - P(X <= 3)

lmbd = 2
probab = 1 - scipy.stats.poisson.cdf(3, lmbd)
print(f"Probabilitatea ca serverul sa pice de cel putin 4 ori este {round(probab, 6)}\n")


# Exercitiul 6

# In Romania, cutremurele cu o magnitudine de minim 7.0 pe scara Richter au loc, in medie,
# o data la 40 de ani. Stiind ca ultimul cutremur de o asemenea magnitudine a avut loc
# in 1977, sa se determine probabilitatea sa aiba loc un astfel de cutremur in urmatorii 3 ani.

# timpul de asteptare mediu : 1 / lambda = 40 => lambda = 1 / 40
# X ~ exp(1/40)
# din 1977 pana in 2024 au trecut 47 de ani
# calculez P(47 <= X <= 50), unde X = "are loc un cutremur de magnitudine 7.0 sau mai mare"
# P(47 <= X <= 50) = F(50) - F(47), unde F = functia de repartitie (cdf)

probab = scipy.stats.expon.cdf(50, loc = 0, scale = 40) - scipy.stats.expon.cdf(47, loc = 0, scale = 40)
print(f'Probabilitatea unui cutremur mare in urmatorii 3 ani este {round(probab, 6)}')