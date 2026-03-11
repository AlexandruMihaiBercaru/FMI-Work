import copy


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
        minH = float("inf")
        for scop in self.scopuri:
            h = 0
            for iScop, stivaScop in enumerate(scop):
                for iBloc, bloc in enumerate(stivaScop):
                    try:
                        if bloc != informatieNod[iScop][iBloc]:
                            h += 1
                    except:
                        h += 1
            if h < minH:
                minH = h
        return minH

    def succesori(self, nod):
        # generarea arobrelui de cautare
        lSuccesori = []
        for i, iStiva in enumerate(nod.informatie):
            if not iStiva:  # daca iStiva (stiva curenta) este vida)
                continue
            copieStive = copy.deepcopy(nod.informatie)
            bloc = copieStive[i].pop()
            for j, jStiva in enumerate(copieStive):
                if i == j:
                    continue
                infoSuccesor = copy.deepcopy(copieStive)  # daca as modifica o stiva, ar aparea in orice alt succesor
                infoSuccesor[j].append(bloc)

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


def obtineStive(sirStive):  # ["a", "c b", "d"] => [[a], [c, b], [d]]
    return [sir.strip().split() if sir != '#' else [] for sir in sirStive.strip().split("\n")]


f = open('blocuri.txt', 'r')
sirStart, sirScopuri = f.read().split("=========")
f.close()
start = obtineStive(sirStart)
scopuri = [obtineStive(sirScop) for sirScop in sirScopuri.split("---")]
print(start)
print(scopuri)
gr = Graf(start, scopuri)

aStar(gr)


# ex. 5 (II - seminar)
# euristica admisibila: h(nod) = c_min, sau 0 daca este nod
# 7
# da, pentru euristica conteaza doar scopul
# 8
# iau estimatia care se apropie cel mai mult de costul real => max(h1, h2, h3)
# 9
# h = 0 pentru nodurile scop, pentru celelalte noduri h(nod) = min(hi(nod))
