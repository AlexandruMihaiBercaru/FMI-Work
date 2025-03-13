import Data.Char

--EXERCITIUL 1 
--a)
verifL :: [Int] -> Bool
verifL l = even(length l)

--b)
takefinal :: [a] -> Int -> [a]
takefinal l nr
    | length l < nr = l
    | otherwise = drop (length l - nr) l
--takefinal [1..8] 5
--takefinal "whei3ehgohg3ogh" 6


--c)
remove :: [a] -> Int -> [a]
remove l n = take n l ++ drop (n+1) l



-- elimina numerele impare si le injumatateste pe cele pare
-- semiPareRec [0,2,1,7,8,56,17,18] == [0,1,4,28,9]
semiPareRec :: [Int] -> [Int]
semiPareRec [] = []
semiPareRec (h:t)
 | even h    = h `div` 2 : t'
 | otherwise = t'
 where t' = semiPareRec t
 

-------------------------------RECURSIVITATE-----------------------------
--EXERCITIUL 2 a)

myReplicate :: Int -> a -> [a]
myReplicate 1 v = [v]
myReplicate n v = v : myReplicate (n-1) v
--myReplicate 5 'a'


--b)
sumImp :: [Int] -> Int
sumImp [] = 0
sumImp (x:xs) 
    | odd x = x + sumImp xs
    | otherwise = sumImp xs 
--sumImp [1..10] == 25


--c)
totalLen :: [String] -> Int
totalLen [] = 0
totalLen (x:xs) 
    | x !! 0 == 'A' = length x + totalLen xs
    | otherwise = totalLen xs



--EXERCITIUL 3
vocaleInCuv :: String -> Int
vocaleInCuv [] = 0
vocaleInCuv (x:xs) 
    | x `elem` "aeiouAEIOU" = 1 + vocaleInCuv xs
    | otherwise = vocaleInCuv xs

nrVocale :: [String] -> Int
nrVocale [] = 0
nrVocale (x:xs) =
    if x == reverse x 
        then vocaleInCuv x + nrVocale xs 
        else nrVocale xs
-- nrVocale ["sos", "civic", "palton", "desen", "aerisirea"] == 9



--EXERCITIUL 4
f :: Int -> [Int] -> [Int]
f n [] = []
f n (x:xs) 
    | even x = x : n : f n xs
    | otherwise = x : f n xs
-- f 3 [1,2,3,4,5,6] = [1,2,3,3,4,3,5,6,3]

--SAU
f' :: Int -> [Int] -> [Int]
f' _ [] = []
f' n l =
    if even (head l) then [head l] ++ [n] ++ f' n (tail l)
    else [head l] ++ f' n (tail l)



--------------------------------DESCRIERI DE LISTE--------------------
semiPareComp :: [Int] -> [Int]
semiPareComp l = [ x `div` 2 | x <- l, even x ]


--EXERCITIUL 5
divizori :: Int -> [Int]
divizori n = [x | x <- [1..n], n `mod` x == 0]
-- divizori 4 == [1,2,4]


--EXERCITIUL 6
listadiv :: [Int] -> [[Int]]
listadiv l = [divizori k |k <- l]
-- listadiv [1,4,6,8] == [[1],[1,2,4],[1,2,3,6],[1,2,4,8]]


--EXERCITIUL 7
inIntervalRec :: Int -> Int -> [Int] -> [Int]
inIntervalRec a b [] = []
inIntervalRec a b (x:xs) = 
    if a <= x && x <= b 
        then x : inIntervalRec a b xs 
        else inIntervalRec a b xs

inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp a b l = [ x | x <- l, a <= x, x <= b]
-- inIntervalRec 5 10 [1..15] == [5,6,7,8,9,10]
-- inIntervalComp 5 10 [1,3,5,2,8,-1] == [5,8]


--EXERCITIUL 8
pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0
pozitiveRec (x:xs) = 
    if x > 0 
        then 1 + pozitiveRec xs
        else pozitiveRec xs

pozitiveComp :: [Int] -> Int
pozitiveComp l = length [ x | x <- l, x > 0]
-- pozitiveComp [0,1,-3,-2,8,-1,6] == 3


--EXERCITIUL 9
--o functie care intoarce lista pozitiilor elementelor impare
--pozCuernt - functie ajutatoare
pozCurent :: [Int] -> Int -> [Int]
pozCurent [] _ = []
pozCurent (x:xs) i 
    | x `mod` 2 == 1 = i : pozCurent xs (i+1)
    | otherwise = pozCurent xs (i+1)
pozitiiImpareRec :: [Int] -> [Int]
pozitiiImpareRec l = pozCurent l 0

pozitiiImpareComp :: [Int] -> [Int]
pozitiiImpareComp l = [i | i <- [0..length l - 1], (l !! i) `mod` 2 == 1]
--sau
--pozitiiImpareComp l = [p | (el, p) <- zip l [0..], el `mod` 2 == 1]


--EXERCITIUL 10
multiDigits :: [Char] -> Int
multiDigits "" = 1
multiDigits (char:chars) 
    | isDigit char = digitToInt char * multiDigits chars
    | otherwise = multiDigits chars
-- multiDigits "The time is 4:25" == 40
-- multiDigits "No digits here!" == 1




--BONUS!
--EXERCITIUL 11
--Scrieti o functie care primeste ca argument o lista si intoarce toate permutarile ei
allPermutations :: Eq a => [a] -> [[a]]
allPermutations [] = [[]]
allPermutations l = [y : ls | y <- l, ls <- allPermutations (rmv l y)]
    where
        rmv [] _ = []
        rmv (x:xs) y 
            | x == y = xs
            | otherwise = x : rmv xs y


--EXERCITIUL 12
--o functie care primeste o lista si un nr intreg k si intoarce toate combinarile de k elemente din lista
allCombinations :: [Int] -> Int -> [[Int]]
allCombinations _ 0 = [[]]
allCombinations [] _ = [[]]
allCombinations (x : xs) k = map (x:) (allCombinations xs (k-1)) ++ allCombinations xs k





--functie care verifica daca un caracter este vocala
--folosim functia elem (=apartenenta)
esteVocala :: Char -> Bool
esteVocala v = v `elem` "aeiouAEIOU"
 