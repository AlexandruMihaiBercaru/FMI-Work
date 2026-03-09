#sortari liste
#a)

# L = [12, 43, 5, 7, 9, 11, 10]
# print(sorted(L, key = lambda x : str(x)))

#sau : print(lista := sorted(L, key = lambda x : str(x)))


#b)
# L = [17, 43, 5, 7, 9, 11, 10, 124, 4079]
# print(sorted(L, key = lambda x : str(x)[::-1]))
#c)
# print(sorted(L, key = lambda x : len(str(x)), reverse=True))

L = [443, 6657, 222224, 9060609, 5534355, 1010101, 55, 3247, 542]

#d)
print(sorted(L, key = lambda x : len(set(str(x)))))

#e)
print(sorted(L, key = lambda x : (len(str(x)), x)))
#doua criterii de sortare - al doilea face departajarea

