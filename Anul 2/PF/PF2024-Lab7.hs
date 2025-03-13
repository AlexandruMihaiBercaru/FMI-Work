
data Expr = Const Int -- integer constant
          | Expr :+: Expr -- addition
          | Expr :*: Expr -- multiplication
           deriving Eq

data Operation = Add | Mult 
  deriving (Eq, Show)

data Tree = Lf Int -- leaf
          | Node Operation Tree Tree -- branch
           deriving (Eq, Show)
           
instance Show Expr where
  show (Const x) = show x
  show (e1 :+: e2) = "(" ++ show e1 ++ " + "++ show e2 ++ ")"
  show (e1 :*: e2) = "(" ++ show e1 ++ " * "++ show e2 ++ ")"           


--EXERCITIUL 1
--pattern matching pe constructorii tipului de date Expr
evalExp :: Expr -> Int
evalExp (Const x) = x
evalExp (e1 :+: e2) = evalExp e1 + evalExp e2
evalExp (e1 :*: e2) = evalExp e1 * evalExp e2


--teste
exp1 = ((Const 2 :*: Const 3) :+: (Const 0 :*: Const 5))
exp2 = (Const 2 :*: (Const 3 :+: Const 4))
exp3 = (Const 4 :+: (Const 3 :*: Const 3))
exp4 = (((Const 1 :*: Const 2) :*: (Const 3 :+: Const 1)) :*: Const 2)
test11 = evalExp exp1 == 6
test12 = evalExp exp2 == 14
test13 = evalExp exp3 == 13
test14 = evalExp exp4 == 16



--EXERCITIUL 2
evalArb :: Tree -> Int
evalArb (Lf frunza) = frunza
evalArb (Node Add st dr) = evalArb st + evalArb dr
evalArb (Node Mult st dr) = evalArb st * evalArb dr

arb1 = Node Add (Node Mult (Lf 2) (Lf 3)) (Node Mult (Lf 0)(Lf 5))
arb2 = Node Mult (Lf 2) (Node Add (Lf 3)(Lf 4))
arb3 = Node Add (Lf 4) (Node Mult (Lf 3)(Lf 3))
arb4 = Node Mult (Node Mult (Node Mult (Lf 1) (Lf 2)) (Node Add (Lf 3)(Lf 1))) (Lf 2)

test21 = evalArb arb1 == 6
test22 = evalArb arb2 == 14
test23 = evalArb arb3 == 13
test24 = evalArb arb4 == 16


--EXERCITIUL 3
expToArb :: Expr -> Tree
expToArb (Const x) = Lf x
expToArb (e1 :+: e2) = Node Add (expToArb e1) (expToArb e2)
expToArb (e1 :*: e2) = Node Mult (expToArb e1) (expToArb e2)


data IntSearchTree value
  = Empty
  | BNode
      (IntSearchTree value)     -- elemente cu cheia mai mica
      Int                       -- cheia elementului
      (Maybe value)             -- valoarea elementului
      (IntSearchTree value)     -- elemente cu cheia mai mare


--EXERCITIUL 4
--functie de cautare a unui element in arbore
lookup' :: Int -> IntSearchTree value -> Maybe value
lookup' _ Empty = Nothing
lookup' n (BNode l key val r) 
  | n == key = val
  | n < key = lookup' n l
  | otherwise = lookup' n r


--EXERCITIUL 5
--functie care intoarce lista cheilor nodurilor
keys ::  IntSearchTree value -> [Int]
keys Empty = []
keys (BNode l key v r) = --keys l ++ [key] ++ keys r
  case v of
    Nothing -> keys l ++ keys r
    (Just val) -> keys l ++ [key] ++ keys r

--EXERCITIUL 6
--functie care intoarce lista valorilor nodurilor
values :: IntSearchTree value -> [value]
values Empty = []
values (BNode l key v r) = 
  case v of
    Nothing -> values l ++ values r
    (Just val) -> values l ++ [val] ++ values r


-- EXERCITIUL 7
-- adaugarea unui element intr-un arbore de cautare
insert :: Int -> value -> IntSearchTree value -> IntSearchTree value
insert k val Empty = BNode Empty k (Just val) Empty
insert k val (BNode l key v r) 
  | k == key = BNode l key (Just val) r
  | k < key = BNode (insert k val l) key v r
  | k > key = BNode l key v (insert k val r)


-- EXERCITIUL 8
-- stergerea unui element dintr-un arbore de cautare
delete :: Int -> IntSearchTree value -> IntSearchTree value
delete _ Empty = Empty
delete key (BNode l k v r)
  | key == k = BNode l k Nothing r
  | key < k = BNode (delete key l) k v r
  | key > k = BNode l k v (delete key r)


-- EXERCITIUL 9
-- functie care intoarce lista elementelor unui arbore de cautare 
toList :: IntSearchTree value -> [(Int, value)]
toList Empty = []
toList (BNode l k v r) =
  case v of
    Nothing -> toList l ++ toList r
    Just val -> toList l ++ [(k, val)] ++ toList r


-- EXERCITIUL 10
-- functie care construieste un arbore dintr-o lista de perechi cheie-valaore
fromList :: [(Int,value)] -> IntSearchTree value 
fromList [] = Empty
fromList (p:ps) = insert (fst p) (snd p) (fromList ps)


-- EXERCITIUL 11
-- functie care produce un sir de caractere a structurii arborescente de chei 
printTree :: IntSearchTree value -> String
printTree Empty = ""
printTree (BNode left nodeKey nodeValue right) =
  let leftStr = printTree left
      rightStr = printTree right
  in (if leftStr /= "" then "(" ++ leftStr ++ ") " else "") ++ show nodeKey ++
     (if rightStr /= "" then " (" ++ rightStr ++ ")" else "")


-- balance :: IntSearchTree value -> IntSearchTree value
-- balance = undefined



exampleTree :: IntSearchTree String
exampleTree =
  BNode
    (BNode Empty 1 (Just "A") Empty)  -- Subarbore stang: cheia 1 -> "A"
    3 (Just "B")                     -- Radacina: cheia 3 -> "B"
    (BNode Empty 5 Nothing Empty)    -- Subarbore drept: cheia 5 -> Nothing (sters)

test4_1  = lookup' 1 exampleTree == Just "A"  -- Gaseste cheia 1
test4_2 = lookup' 2 exampleTree == Nothing  -- Cheia 2 nu exista in arbore

test5_1 = keys Empty == []                 --Arbore gol
test5_2 = keys exampleTree == [1, 3, 5] --Cheile arborelui exampleTree

test6_1 = values Empty             -- Arbore gol => trebuie sa intoarca o lista goala
test6_2 = values exampleTree == ["A", "B"]   -- Valorile arborelui exampleTree


--Teste:
--Inserare intr-un arbore gol
tree1 = insert 2 "C" Empty -- keys tree1 ar trebuie sa afiseze: [2], iar values tree1 ar trebuie sa afiseze: ["C"]
test7_1 = (keys tree1 == [2] &&  values tree1 == ["C"])

--Inserare intr-un arbore existent
tree2 = insert 2 "C" exampleTree  -- Cheile trebuie sa includa 2, iar valorile trebuie sa includă "C"
test7_2 = (keys tree2 == [1, 2, 3, 5] &&  values tree2 == ["A", "C", "B"])

--Stergere din arborele gol
test8_1 = delete 1 Empty --ar trebui sa afiseze "Empty", daca ar avea instantiere a clasei Show
 
--Stergere a unei chei care exista
tree4 = delete 3 exampleTree -- Cheile raman neschimbate, iar valoarea pentru cheia 3 este eliminata
test8_2 = (keys tree4 == [1, 3, 5] && values tree4 == ["A", "C"])  
 
--Stergere a unei chei care nu exista
tree5 = delete 4 exampleTree -- Cheile raman neschimbate, iatr valorile raman neschimbate
test8_3 = (keys tree5 == [1, 3, 5] && values tree5 == ["A", "B", "C"])
