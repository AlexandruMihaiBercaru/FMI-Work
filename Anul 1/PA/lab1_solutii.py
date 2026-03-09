#problema 3
# def cmmdc(a, b):
#     while b != 0:
#         rest = a % b
#         a=b
#         b=rest
#     return a
# L1 = int(input("L1="))
# L2 = int(input("L2="))
# nr_placi = (L1 // cmmdc(L1, L2)) * (L2 // cmmdc(L1, L2))
# print("Mesterul are nevoie de ", nr_placi, "de placi de gresie, fiecare avand latura de", cmmdc(L1, L2), "cm")

#problema 4
# n = int(input("n="))
# maxim1 = None
# while n != 0:
#     x = int(input("x="))
#     if maxim1 is None or x > maxim1:
#         maxim2 = maxim1
#         maxim1 = x
#     elif x == maxim1:
#         maxim1 = x
#     elif maxim2 is None or x > maxim2:
#         maxim2 = x
#     n-= 1
# if maxim1 != maxim2 and maxim2 != None:
#     print(maxim1, maxim2)
# else:
#     print("imposibil")

#problema 5
# a = int(input("a="))
# b = int(input("b="))
# c = int(input("c="))
# ecuatie = str(a) + " * x^2 + " + str(b) + " * x + " + str(c) + " = 0"
# delta = b ** 2 - 4 * a * c
# if delta <  0:
#     print("Ecuatia", ecuatie, " nu are nicio radacina reala")
# elif delta == 0:
#     x = -b / (2 * a)
#     print("Ecuatia", ecuatie, " are o singura radacina, x= ", x)
# else:
#     x1 = (-b - delta ** 0.5) / (2 * a)
#     x2 = (-b + delta ** 0.5) / (2 * a)
#     print("Ecuatia", ecuatie, " are doua radacini distincte, x1= ", x1, "si x2= ", x2)

#problema 6
# n = int(input("n= "))
# copie = n
# mare = n % 10
# copie //= 10
# while copie != 0:
#     uc = copie % 10
#     copmare = mare
#     p = 1
#     while uc > copmare % 10 and copmare != 0:
#         p *= 10
#         copmare //= 10
#     if p > 1:
#         rest = mare % p + uc * p
#         mare =(mare // p) * (p * 10) + rest
#     else:
#         mare = mare * 10 + uc
#     copie //= 10
# print("cel mai mare:", mare)
# zerouri = 1
# mic = 0
# while mare % 10 == 0:
#     mare //= 10
#     zerouri *= 10
# mic = mare % 10 * zerouri
# mare //= 10
# while mare != 0:
#     mic = mic * 10 + mare % 10
#     mare //= 10
# print("cel mai mic:", mic)

#problema 7
x = int(input("lungimea initiala a sariturii x= "))
n = int(input("numar referinta n= "))
p = int(input("procent p= "))
m = int(input("nr sarituri m= "))
dist = 0
k = 0
while m != 0:
    if (m >= n):
        dist += n * x
        m -= n
    else:
        dist += m * x
        m =0
    print(dist)
    x = x - (x * p) / 100
    print(x)
print("distanta este:", dist, "cm")
