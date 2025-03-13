# Tema Laborator 6 Probabilitati si Statistica
# Bercaru Alexandru Mihai
# Grupa 231

from scipy.stats import binom
from scipy.stats import geom 



# Exercitiul 3
# Institutul National de Hidrologie a efectuat masuratori si a inregistrat intr-un an, in medie,
# 35 de furtuni puternice in bazinul hidrografic al raului Olt.
# Se cunoaste faptul ca probabilitatea ca Oltul sa se reverse la o furtuna puternica este 
# de 20%. Sa se determine probailitatea ca intr-un an, Oltul sa cauzeze 
# cel putin 5 inundatii (sa aiba loc cel putin 5 revasari).

n = 35
p = 0.2
k = 5
probab = 0

for i in range (k, n+1):
    probab = probab + binom.pmf(i, n, p)
print (f'Probabiliatea a cel putin 5 inundatii este: {round(probab, 6)}')



# Exercitiul 6
# Gigel asteapta tramvaiul in statie, pe o linie pe care circula vehicule din doua generatii:
# Probabilitatea ca primul tramvai care apare sa fie din generatia noua este de 40%.
# Determinati probabilitatea ca primul tramvai nou sa vina in statie dupa 3 tramvaie vechi

# k = numarul de incercari pana la primul succes 
k = 4
# p = probabilitatea de succes intr-o proba Bernoulli 
p = 0.4

probab = geom.pmf(k, p)
print(f'Probabilitatea ca primul tramvai nou sa apara dupa 3 tramvaie vechi este {round(probab, 6)}') 