#inlocuiti fiecare comentariu TODO

class NodArbore:
    def __init__(self, _informatie, _parinte=None):
        self.informatie = _informatie
        self.parinte = _parinte

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
        lDrum = self.drumRadacina()
        sirDrum = "->".join(map(str, lDrum))
        return f"{self.informatie}, Lungime={len(lDrum) - 1}, ({sirDrum})"

class Graf:
    def __init__(self, _start, _scopuri):
        self.start = _start
        self.scopuri = _scopuri

    def scop(self, informatieNod):
        # Check if a node is a goal node
        return informatieNod in self.scopuri

    def succesori(self, nod):

        def test_conditie(m, c):
            return m == 0 or m >= c


        # Generate successors for a given node
        lSuccesori = []
        # malul curent = malul de pe care tocmai pleca barca
        if nod.informatie[2] == 1:
            canMalCurent = nod.informatie[0]
            misMalCurent = nod.informatie[1]
            canMalOpus = Graf.N - canMalCurent
            misMalOpus = Graf.N - misMalCurent
        else:
            canMalOpus = nod.informatie[0]
            misMalOpus = nod.informatie[1]
            canMalCurent = Graf.N - nod.informatie[0]
            misMalCurent = Graf.N - nod.informatie[1]

        maxMisBarca = min(Graf.M, misMalCurent)
        minMisBarca = 0
        for misBarca in range(minMisBarca, maxMisBarca + 1):
            if misBarca == 0:
                minCanBarca = 1
                maxCanBarca = min(Graf.M, canMalCurent)
            else:
                minCanBarca = 0
                maxCanBarca = min(Graf.M - misBarca, canMalCurent, misBarca)
            for canBarca in range(minCanBarca, maxCanBarca + 1):
                canMalCurentNou = canMalCurent - canBarca
                misMalCurentNou = misMalCurent - misBarca

                canMalOpusNou = canMalOpus + canBarca
                misMalOpusNou = misMalOpus + misBarca

                if not test_conditie(misMalCurentNou, canMalCurentNou):
                    continue
                if not test_conditie(misMalOpusNou, canMalOpusNou):
                    continue

                if nod.informatie[2] == 1: #malul curent e cel initial
                    infoSuccesor = (canMalCurentNou, misMalCurentNou, 0)
                else: # malul curent este cel final => malul opus e cel initial
                    infoSuccesor = (canMalOpusNou, misMalOpusNou, 1)


                if not nod.inDrum(infoSuccesor):
                    nodNou = NodArbore(infoSuccesor, nod)
                    lSuccesori.append(nodNou)
        return lSuccesori



def BF(gr, nsol):
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

def depth_first(gr, nsol=1):
    # Depth-First Search algorithm
    return DF(NodArbore(gr.start), nsol)

def DF(nodCurent, nsol):
    # Recursive Depth-First Search helper function
    if nsol <= 0:
        return nsol

    if gr.scop(nodCurent.informatie):
        print("Solutie: ", end="")
        print(repr(nodCurent))
        print("\n----------------\n")
        nsol -= 1
        if nsol == 0:
            return nsol

    lSuccesori = gr.succesori(nodCurent)
    for sc in lSuccesori:
        if nsol != 0:
            nsol = DF(sc, nsol)

    return nsol


def DF_Non_Recursive(gr, nsol):
    # Non-Recursive Depth-First Search algorithm
    stack = [NodArbore(gr.start)]
    while stack:
        nodCurent = stack.pop()
        if gr.scop(nodCurent.informatie):
            print("Solutie: ", end="")
            print(repr(nodCurent))
            nsol -= 1
            if nsol == 0:
                return
        stack.extend(gr.succesori(nodCurent)[::-1])

# f = open("input.txt", 'r')
# continut = f.read().split()
# f.close()
Graf.N = 3
Graf.M = 2
# stare = (nr_canibali_mal_initial, nr_misionari_mal_initial, locatie_barca)
# locatie_barca = 1 (mal initial); 0 (mal, final)
start = (Graf.N, Graf.N, 1)
scopuri = [(0,0,0)]
gr = Graf(start, scopuri)
BF(gr, 1)
# depth_first(gr, 4)
#DF_Non_Recursive(gr, 4)