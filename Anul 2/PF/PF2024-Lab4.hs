{-
[x^2 |x <- [1..10], x `rem` 3 == 2] == []
[(x,y) | x <- [1..5], y <- [x..(x+2)]] == [(1, 1), (1, 2), (1, 3), (2, 2), (2, 3), ..., ((5, 7))]
[(x,y) | x <- [1..3], let k = x^2, y <- [1..k]] == [(1,1),(2,1),(2,2),(2,3),(2,4),(3,1),(3,2),(3,3),(3,4),(3,5),(3,6),(3,7),(3,8),(3,9)]
[x | x <- "Facultatea de Matematica si Informatica", elem x ['A'..'Z']] == "FMI"
[[x..y] | x <- [1..5], y <- [1..5], x < y] == [[1,2],[1,2,3],[1,2,3,4],[1,2,3,4,5],[2,3],[2,3,4],[2,3,4,5],[3,4],[3,4,5],[4,5]]
-}


--EX. 2
factori :: Int -> [Int]
factori x = [k | k <- [1..abs x], abs x `mod` k == 0]


--EX. 3
prim :: Int -> Bool
prim n = (length . factori $ n) == 2



--EX. 4
numerePrime :: Int -> [Int]
numerePrime n = [ k | k <- [2..n], prim k]


--EX. 5
myzip3 :: [a] -> [b] -> [c] -> [(a, b, c)]
myzip3 l1 l2 [] = []
myzip3 l1 [] l3 = []
myzip3 [] l2 l3 = []
myzip3 (x1:xs1) (x2:xs2) (x3:xs3) = (x1, x2, x3) : myzip3 xs1 xs2 xs3
--myzip3 [1,2,3] [1,2] [1,2,3,4]

--SAU
--myzip3` :: [a] -> [b] -> [c] -> [(a, b, c)]
--myzip3` l1 l2 l3 = [ (x ,y, z) |((x, y), z) <- zip (zip l1 l2) l3]



--exemple map
--map (\x -> 2 * x) [1..10] == [2,4,6,8,10,12,14,16,18,20]
--map (1 `elem`) [[2,3], [1,2]] == [False,True]
--map (`elem` [2,3]) [1,3,4,5] == [False, True, False, False]


--EX. 6
firstEl :: [(a, b)] -> [a]
firstEl l = map (\(e1, e2) -> e1) l

--firstEl [('a',3),('b',2), ('c',1)]



--EX. 7
sumList :: [[Int]] -> [Int]
sumList = map sum
--sumList [[1,3], [2,4,5], [], [1,3,5,6]]



--EX. 8
prel :: Int -> Int
prel x = if even x then x `div` 2 else 2 * x
prel2 :: [Int] -> [Int]
prel2 = map prel



--EX. 9
containsChar :: Char -> [[Char]] -> [[Char]]
containsChar c  = filter (c `elem`)
--containsChar 'a' ["ana", "nu", "are", "mere"]


--EX. 10
oddSquared :: [Int] -> [Int]
oddSquared = map (^2) . filter odd


--EX. 11
oddPos :: [Int] -> [Int]
oddPos x = undefined
--oddPos l = filter (odd snd x)  zip l [0..]


squareOddPos :: [Int] -> [Int]
squareOddPos l = map (^2) lf
    where lf = map fst (filter (\(elem, index) -> index `mod` 2 == 1) (zip l [0..]))

--squareOddPos [-3, 4, 0, -2, 4, 8, -1, 0, 1, 5]

--EX. 12
numaiVocale :: [[Char]] -> [[Char]]
numaiVocale  = map . filter  $ (`elem` "aeiouAEIOU")
--numaiVocale ["laboratorul", "PrgrAmare", "DEclarativa"]


--EX. 13
myMap :: (a -> b) -> [a] -> [b]
myMap _ [] = []
myMap f (x:xs) =  f x : myMap f xs

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter _ [] = []
myFilter f (x:xs)
    | f x  = x : myFilter f xs
    | otherwise = myFilter f xs 



--Bonus : X si O
step :: Char -> String -> [String]
step 'X' "" = []
step 'X' (c:cs) 
    | c == '_' = [ 'X' : cs ] ++ map ('_' : ) (step 'X' cs)
    | otherwise = map (c :) (step 'X' cs)
step 'O' "" = []
step 'O' (c:cs) 
    | c == '_' = [ 'O' : cs ] ++ map ('_' : ) (step 'O' cs)
    | otherwise = map (c :) (step 'O' cs)

-- p-caracter, cs-lista de configuratii, produce lista tuturor configuratiilor care pot si obtinute din cs si p 
-- folosind functia step
next :: Char -> [String] -> [String]
next p [] = []
--next p (config : configs) = step p config ++ next p configs
next p cs = concat $ map (step p) cs








ordonataNat :: [Int] -> Bool
ordonataNat [] = True
ordonataNat [x] = True
ordonataNat (x:xs) = undefined
ordonata :: [a] -> (a -> a -> Bool) -> Bool
ordonata = undefined
