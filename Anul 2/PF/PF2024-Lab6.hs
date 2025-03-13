data Fruct = Mar String Bool | Portocala String Int
    deriving Show
--tip de date algebric (suma de produse)

ionatanFaraVierme = Mar "Ionatan" False
goldenCuVierme = Mar "Golden Delicious" True
portocalaSicilia10 = Portocala "Sanguinello" 10
listaFructe = [Mar "Ionatan" False,
                Portocala "Sanguinello" 10,
                Portocala "Valencia" 22,
                Mar "Golden Delicious" True,
                Portocala "Sanguinello" 15,
                Portocala "Moro" 12,
                Portocala "Tarocco" 3,
                Portocala "Moro" 12,
                Portocala "Valencia" 2,
                Mar "Golden Delicious" False,
                Mar "Golden" False,
                Mar "Golden" True]


--EXERCITIUL 1a)
ePortocalaDeSicilia :: Fruct -> Bool
ePortocalaDeSicilia (Portocala s i) = s `elem` ["Tarocco", "Moro", "Sanguinello"]
--ePortocalaDeSicilia (Mar s b) = False
ePortocalaDeSicilia _ = False




test_ePortocalaDeSicilia1 = 
    ePortocalaDeSicilia (Portocala "Moro" 12) == True

test_ePortocalaDeSicilia2 =
    ePortocalaDeSicilia (Mar "Ionatan" True) == False


--EXERCITIUL 1b)
--numarul total de felii ale portocalelor de sicilia dintr-o lista de fructe
nrFeliiSicilia :: [Fruct] -> Int
nrFeliiSicilia fruits = 
    sum[ nr_felii | Portocala tip nr_felii <- fruits, ePortocalaDeSicilia(Portocala tip nr_felii) == True]

test_nrFeliiSicilia = nrFeliiSicilia listaFructe == 52


--EXERCITIUL 1c)
--numarul de mere care au viermi dintr-o lista de fructe
nrMereViermi :: [Fruct] -> Int
nrMereViermi [] = 0
nrMereViermi ((Mar _ True):fructe) = 1 + nrMereViermi fructe 
nrMereViermi ( _ : fructe) = nrMereViermi fructe 

test_nrMereViermi = nrMereViermi listaFructe == 2



--redenumiri(aliasuri)
type NumeA = String
type Rasa = String
data Animal = Pisica NumeA | Caine NumeA Rasa
    deriving Show

--EXERCITIUL 2a)
vorbeste :: Animal -> String
vorbeste (Pisica nume) = "Meow!"
vorbeste (Caine nume rasa) = "Woof!"

-- vorbeste (Pisica "Mimi")
-- vorbeste (Caine "Azorel" "Husky")

--EXERCITIUL 2b)
-- intoarce rasa unui caine sau Nothing daca animalul este pisica
rasa :: Animal -> Maybe String
rasa animal = case animal of 
                (Pisica _) -> Nothing
                (Caine _ rasa) -> Just rasa
-- rasa (Caine "Azorel" "Husky")

data Linie = L [Int]
    deriving Show
data Matrice = M [Linie]
    deriving Show


--EXERCITIUL 3a)
--functie care verifica daca suma elementelor de pe fiecare linie este egala cu o valoare data n
--foldr :: (a -> b -> b) -> b -> [a] -> b
transformLinie :: Linie -> [Int]
transformLinie (L []) = []
transformLinie (L (x:xs)) = x : transformLinie (L xs)
transformMatrice :: Matrice -> [[Int]]
transformMatrice (M []) = []
transformMatrice (M (l:ls)) = transformLinie l : transformMatrice (M ls)
--verifica matrix suma = foldr (\lista val -> val && (sum lista == suma)) True (transformMatrice matrix) 

verifica :: Matrice -> Int -> Bool
verifica (M mat) suma = foldr (&&) True (map (\ (L l) -> (sum l) == suma) mat)
--test_verif1 = verifica (M[L[1,2,3], L[4,5], L[2,3,6,8], L[8,5,3]]) 10 == False
--test_verif2 = verifica (M[L[2,20,3], L[4,21], L[2,3,6,8,6], L[8,5,3,9]]) 25 == True


--EXERCITIUL 3b)
doarPozN :: Matrice -> Int -> Bool
doarPozN (M mat) lungime = 
    foldr (&&) True (map (\ (L l1) -> allPos l1) (filter (\ (L l) -> length l == lungime) mat))
    where allPos = foldr (\ x val -> val && (x > 0)) True 

--testPoz1 = doarPozN (M [L[1,2,3], L[4,5], L[2,3,6,8], L[8,5,3]]) 3 == True
--testPoz2 = doarPozN (M [L[1,2,-3], L[4,5], L[2,3,6,8], L[8,5,3]]) 3 == False


--EXERCITIUL 3c)
corect :: Matrice -> Bool
corect (M []) = True
corect (M [L elems1]) = True
corect (M ((L elems1) : (L elems2) : ls)) 
    | length elems1 == length elems2 = True && corect (M ((L elems2) : ls))
    | otherwise = False



testcorect1 = corect (M[L[1,2,3], L[4,5], L[2,3,6,8], L[8,5,3]]) == False
testcorect2 = corect (M[L[1,2,3], L[4,5,8], L[3,6,8], L[8,5,3]]) == True
