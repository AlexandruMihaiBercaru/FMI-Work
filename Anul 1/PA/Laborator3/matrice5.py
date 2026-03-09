
L1 = [int(x) for x in input("prima multime:").split()]
L2 = [int(y) for y in input("a doua multime").split()]
Reun = [el for el in L1]
for x in L2:
    if x not in Reun:
        Reun.append(x)
Inter = []
for x in L1:
    if x in L2:
        Inter.append(x)

