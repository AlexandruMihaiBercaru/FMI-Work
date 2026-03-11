import math
import time
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
    def __init__(self, _start, _scopuri):
        self.start = _start
        self.scopuri = _scopuri

    def scop(self, informatieNod):
        # Check if a node is a goal node
        return informatieNod in self.scopuri

    def estimeaza_h(self, informatieNod):  # informatia nodului este indicele
        if informatieNod[2] == 1:  # mal initial
            return math.ceil(2 * (informatieNod[0] + informatieNod[1]) / (Graf.M - 1)) - 1
        else:
            return math.ceil(2 * (informatieNod[0] + informatieNod[1]) / (Graf.M - 1))

    def succesori(self, nod):
        def test_conditie(m, c):
            return m == 0 or m >= c

        # generarea arobrelui de cautare
        lSuccesori = []
        # malul curent = malul de pe care tocmai pleca barca
        if nod.informatie[2] == 1:  # e pe malul initial
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

                if nod.informatie[2] == 1:  # malul curent e cel initial
                    infoSuccesor = (canMalCurentNou, misMalCurentNou, 0)
                else:  # malul curent este cel final => malul opus e cel initial
                    infoSuccesor = (canMalOpusNou, misMalOpusNou, 1)

                if not nod.inDrum(infoSuccesor):
                    nodNou = NodArbore(infoSuccesor, nod, nod.g + 1, self.estimeaza_h(infoSuccesor))
                    lSuccesori.append(nodNou)

        return lSuccesori


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


f = open('input.txt', 'r')
continut = f.read().split()
f.close()
Graf.N = int(continut[0])
Graf.M = int(continut[1])

# stare = (nr_canibali_mal_initial, nr_misionari_mal_initial, locatie_barca)
# locatie_barca = {1 (mal initial), 0 (mal final)}

start = (Graf.N, Graf.N, 1)  # initial toti canibalii si toti misionarii sunt pe malul initial, barca se afla pe malul opus
scopuri = [(0, 0, 0)]  # toti misionarii si toti canibalii au fost transportati pe malul opus, barca se afla pe malul opus
gr = Graf(start, scopuri)

aStar(gr)
