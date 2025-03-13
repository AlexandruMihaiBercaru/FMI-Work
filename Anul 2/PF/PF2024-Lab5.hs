import Data.Char
--foldr si foldl

--foldr :: (a -> b -> b) -> b -> [a] -> b
--foldr op i [] = i
--foldr op i (x:xs) = x `op` (foldr op i xs)

{-
    foldr op unit [a1, a2, a3, ... , an] = a1 `op` (a2 `op` (a3 `op` .. `op` (an `op` unit)))

    foldr op i [] = i
    foldr op i (x:xs) = x `op` (foldr op i xs)


    foldl op unit [a1, a2, a3, ... , an] = (.. (((unit `op` a1) `op` a2) `op` a3) `op` ..) `op` an
-}


--EXERCITIUL 1
--suma patratelor elementelor impare dintr-o lista
oddSumSq :: [Int] -> Int
oddSumSq l = foldr (+) 0 (map (^2) (filter odd l)) 
--aici mergea si cu foldl (pt ca aduncarea numerelor naturale este asociativa)




--EXERCITIUL 2
--o functie care verifica daca toate elementele dintr-o lista sunt true
allTrue :: [Bool] -> Bool
allTrue l = foldr (&&) True l




--EXERCITIUL 3
--o functie care verifica daca toate elementele dintr-o lista de intregi satisfac o proprietate
allVerifies :: (Int -> Bool) -> [Int] -> Bool
allVerifies p list = foldr (\x acc -> acc && p x) True list
--allVerifies p list = foldl (\acc x -> acc && p x) True list



--EXERCITIUL 4
--o functie care verifica daca exista elemente intr-o lista de intregi care satisfac o proprietate
anyVerifies :: (Int -> Bool) -> [Int] -> Bool
anyVerifies p l = foldr (\x val -> val || p x) False l




--EXERCITIUL 5
--redefinire map si filter folosind foldr
--foldr :: (a -> b -> b) -> b -> [a] -> b
mapFoldr :: (a -> b) -> [a] -> [b]
mapFoldr func l = foldr (\elem var -> func elem : var) [] l

filterFoldr :: (a -> Bool) -> [a] -> [a]
filterFoldr pred l = foldr (\elem var ->
                            if pred elem
                                then elem : var
                                else var) [] l 




--EXERCITIUL 6
--transforma o lista de cifre in numarul intreg asociat
listToInt :: [Integer]-> Integer
listToInt l = foldl (\nrcrt x -> nrcrt * 10 + x) 0 l
--listToInt [2,3,4,5] = 2345




--EXERCITIUL 7a)
--elimina aparitiile unui caracter dat dintr-un sir de cuvinte
rmChar :: Char -> String -> String
rmChar ch cuv = filter (/= ch) cuv


--EXERCITIUL 7b)
--elimina toate caracterele din al doilea argument, care se gasesc in primul argument (recursiv, folosind rmChar)
rmCharsRec :: String -> String -> String
rmCharsRec "" s = s
rmCharsRec (c:cs) cuv = rmCharsRec cs (rmChar c cuv)



--EXERCITIUL 7c)
--echivalent cu 7b) doar ca foloseste foldr
--foldr :: (a -> b -> b) -> b -> [a] -> b
rmCharsFold :: String -> String -> String
rmCharsFold cs cuv = foldr (\c acc -> rmChar c acc ) cuv cs
--rmCharsFold cs cuv = foldr rmChar cuv cs



--EXERCITIUL 8
myReverse :: [Int] -> [Int]
myReverse l = foldl (flip (:)) [] l  
--adauga elementele la inceputul unei liste create recursiv pornind de la primul element din lista initiala
--e nevoie de flip pentru a putea procesa elementele cu foldl


--EXERCITIUL 9
--verifica apartenenta unui intreg la o lista de intregi
--foldr :: (a -> b -> b) -> b -> [a] -> b
myElem :: Integer -> [Integer] -> Bool
myElem n = foldr (\crt_numb acc -> acc || (crt_numb == n)) False 




--EXERCITIUL 10
--scrieti o functie care transforma o lista de perechi intr o pereche de liste
--una a componentelor de pe prima pozitie, iar cealalta a componentelor de pe a doua pozitie din 
--perechile din lista initiala
myUnzip :: [(a, b)] -> ([a], [b])
myUnzip listofpairs = 
    foldr addToTuple ([], []) listofpairs
    where addToTuple (x,y) current_tuple = (x : fst current_tuple, y : snd current_tuple)

--myUnzip [(1, 'm'), (2, 'e'), (3, 'r'), (4, 'e')]

recreateList :: [a] -> [a]
recreateList l = foldr (:) [] l


--EXERCITIUL 11
--o functie care intoarce lista reuniunii a doua liste de intregi primite ca parametri
union :: [Int] -> [Int] -> [Int]
union l1 l2 = foldr addIfNotElem [] (l1 ++ l2)
    where addIfNotElem x currentList 
            | x `notElem` currentList = x : currentList
            | otherwise = currentList
--union [1, 4, 2, 6, 7] [10, 4, 6, 3, 8, 1]


--EXERCITIUL 12
--o functie care intoarce lista intersectiei a doua liste de intregi date ca parametri
intersect :: [Int] -> [Int] -> [Int]
intersect l1 l2 = foldr addOne [] l2
    where 
        addOne x remainderList
            | x `elem` l1 = x : remainderList
            | otherwise = remainderList
--intersect [1, 4, 2, 6, 7] [10, 4, 6, 3, 8, 1]



--EXERCITIUL 13 (de studiat...)
--o functie care intoarce lista tuturor permutarilor unei liste de intregi primite ca parametru

-- Functie care insereaza un element in toate pozitiile posibile intr-o lista
insertAtAllPositions :: a -> [a] -> [[a]]
insertAtAllPositions x [] = [[x]]
insertAtAllPositions x (y:ys) = (x:y:ys) : map (y:) (insertAtAllPositions x ys)

allPermutations :: [Int] -> [[Int]]
allPermutations l = foldr (\x acc -> foldr (++) [] (map (insertAtAllPositions x) acc)) [[]] l
