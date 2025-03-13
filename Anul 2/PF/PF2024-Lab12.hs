{- 
functorul aplica o functie pe elementele dintr un context, lasand elementele in acelasi context

applicative permite sa aplicam o lista de functii


class Functor f where 
    fmap :: (a -> b) -> f a -> f b 
class Functor f => Applicative f where
    pure :: a -> f a
    (<*>) :: f (a -> b) -> f a -> f b   (citesc "aplicat la")


Exemple de rulat
Just length <*> Just "world"  
Just (++" world") <*> Just "hello,"
pure (+) <*> Just 3 <*> Just 5
pure (+) <*> Just 3 <*> Nothing
(++) <$> ["ha","heh"] <*> ["?","!"]
-}

--1. Se da tipul de date:
data List a = Nil
            | Cons a (List a)
        deriving (Eq, Show)

-- Scrieti instante ale claselor Functor si Applicative pentru constructorul de tip List.
instance Functor List where
    fmap f Nil = Nil
    fmap f (Cons a list) = Cons (f a) (fmap f list)
instance Applicative List where
    pure a = Cons a Nil -- aducem genericul in contextul List
    Nil <*> listElem = Nil -- daca avem o lista goala de functii (f), rezultatul va fi o lista goala
    Cons f listf <*> listElem = lappend (fmap f listElem) (listf <*> listElem)
        where 
            lappend Nil list = list
            lappend (Cons a list1) list2 = Cons a (lappend list1 list2)
{-
    Daca avem o lista de functii si o lista de elemente, aplicam toate functiile pe toate elementele si concatenam
    rezultatele, <*> va fi apelat recursiv pentru a folosi toate functiile din lista de functii, lista de elemente
    ramanand neschimbata, lappend doar concateneaza rezultatele, similar cu ([] ++ ([] ++ ([] ++ ...))) = []
-}

f = Cons (+1) (Cons (*2) Nil)  --lista de functii
v = Cons 1 (Cons 2 Nil)  --lista de valori 
test1 = (f <*> v) == Cons 2 (Cons 3 (Cons 2 (Cons 4 Nil))) -- aplic o lista de functii la o lista de valori



--2. Se da tipul de date:
data Cow = Cow {
        name :: String
        , age :: Int
        , weight :: Int
        } deriving (Eq, Show)

--a) Scrieti functiile noEmpty si noNegative care valideaza un string, respectiv un numer intreg

--validez ca stringul cu numele sa nu fie gol
noEmpty :: String -> Maybe String
noEmpty "" = Nothing
noEmpty str = Just str


--validez ca varsta sa nu fie negativa
noNegative :: Int -> Maybe Int
noNegative  x = 
    if x < 0 then Nothing
    else (Just x)

test21 = noEmpty "abc" == Just "abc"
test22 = noNegative (-5) == Nothing 
test23 = noNegative 5 == Just 5 

-- b). Scrieti o functie care construieste un element de tip cow, verificanf numele, varsta si greutatea,
-- folosind functiile definite pentru a).

-- solutia 1: cu case
-- primind parametrii pentru o variabila Cow, folosind case, validam parametrii primiti, si daca totul este ok
-- return un obiect de tip Cow (in context Maybe folosind Just), altfel returnam Nothing
cowFromString :: String -> Int -> Int -> Maybe Cow
cowFromString name' age' weight' = 
    case noEmpty name' of
        Nothing -> Nothing
        Just name' ->
            case noNegative age' of
                Nothing -> Nothing
                Just age' ->
                    case noNegative weight' of
                        Nothing -> Nothing
                        Just weight' -> Just (Cow name' age' weight')


-- solutia2: cu applicative
-- folosind Applicative, putem sa scriem codul mai compact, fara a folosi case
cowFromString' :: String -> Int -> Int -> Maybe Cow
cowFromString' name' age' weight' = 
    Cow <$> noEmpty name' <*> noNegative age' <*> noNegative weight'

test24 = cowFromString "Milka" 5 100 == Just (Cow {name = "Milka", age = 5, weight = 100})
test24' = 
    cowFromString' "Milka" 5 100 == Just (Cow {name = "", age = 5, weight = 100})





newtype Name = Name String 
    deriving (Eq, Show)
newtype Address = Address String 
    deriving (Eq, Show)

data Person = Person Name Address
    deriving (Eq, Show)

-- functie care valideaza lungimea maxima a unui string, in contextul Maybe
validateLength :: Int -> String -> Maybe String
validateLength maxLen s =
  if (length s) > maxLen
    then Nothing
    else Just s


test31 = validateLength 5 "abc" == Just "abc"

-- functie care primeste un string si returneaza un obiect de tip Name, daca stringul este valid (lungimea <= 25)
mkName :: String -> Maybe Name
mkName s =
  case validateLength 25 s of
    Nothing -> Nothing
    Just s  -> Just (Name s)

-- functie care primeste un string si returneaza un obiect de tip Address, daca stringul este valid (lungimea <= 100)
mkAddress :: String -> Maybe Address
mkAddress a =
  case validateLength 100 a of
    Nothing -> Nothing
    Just a  -> Just (Address a)

test32 = mkName "Gigel" ==  Just (Name "Gigel")
test33 = mkAddress "Str Academiei" ==  Just (Address "Str Academiei")


--c). Implementati functia mkPerson care primeste ca argumente doua siruri de caractere si
-- formeaza un element de tip Person, daca sunt validate conditiile implementate mai sus
-- functie care primeste un nume si o adresa, si returneaza un obiect de tip Person, daca numele si adresa sunt valide
-- folosind case
mkPerson :: String -> String -> Maybe Person
mkPerson n a =
  case mkName n of
    Nothing -> Nothing
    Just n' ->
      case mkAddress a of
        Nothing -> Nothing
        Just a' -> Just $ Person n' a'
test34 = mkPerson "Gigel" "Str Academiei" == Just (Person (Name "Gigel") (Address "Str Academiei"))

-- implementarea functiilor de mai sus folosind Applicative, codul este mai compact si mai usor de citit
mkName2 :: String -> Maybe Name
mkName2 s = fmap Name $ validateLength 25 s

mkAddress2 :: String -> Maybe Address
mkAddress2 a = fmap Address $ validateLength 100 a

mkPersonApp :: String -> String -> Maybe Person
mkPersonApp n a = Person <$> mkName2 n <*> mkAddress2 a


