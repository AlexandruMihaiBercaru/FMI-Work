class NodArbore:
    def __init__(self, _informatie, _parinte=None, _g=0, _h=0):
        self.informatie = _informatie
        self.parinte = _parinte
        self.g = _g
        self.h = _h
        self.f = _g + _h

    def drumRadacina(self):
        # Return the path from the root to the current node
        nod = self
        l = []
        while nod:
            l.append(nod.informatie)
            nod = nod.parinte
        return l[::-1]

    def inDrum(self, infoNod):
        # Check if a node is in the path from the root to the current node
        nod = self
        while nod:
            if nod.informatie == infoNod:
                return True
            nod = nod.parinte
        return False

    def __str__(self):
        return str(self.informatie)

    def __repr__(self):
        # Return a string representation of the node and its path
        sirDrum = "->".join(map(str, self.drumRadacina()))
        return f"{self.informatie}, cost: {self.g}; ({sirDrum})"

        # cost - costul drumuluiefectiv

    def __lt__(self, elem):
        # [...g...=======h=========]
        # [...g.......=====h=======]
        # pentru 2 f-uri egale, o sa o aleg pe cea cu zona necunoscuta mai mica (adica iau cu h-ul mai mic)
        return self.f < elem.f or (self.f == elem.f and self.h < elem.h)


class Graf:
    def __init__(self, _matr, _start, _scopuri, _h):
        self.matr = _matr
        self.start = _start
        self.scopuri = _scopuri
        self.h = _h

    def estimeaza_h(self, informatieNod):  # informatia nodului este indicele
        return self.h[informatieNod]

    def scop(self, informatieNod):
        return informatieNod in self.scopuri

    def succesori(self, nod):
        # Generate successors for a given node
        lSuccesori = []
        for infoSuccesor in range(len(self.matr)):
            conditieMuchie = self.matr[nod.informatie][infoSuccesor] > 0  # este cost -> este muchie
            conditieNotInDrum = not nod.inDrum(infoSuccesor)
            if conditieMuchie and conditieNotInDrum:
                nodNou = NodArbore(infoSuccesor, nod, nod.g + self.matr[nod.informatie][infoSuccesor],
                                   self.estimeaza_h(infoSuccesor))
                lSuccesori.append(nodNou)
        return lSuccesori


def aStarSolMultiple(gr, nsol):
    # Breadth-First Search algorithm
    coada = [NodArbore(gr.start)]
    while coada:
        nodCurent = coada.pop(0)
        if gr.scop(nodCurent.informatie):
            print("Solutie: ", end="")
            print(repr(nodCurent))
            nsol -= 1
            if nsol == 0:
                return
        coada += gr.succesori(nodCurent)
        coada.sort()


# doar drumul de cost minim
def aStar(gr):
    OPEN = [NodArbore(gr.start)]
    CLOSED = []
    while OPEN:
        nodCurent = OPEN.pop(0)
        CLOSED.append(nodCurent)
        if gr.scop(nodCurent.informatie):
            print("Solutie: ", end="")
            print(repr(nodCurent))
            return
        lSuccesori = gr.succesori(nodCurent)
        gasitOPEN = False
        for s in lSuccesori:
            for nod in OPEN:
                if s.informatie == nod.informatie:
                    gasitOPEN = True
                    if s < nod:
                        OPEN.remove(nod)
                    else:
                        lSuccesori.remove(s)
                    break
            if not gasitOPEN:
                for nod in CLOSED:
                    if s.informatie == nod.informatie:
                        if s < nod:
                            CLOSED.remove(nod)
                        else:
                            lSuccesori.remove(s)
                        break
        OPEN += lSuccesori
        OPEN.sort()
    print("Nu are solutii")


m = [
    [0, 3, 5, 10, 0, 0, 100],
    [0, 0, 0, 4, 0, 0, 0],
    [0, 0, 0, 4, 9, 3, 0],
    [0, 3, 0, 0, 2, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 4, 0, 5],
    [0, 0, 3, 0, 0, 0, 0],
]
start = 0
scopuri = [4, 6]
h = [0, 1, 6, 2, 0, 3, 0]

gr = Graf(m, start, scopuri, h)
# BF(gr, 4)
# aStarSolMultiple(gr, 7)
aStar(gr)
