import Data.List (nub)
import Data.Maybe (fromJust)

type Nume = String
data Prop
  = Var Nume
  | F
  | T
  | Not Prop
  | Prop :|: Prop
  | Prop :&: Prop
  | Prop :->: Prop
  | Prop :<->: Prop
  deriving (Eq, Read)
infixr 2 :|:
infixr 3 :&:

impl :: Bool -> Bool -> Bool
impl True x = x
impl False _ = True

echiv :: Bool -> Bool -> Bool
echiv p q = p == q

--EXERCITIUL 1
--Scrieti formulele ca expresii de tipul 'Prop', denumindu-le p1, p2, p3
p1 :: Prop
p1 = (Var "P" :|: Var "Q") :&: (Var "P" :&: Var "Q")

p2 :: Prop
p2 = (Var "P" :|: Var "Q") :&: (Not (Var "P") :&: Not (Var "Q"))

p3 :: Prop
p3 = ((Var "P" :&: (Var "Q" :|: Var "R"))) :&: ((Not (Var "P") :|: Not (Var "Q")) :&: (Not (Var "P") :|: Not (Var "R")))

--EXERCITIUL 2
--Faceti tipul Prop instanta a clasei Show, inlocuind conectorii Not, :|: si :&: cu ~, | si & 
--si folosind direct numele variabilelor in loc de constructia Var nume.
instance Show Prop where
  show (Var name) = name
  show F = "F"
  show T = "T"
  show (Not prop) = "(~" ++ show prop ++ ")"
  show (p :|: q) = "(" ++ show p ++ "|" ++ show q ++ ")"
  show (p :&: q) = "(" ++ show p ++ "&" ++ show q ++ ")"
  show (p :->: q) = "(" ++ show p ++ "->" ++ show q ++ ")"
  show (p :<->: q) = "(" ++ show p ++ "<->" ++ show q ++ ")"
 
test_ShowProp :: Bool
test_ShowProp =
    show (Not (Var "P") :&: Var "Q") == "((~P)&Q)"


--EXERCITIUL 3
--Tipul env: o lista de atribuiri de valori de adevar pentru numele variabilelor propozitionale
type Env = [(Nume, Bool)]

--functie care genereaza o eroare daca valoarea a nu este gasita
impureLookup :: Eq a => a -> [(a,b)] -> b
impureLookup a = fromJust . lookup a

-- o functie care primeste o expresie logica si un mediu de evaluare si calculeaza
-- valoarea de adevar a expresiei
eval :: Prop -> Env -> Bool
eval (Var variab) l = impureLookup variab l
eval F _ = False
eval T _ = True
eval (Not p) l = not (eval p l)
eval (p :&: q) l = (eval p l) && (eval q l)
eval (p :|: q) l= (eval p l) || (eval q l)
eval (p :->: q) l= (eval p l) `impl` (eval q l)
eval (p :<->: q) l= (eval p l) `echiv` (eval q l)

 --test exercitiul 3
test_eval = eval (Var "P" :|: Var "Q") [("P", True), ("Q", False)] == True

-- nub :: Eq a => [a] -> [a]
-- nub -> removes duplicates from list

--EXERICITUL 4
--o functie care intoarce lista variabilelor dintr-o formula logica
variabile :: Prop -> [Nume]
variabile (Var v) = [v]
variabile F = []
variabile T = []
variabile (Not p) = variabile p
variabile (p :|: q) = nub $ variabile p ++ variabile q
variabile (p :&: q) = nub $ variabile p ++ variabile q
variabile (p :->: q) = nub $ variabile p ++ variabile q
variabile (p :<->: q) = nub $ variabile p ++ variabile q
 
test_variabile =
  variabile (Not (Var "P") :&: Var "Q") == ["P", "Q"]

--EXERCITIUL 5
--data fiind o lista de nume, definiti toate atribuirile de valori de adevar posibile pentru ea.
bools :: Int -> [[Bool]]
bools 0 = [[]]
bools 1 = [[False], [True]]
bools k = [ l ++ [False] | l <- bools (k-1)] ++ [ l ++ [True] | l <- bools (k-1)]


envs :: [Nume] -> [Env]
envs nume = [ zip nume adev | adev <- adevs]
  where adevs = bools (length nume)
 
test_envs = 
    envs ["P", "Q"]
    ==
    [ [ ("P",False), ("Q",False)], 
      [ ("P",False), ("Q",True)],
      [ ("P",True), ("Q",False)], 
      [ ("P",True), ("Q",True)]]


--foldr :: (a -> b -> b) -> b -> [a] -> b
--eval :: Prop -> Env -> Bool
--envs :: [Nume] -> [Env]
--variabile :: Prop -> [Nume]

--EXERCITIUL 6
--O functie care, data fiind o propozitie, verifica daca aceasta este satisfiabila
satisfiabila :: Prop -> Bool
satisfiabila p = foldr (\crt_val acc -> acc || eval p crt_val) False (envs . variabile $ p)

test_satisfiabila1 = satisfiabila (Not (Var "P") :&: Var "Q") == True
test_satisfiabila2 = satisfiabila (Not (Var "P") :&: Var "P") == False


--EXERCITIUL 7
--o functie care verifica daca o propozitie este valida (true pentru fiecare evaluare)
valida :: Prop -> Bool
valida p = 
  if satisfiabila (Not p) == False then
    True
  else
    False

test_valida1 = valida (Not (Var "P") :&: Var "Q") == False
test_valida2 = valida (Not (Var "P") :|: Var "P") == True


--EXERCITIUL 9
{-
  Extindeti tipul de date Prop si functiile definite pana acum, 
  pentru a include conectorii logici de implicatie si echivalenta, folosind constructorii
  :->: si :<->:
-}

--EXERCITIUL 10
-- o functie care verifica daca doua propozitii sunt echivalente
-- adica, indiferent de valorile variabilelor propozitionale, propozitiile au aceeasi valoare de adevar

--all :: (a -> Bool) -> [a] -> Bool
echivalenta :: Prop -> Prop -> Bool
echivalenta p q = all (\env -> eval (p :<->: q) env) $ envs $ nub $ variabile p ++ variabile q
 
test_echivalenta1 =
  True
  ==
  (Var "P" :&: Var "Q") `echivalenta` (Not (Not (Var "P") :|: Not (Var "Q")))
test_echivalenta2 =
  False
  ==
  (Var "P") `echivalenta` (Var "Q")
test_echivalenta3 =
  True
  ==
  (Var "R" :|: Not (Var "R")) `echivalenta` (Var "Q" :|: Not (Var "Q"))

