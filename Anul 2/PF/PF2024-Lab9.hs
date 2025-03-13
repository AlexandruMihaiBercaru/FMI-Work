data Tree = Empty  -- arbore vid
   | Node Int Tree Tree Tree -- arbore cu valoare de tip Int in radacina si 3 fii
      
extree :: Tree
extree = Node 4 (Node 5 Empty Empty Empty) 
                 (Node 3 Empty Empty (Node 1 Empty Empty Empty)) Empty

class ArbInfo t where
  level :: t -> Int -- intoarce inaltimea arborelui; pt un arbore vid
                      -- se considera ca are inaltimea 0
  sumval :: t -> Int -- intoarce suma valorilor din arbore
  nrFrunze :: t -> Int -- intoarce nr de frunze al arborelui
-- level extree
-- 3
-- sumval extree
-- 13
-- nrFrunze extree
-- 2

--EXERCITIUL 1
instance ArbInfo Tree where
  level Empty = 0
  level (Node x t1 t2 t3) = 1 + maximum [level t1, level t2, level t3]

  sumval Empty = 0
  sumval (Node x t1 t2 t3) = x + sumval t1 + sumval t2 + sumval t3

  nrFrunze Empty = 0
  nrFrunze (Node x Empty Empty Empty) = 1
  nrFrunze (Node x t1 t2 t3) = nrFrunze t1 + nrFrunze t2 + nrFrunze t3


class Scalar a where
  zero :: a
  one :: a
  adds :: a -> a -> a
  mult :: a -> a -> a
  negates :: a -> a
  recips :: a -> a


--EXERCITIUL 2 (instanta a clasei Scalar pentru tipuri de date primitive (Rational))
instance Scalar Rational where
  zero = 0
  one = 1
  adds = (+)
  mult = (*)
  negates = negate
  recips = recip -- FRACTIA RECIPROCA / INVERSUL



class (Scalar a) => Vector v a where
  zerov :: v a
  onev :: v a
  addv :: v a -> v a -> v a -- adunare vector
  smult :: a -> v a -> v a  -- inmultire cu scalare
  negatev :: v a -> v a -- negare vector


data V2D a = V2D a a 
  deriving Show


data V3D a = V3D a a a
  deriving Show


instance (Scalar a) => Vector V2D a where
  zerov = V2D zero zero
  onev = V2D one one
  addv (V2D i1 i2) (V2D j1 j2) = V2D (adds i1 i2) (adds j1 j2)
  smult k (V2D i1 i2) = V2D (mult k i1) (mult k i2)
  negatev (V2D i1 i2) = V2D (negates i1) (negates i2)  


instance (Scalar a) => Vector V3D a where
  zerov = V3D zero zero zero
  onev = V3D one one one
  addv (V3D i1 i2 i3) (V3D j1 j2 j3) = V3D (adds i1 j1) (adds i2 j2) (adds i3 j3)
  smult k (V3D i1 i2 i3) = V3D (mult k i1) (mult k i2) (mult k i3)
  negatev (V3D i1 i2 i3) = V3D (negates i1) (negates i2) (negates i3)