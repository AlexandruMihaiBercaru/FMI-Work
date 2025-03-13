{-
class Functor f where
fmap :: (a -> b) -> f a -> f b

f este un tip de date / o structura de date <=> un wrapper
poate fi: [], Maybe, Either, Tree, aplicare de functie (->)a, etc.)
-}

--FACETI TIPURILE DE DATE SA FIE INSTANTE ALE CLASEI FUNCTOR
--Hint: e posibil sa fie nevoie sa adaugati unele constrângeri la definirea instantelor.

{-REGULI GENERALE:
    -- mereu aplicam fmap pe ultimul generic
    -- de cate ori apare genericul in constructor, de atatea ori il aplicam
    -- daca genericul se afla in alt tip de date, trebuie ca acel tip de date sa fie functor
-}


newtype Identity a = Identity a
-- aplicam functia f pe orice valoare de tip a din structura de date, si returnam aceeasi structura 
instance Functor Identity where
    fmap f (Identity a) = Identity (f a)

data Pair a = Pair a a
-- aplicam functia f pe orice valoare de tip a din structura de date (in cazul nostru, pe ambele valori de tip a)
instance Functor Pair where
    fmap f (Pair a1 a2) = Pair (f a1) (f a2)

data Constant a b = Constant b
instance Functor (Constant a) where
    fmap f (Constant b) = Constant (f b)

data Two a b = Two a b
instance Functor (Two a) where
    fmap f (Two a b) = Two a (f b)

data Three a b c = Three a b c
instance Functor (Three a b) where
    fmap f (Three a b c) = Three a b (f c)

data Three' a b = Three' a b b
instance Functor (Three' a) where
    fmap f (Three' a b1 b2) = Three' a (f b1) (f b2) 


data Four a b c d = Four a b c d
instance Functor (Four a b c) where
    fmap f (Four a b c d) = Four a b c (f d)

data Four'' a b = Four'' a a a b
instance Functor (Four'' a) where
    fmap f (Four'' a1 a2 a3 b) = Four'' a1 a2 a3 (f b)



-- functia f se aplica genericului b, daca un constructor contine un generic de tip b, altfel ramane neschimbat
data Quant a b = Finance | Desk a | Bloor b
    deriving (Eq, Show)
instance Functor (Quant a) where
    fmap _ Finance = Finance
    fmap _ (Desk a) = Desk a
    fmap f (Bloor b) = Bloor (f b)
-- fmap (+1) Finance
-- fmap (+1) (Desk "Office")
-- fmap (+1) (Bloor 42)



-- f este un tip de date care contine un generic de tip a, aplicam functia func pe genericul a din f
-- f are si constrangerea de a fi instanta a clasei Functor pentru a putea aplica functia fmap, care va aplica functia
-- func pe genericul a din interiorul lui f
data LiftItOut f a = LiftItOut (f a)
instance Functor f => Functor (LiftItOut f) where   
    fmap func (LiftItOut fa) = LiftItOut (fmap func fa)
--fmap (*2) (LiftItOut Nothing)
--fmap (*2) (LiftItOut (Just 4))



data Parappa f g a = DaWrappa (f a) (g a)
instance (Functor f, Functor g) => Functor (Parappa f g) where
    fmap func (DaWrappa fa ga) = DaWrappa (fmap func fa)(fmap func ga)
-- ambele tipuri (f si g) trebuie sa fie instante ale clasei Functor pentru a putea aplica functia fmap, care se aplica pe fiecare
-- generic de tip a din f si g
-- `fa` reprezinta (f a), adica rezultatul impachetarii unei variabile de tip a in functorul f (adica [5, 6, 7], Just 8 etc.)



-- 2 tipuri de date f si g care contin generici diferiti, f contine un generic de tip a, g contine un generic de tip b
-- functorul va aplica o functie pe ultimul tip de date, in cazul nostru pe genericul b, deci doar g trebuie sa fie
-- instanta a clasei Functor
data IgnoreOne f g a b = IgnoringSomething (f a) (g b)
instance Functor g => Functor (IgnoreOne f g a) where
    fmap f (IgnoringSomething fa gb) = IgnoringSomething fa (fmap f gb)



-- similar ca mai sus 
data Notorious g o a t = Notorious (g o) (g a) (g t)
instance Funtor g => Functor (Notorious g o a) where
    fmap func (Notorious go ga gt) = Notorious go ga (fmap func gt) 



data GoatLord a = NoGoat | OneGoat a | MoreGoats (GoatLord a) (GoatLord a) (GoatLord a)
-- aplicam functia f pe orice valoare de tip a din structura de date, si returnam aceeasi structura de date
-- definit recursiv pentru constructorul MoreGoats
instance Functor GoatLord where
    fmap func = go
    where
        go NoGoat = NoGoat  -- nu schimbam nimic
        go (OneGoat a) = OneGoat (func a) -- aplicam f pe a
        -- aplicam recursiv pe fiecare valoare, care este de tip GoatLord a, deci oricare dintre cei 3 constructori
        go (MoreGoats gl1 gl2 gl3) = MoreGoats (go gl1) (go gl2) (go gl3)



data TalkToMe a = Halt | Print String a | Read (String -> a)
instance Functor TalkToMe where
    fmap _ Halt = Halt -- nu schimbam nimic
    fmap func (Print chars a) = Print chars (func a) -- aplicam f pe a
    fmap func (Read g) = Read (func . g) -- compunere de functii

instance (Show a) => Show (TalkToMe a) where
    show (Read g) = show (g "heey")