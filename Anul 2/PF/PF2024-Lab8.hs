-- c, key, value sunt tipuri de date

-- Collection : clasa de tipuri (interfata in lb. OOP)
class Collection c where
  empty :: c key value -- colectie vida
  singleton :: key -> value -> c key value -- colectie cu un element
  insert :: Ord key => key -> value -> c key value -> c key value -- adaugare / actualizare element
  clookup :: Ord key => key -> c key value -> Maybe value -- cautarea unui element intr-o colectie 
  delete :: Ord key => key -> c key value -> c key value -- stergerea unui element din colectie
  keys :: c key value -> [key]
  values :: c key value -> [value]
  toList :: c key value -> [(key, value)] -- primeste un obiect
  fromList :: Ord key => [(key,value)] -> c key value

------------------------EXERCITIUL 1------------------------
-- adaugam definitii implicite pentru keys, values, fromList (folosind celelalte functii din clasa)
  keys c = [fst p | p <- toList c]
  values c = [snd p | p <- toList c]
  fromList [] = empty -- daca lista este vida, trebuie sa obtin o colectie vida
  fromList (p:ps) = insert (fst p) (snd p) (fromList ps) -- recursiv, inserez capul listei 


-- tipul de date record
newtype PairList k v = PairList { getPairList :: [(k, v)] }


------------------------EXERCTIUL 2------------------------
--instanta pentru tipul Pairlist
instance Collection PairList where
  empty = PairList []
  singleton k v = PairList [(k, v)]
  insert k v (PairList l) = PairList $ (k, v) : filter ((/= k) . fst) l
  toList = getPairList
  clookup k = lookup k . getPairList 
  delete k (PairList l) = PairList $ filter ((/= k) . fst) l


-- Tipul BST, neechilibrati, cu chei de tip oarecare
data SearchTree key value
  = Empty
  | BNode
      (SearchTree key value) -- elemente cu cheia mai mica
      key                    -- cheia elementului
      (Maybe value)          -- valoarea elementului
      (SearchTree key value) -- elemente cu cheia mai mare


-- EXERCITIUL 3: Faceti SearchTree sa fie instanta a clasei Collection
instance Collection SearchTree where
  empty = Empty -- constructorul de date din definitia tipului SearchTree, pentru cazul "arbore vid" (este tot o functie)
  singleton k v = BNode Empty k (Just v) Empty -- constructorul de date din definitia tipului SearchTree, pentru cazul nevid
  insert = insertST
    where 
      insertST k val Empty = BNode Empty k (Just val) Empty
      insertST k val (BNode l key v r) 
        | k == key = BNode l key (Just val) r
        | k < key = BNode (insertST k val l) key v r
        | k > key = BNode l key v (insertST k val r)
  toList = toListST
    where
      toListST Empty = []
      toListST (BNode l k v r) = case v of
                                    Nothing -> toListST l ++ toListST r
                                    Just val -> toListST l ++ [(k, val)] ++ toListST r
  clookup = lookupST
    where
      lookupST _ Empty = Nothing
      lookupST n (BNode l key val r) 
        | n == key = val
        | n < key = lookupST n l
        | otherwise = lookupST n r  
  delete = deleteST
    where
      deleteST _ Empty = Empty
      deleteST key (BNode l k v r)
        | key == k = BNode l k Nothing r
        | key < k = BNode (deleteST key l) k v r
        | key > k = BNode l k v (deleteST key r)
  keys Empty = []
  keys (BNode l key v r) = keys l ++ [key] ++ keys r



--PENTRU TESTARE
exampleTree :: SearchTree Int String
exampleTree =
  BNode
    (BNode Empty 1 (Just "A") Empty)  -- Subarbore stang: cheia 1 -> "A"
    3 (Just "B")                     -- Radacina: cheia 3 -> "B"
    (BNode Empty 5 Nothing Empty)    -- Subarbore drept: cheia 5 -> Nothing (sters)
example2 = insert 2 "C" exampleTree 
example3  = delete 3 exampleTree


--Puncte Puncte
data Punct = Pt [Int]
data Arb = Vid | F Int | N Arb Arb
          deriving Show


-- EXERCITIUL 4: Scrieti o instanta a clasei Show pentru tipul de date Punct, 
-- astfel incat lista coordonatelor sa fie afisata ca tuplu
instance Show Punct where
  show (Pt []) = "()"
  show (Pt l) = "(" ++ parse l ++ ")"
    where
      parse [x] = show x
      parse (x:xs) = show x ++ "," ++ parse xs
-- Pt [1,2,3]
-- (1, 2, 3)

-- Pt []
-- ()

-- EXERCITIUL 5: Scrieti o instanta a clasei ToFromArb pentru tipul de date Punct,
-- astfel incat lista coordonatelor punctului sa coincida cu frontiera arborelui

{- Frontiera unui arbore binar reprezinta multimea de noduri frunza din arbore.
  Intr-un arbore binar, un nod este considerat frunza daca nu are niciun copil 
  (adica subarborii sai stang si drept sunt null).
-}
class ToFromArb a where
  toArb :: a -> Arb
  fromArb :: Arb -> a

instance ToFromArb Punct where
  toArb (Pt []) = Vid
  toArb (Pt (p:ps)) = N (F p) (toArb (Pt ps))

  fromArb Vid = Pt []
  fromArb (F val) = Pt [val]
  fromArb (N arbore1 arbore2) = Pt (p1 ++ p2)
    where Pt p1 = fromArb arbore1
          Pt p2 = fromArb arbore2

-- toArb (Pt [1,2,3])
-- N (F 1) (N (F 2) (N (F 3) Vid))
-- fromArb $ N (F 1) (N (F 2) (N (F 3) Vid)) :: Punct
--  (1,2,3)



-- Figuri geometrice
data Geo a = Square a | Rectangle a a | Circle a
    deriving Show


class GeoOps g where
  perimeter :: (Floating a) => g a -> a
  area :: (Floating a) =>  g a -> a


-- EXERCITIUL 6: Instantiati clasa GeoOps pentru tipul de date Geo
instance GeoOps Geo where
  perimeter (Square lat) = 4 * lat
  perimeter (Rectangle x y) = 2 * (x + y)
  perimeter (Circle r) = 2 * pi * r
  area (Square lat) = lat ^ 2
  area (Rectangle x y) = x * y
  area (Circle r) = pi * (r ^ 2)


-- EXERCITIUL 7
-- Instantiati clasa Eq pentru tipul de date Geo, a.i. doua figuri geometrice sa fie egale
-- daca au perimetrul egal.
instance (Floating a, Eq a) => Eq (Geo a) where
  fig1 == fig2 = perimeter fig1 == perimeter fig2

-- ghci> pi
-- 3.141592653589793

f1, f2 :: Geo Double
f1 = Rectangle 3 6
f2 = Rectangle 4 5
