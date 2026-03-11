import time


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
        lDrum = self.drumRadacina()
        sirDrum = "->".join([str(x) for x in lDrum])
        # return f"{self.informatie}, ({sirDrum})"

        file = open("output.txt", 'a')

        self.afisSolFisier(file, lDrum)
        file.write('-----------------------------------------------------------------------------\n\n')
        file.close()

        return f"{self.informatie}, Lungime={len(lDrum) - 1}, ({sirDrum})"

    # afisarea formatata
    def afisSolFisier(self, file, drum):
        file.write(
            f'(Stanga: <barca>) {drum[0].informatie[0]} canibali  {drum[0].informatie[1]} misionari  ......  (Dreapta) 0 canibali  0 misionari\n\n')
        for k in range(1, len(drum)):
            nod = drum[k].informatie
            # nod este de forma (nr_canibali_mal_initial (stang), nr_misionari_mal_initial (stang), locatie_barca)

            if nod[2] == 1:  # a plecat de pe malul opus, a ajuns pe malul initial (drept -> stang)
                file.write(
                    f'Barca s-a deplasat de la malul drept la malul stang cu {nod[0] - drum[k - 1].informatie[0]} canibali si {nod[1] - drum[k - 1].informatie[1]} misionari.\n')
                file.write(
                    f'(Stanga: <barca>) {nod[0]} canibali  {nod[1]} misionari  ......  (Dreapta) {Graf.N - nod[0]} canibali  {Graf.N - nod[1]} misionari\n\n')

            else:  # a plecat de pe malul initial, a ajuns pe malul opus (stang -> drept)
                file.write(
                    f'Barca s-a deplasat de la malul stang la malul drept cu {drum[k - 1].informatie[0] - nod[0]} canibali si {drum[k - 1].informatie[1] - nod[1]} misionari.\n')
                file.write(
                    f'(Stanga) {nod[0]} canibali  {nod[1]} misionari  ......  (Dreapta: <barca>) {Graf.N - nod[0]} canibali  {Graf.N - nod[1]} misionari\n\n')


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
                    nodNou = NodArbore(infoSuccesor, nod)
                    lSuccesori.append(nodNou)

        return lSuccesori

    def succesori_opt(self, nod):
        def test_conditie(m, c):
            return m == 0 or m >= c

        # generarea arobrelui de cautare
        lSuccesori = []
        # malul curent = malul de pe care tocmai pleca barca
        canMalCurent = nod.informatie[0] if nod.informatie[2] == 1 else Graf.N - nod.informatie[0]
        misMalCurent = nod.informatie[1] if nod.informatie[2] == 1 else Graf.N - nod.informatie[1]
        for misBarca in range(0, min(Graf.M, misMalCurent) + 1):  # minMisBarca, maxMisBarca
            minCanBarca = 1 if misBarca == 0 else 0
            if nod.informatie[2] == 1:  # de la malul initial (stang) la cel drept
                diff = canMalCurent - (misMalCurent - misBarca)  # diferenta dintre misMalOpusNou si canMalOpus
                # (4, 4) ......... (4, 4), barca pe mal stang
                # daca misBarca = 2 => diff = 2 => canBarca = 2 (daca incap, altfel nu pot trimite)
                # (3, 8) .......... (5, 0), barca pe mal stang
                # daca misBarca = 4 => diff = -1 => nu pot trimite!
                if misBarca != 0:  # trimit in mod egal can si mis
                    maxCanBarca = min(Graf.M - misBarca, diff)
                else:  # misBarca = 0 => pot trimite si doar canibali
                    maxCanBarca = min(Graf.M - misBarca, canMalCurent)
            else:  # trimit inapoi (de la malul drept la cel stang)
                if misBarca == 0:
                    maxCanBarca = 1
                else:
                    maxCanBarca = min(Graf.M - misBarca, canMalCurent)

            for canBarca in range(minCanBarca, maxCanBarca + 1):
                if not test_conditie(misMalCurent - misBarca, canMalCurent - canBarca):
                    continue
                if not test_conditie(Graf.N - misMalCurent + misBarca, Graf.N - canMalCurent + canBarca):
                    continue

                if nod.informatie[2] == 1:  # malul curent e cel initial
                    infoSuccesor = (canMalCurent - canBarca, misMalCurent - misBarca, 0)
                else:  # malul curent este cel final (drept)  => malul opus e cel initial (stang)
                    infoSuccesor = (Graf.N - canMalCurent + canBarca, Graf.N - misMalCurent + misBarca, 1)

                if not nod.inDrum(infoSuccesor):
                    nodNou = NodArbore(infoSuccesor, nod)
                    lSuccesori.append(nodNou)
        return lSuccesori


def BF(gr, nsol):
    coada = [NodArbore(_informatie=gr.start, _parinte=None)]
    while coada:
        nodCurent = coada.pop(0)
        if gr.scop(nodCurent.informatie):
            print("Solutie: ", end="")
            print(repr(nodCurent))
            nsol -= 1
            if nsol == 0:
                return 0
        coada += gr.succesori(nodCurent)


def BF_opt(gr, nsol):
    coada = [NodArbore(_informatie=gr.start, _parinte=None)]
    while coada:
        nodCurent = coada.pop(0)
        if gr.scop(nodCurent.informatie):
            print("Solutie: ", end="")
            print(repr(nodCurent))
            nsol -= 1
            if nsol == 0:
                return 0
        coada += gr.succesori_opt(nodCurent)


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

start = time.time()
BF(gr, 1)
end = time.time()

print("Fara optimizari :", (end - start), "ms")
print('\n\n\n')

start = time.time()
BF_opt(gr, 1)
end = time.time()

print("Cu optimizari :", (end - start), "ms")

# pentru N = 4 si M = 5, primele 2 solutii au lungime 3, a treia solutie are lungime 5
