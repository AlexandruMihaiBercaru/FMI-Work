class NodArbore:
    def __init__(self, _informatie, _parinte=None):
        self.informatie = _informatie
        self.parinte = _parinte

    def drumRadacina(self):
        nod = self
        l = []
        while nod:
            l.append(nod)
            nod = nod.parinte
        return l[::-1]  # lista inversata

    # dacă informația se mai găsește în istoricul (drumul) nodului curent, returnăm True
    def inDrum(self, infoNod):
        nod = self
        while nod:
            if nod.informatie == infoNod:
                return True
            nod = nod.parinte
        return False

    def __str__(self):
        return str(self.informatie)

    # c (a->b->c)
    def __repr__(self):
        sirDrum = "->".join([str(x) for x in self.drumRadacina()])
        return f"{self.informatie}, ({sirDrum})"


class Graf:
    def __init__(self, _matr, _start, _scopuri):
        self.matr = _matr
        self.start = _start
        self.scopuri = _scopuri

    def scop(self, informatieNod):
        return informatieNod in self.scopuri

    # generarea arobrelui de cautare
    def succesori(self, nod):
        lSuccesori = []
        for infoSuccesor in range(len(self.matr)):
            conditieMuchie = self.matr[nod.informatie][infoSuccesor] == 1
            conditieNotInDrum = (NodArbore.inDrum(nod, infoSuccesor) is False)
            if conditieMuchie and conditieNotInDrum:
                nodNou = NodArbore(_informatie=infoSuccesor, _parinte=nod)
                lSuccesori.append(nodNou)
        return lSuccesori


m = [
    [0, 1, 0, 1, 1, 0, 0, 0, 0, 0],
    [1, 0, 1, 0, 0, 1, 0, 0, 0, 0],
    [0, 1, 0, 0, 0, 1, 0, 1, 0, 0],
    [1, 0, 0, 0, 0, 0, 1, 0, 0, 0],
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0],
    [0, 1, 1, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
    [0, 0, 1, 0, 1, 0, 0, 0, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 1, 0, 0]
]


def BF(gr, nsol):
    coada = [NodArbore(_informatie=gr.start, _parinte=None)]
    while coada:
        print(coada)
        nodCurent = coada.pop(0)
        if gr.scop(nodCurent.informatie):
            print("Solutie: ", end="")
            print(repr(nodCurent))
            nsol -= 1
            if nsol == 0:
                return 0
        coada += gr.succesori(nodCurent)


# EXERCITIUL 4
def depth_first(gr, nsol=1):
    # vom simula o stiva prin relatia de parinte a nodului curent
    DF(NodArbore(gr.start), nsol)


def DF(nodCurent, nsol):
    if nsol <= 0:
        return nsol
    print("Stiva actuala: " + repr(nodCurent.drumRadacina()))

    if gr.scop(nodCurent.informatie):
        print("Solutie: ", end="")
        print(repr(nodCurent))
        print("\n----------------\n")
        nsol -= 1
        if nsol == 0:
            return 0
    lSuccesori = gr.succesori(nodCurent)
    for sc in lSuccesori:
        if nsol != 0:
            nsol = DF(sc, nsol)

    return nsol


# EXERCITIUL 5 : Depth-First nerecursiv
# idee: simulam stiva cu o lista
def depth_first_nerec(gr, nsol):
    stiva = [NodArbore(_informatie=gr.start, _parinte=None)]
    while stiva:
        nodCurent = stiva.pop()
        if gr.scop(nodCurent.informatie):
            print("Solutie: ", end="")
            print(repr(nodCurent))
            nsol -= 1
            if nsol == 0:
                return 0
        stiva += gr.succesori(nodCurent)[::-1]
    return 0


# EXERCITIUL 6
def BF2(gr, nsol):
    coada = [NodArbore(_informatie=gr.start, _parinte=None)]
    while coada:
        print(coada)
        nodCurent = coada.pop(0)
        if gr.scop(nodCurent.informatie):
            print("Solutie: ", end="")
            print(repr(nodCurent))
            nsol -= 1
            if nsol == 0:
                return 0
        list_succ = gr.succesori(nodCurent)
        print(f'SUCCESORII LUI {nodCurent}: {list_succ}')
        for sc in list_succ:
            if int(sc.informatie) in scopuri:
                list_succ.remove(sc)
                print("Solutie: ", end="")
                print(repr(sc))
                print("\n")
                nsol -= 1
                if nsol == 0:
                    return 0
        coada += list_succ


start = 0
scopuri = [5, 9]
gr = Graf(m, start, scopuri)

#BF(gr, nsol=4)
#print("\n\n")

#depth_first(gr, nsol=4)
# print("\n\n")

depth_first_nerec(gr, nsol=4)
#print("\n\n")

#BF2(gr, nsol=3)
# depth_first_nerec(gr, nsol=5)
