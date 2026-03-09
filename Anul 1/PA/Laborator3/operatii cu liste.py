# l1 = [1, 2, 3, 4, 5]
# l2 = [6, 7, 8, 9, 10]
# l1[::2] = l2[::2]
# print(l1)

#2
# L = [5, 6, 0, 3, 2, 0, 12, -54, 6, 0, 0, 9]
# if L.count(0) >= 2:
#     poz = L.index(0)
#     del L[poz]
#     pozfinal = L.index(0)
#     L[poz:pozfinal+1] = []
# print(L)

#3
# L1 = [5, 6, 0, 3, 2, 0, 12, 6, 0, 0, 9]
#
# while min(L1)==0:
#     del L1[L1.index(0)]
# print(L1)


#4
# L = [-5, 1, 9, -10, 2, 4, 8, -4, -5, 18, 6, 2]
# k = 3
# sum_min = None
# index_st = None
# index_dr = None
# for i in range(len(L) - k + 1):
#     suma = sum(L[i:i+k])
#     if sum_min is None:
#         sum_min = suma
#     elif suma < sum_min:
#         sum_min = suma
#         index_st = i
#         index_dr = i+k-1
# L[index_st : index_dr + 1] = []
# print(L)

#5
v = [1, 2, 3, 3, 5, 5, 6, 6, 7, 7, 8, 12, 12]
for i in range(len(v)):
    if v[i] in v[:i]:
        del v[i]
        i -= 1
print(v)
#6 inputul : -1.5 12.66 3 -14 0 -9.8 -8.9 16 3.44 -1
# L = [float(x) for x in input("dati numerele:").split()]
# print(L)
# for index in range(len(L)-1):
#     if L[index] < 0:
#         L.insert(index + 1, 0)
#         index += 1
# if L[len(L)-1] < 0:
#     L.append(0)
# print(L)
