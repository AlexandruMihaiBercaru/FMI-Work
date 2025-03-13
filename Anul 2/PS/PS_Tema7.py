# Tema 7 (Laborator 10)
# Bercaru Alexandru-Mihai
# Grupa 231

import numpy as np
import matplotlib.pyplot as plt
import scipy.stats
import pydataset


# Exercitiul 3
# Setul de date: airquality
# New York Air Quality Measurements

df = pydataset.data('airquality')
df['Solar.R'] = df['Solar.R'].fillna(0) # inlocuiesc valorile NaN cu 0
#df.columns
dnp = df.to_numpy()

X = dnp[:,1].astype('float') # solar radiation
Y = dnp[:,3].astype('float') # tempearature

print(X)
print(Y)

#afisarea setului de date
plt.figure()
plt.plot(X,Y,'.', color = 'C9')
plt.xlabel('solar radiation')
plt.ylabel('temperature')


#covarianta si corelatia
E_XY = np.mean(X * Y)
E_X = np.mean(X)
E_Y = np.mean(Y)

covar = E_XY - E_X * E_Y

stddev_X = np.sqrt(np.mean(X ** 2) - E_X ** 2)
stddev_Y = np.sqrt(np.mean(Y ** 2) - E_Y ** 2)

corel = covar / (stddev_X * stddev_Y)
print(f'Covarianta: {covar}\nCorelatia: {corel}')

# coeficientii regresiei liniare:

alpha1 = covar / (np.mean(X ** 2) - E_X ** 2)
beta1 = E_Y - alpha1 * E_X
print('alpha:',alpha1)
print('beta:',beta1)

# graficul dreptei de regresie + setul de date

x = np.linspace(np.min(X),np.max(X),1000)
plt.plot(x, alpha1 *x + beta1, label = 'Dreapta de regresie', color = 'C3')
plt.legend()


#coeficientii regresiei pe 80% din date

df_80 = df.sample(frac = 0.8)
dnp_80 = df_80.to_numpy()

X_80 = dnp_80[:,1].astype('float') # solar radiation
Y_80 = dnp_80[:,3].astype('float') # tempearature
# regression coeff py
alpha2 = scipy.stats.linregress(X_80,Y_80)[0]
beta2 = scipy.stats.linregress(X_80,Y_80)[1]

print('alpha (80% din date):',alpha2)
print('beta (80% din date):',beta2)

# iau datele care nu au fost utilizate in predictie

df_20 = df.drop(df_80.index)
dnp_20 = df_20.to_numpy()

X_20 = dnp_20[:,1].astype('float') # solar radiation
Y_20 = dnp_20[:,3].astype('float') # tempearature

plt.figure()
plt.plot(X_20,Y_20,'.', color = 'C9')
plt.xlabel('solar radiation (20% of data)')
plt.ylabel('temperature (20% of data)')
x1 = np.linspace(np.min(X_20),np.max(X_20),1000)

plt.plot(x1, alpha2 * x1 + beta2, label = 'Dreapta regresie (80% din date)', color = 'C3')
plt.legend()
plt.show()