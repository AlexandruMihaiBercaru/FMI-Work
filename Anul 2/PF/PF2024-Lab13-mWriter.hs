-- nou tip de date wrapper care retine rezultatul unei computatii (tipul generic)
-- si un log a ce s-a intamplat (String)
newtype WriterS a = Writer
  { runWriter :: (a, String)
  }


-- instante pentru monade, applicative si functor, pentru a aplica diferite computatii
-- si a pastra toate logurile (concatenate in acelasi string cu newline)
instance Monad WriterS where
  return va = Writer (va, "") -- variabila adusa in contexul monadic, fara loguri
  ma >>= k
    -- computatia ma este prima executata, obtine rezultat va si istoric loguri log1
   =
    let (va, log1) = runWriter ma
    -- aplica functia k pe rezultatul intermediar va, si obtine alt rezultat intermediar vb cu logul log2
        (vb, log2) = runWriter (k va)
     -- la final intoarcem rezultatul concatenarii de operatii (cel final este vb), si concatenam la istoricul de loguri
     in Writer (vb, log1 ++ log2)

instance Applicative WriterS where
  pure = return
  -- aplica o functie f in contexul monadic la o valoare a din acelasi context monadic
  mf <*> ma = do
    f <- mf -- extrage functia
    a <- ma -- extrage valoarea
    return (f a) -- aplica functia si dupa rezultatul il punem inapoi in contexul monadic

instance Functor WriterS where
  fmap f ma = pure f <*> ma
  -- pentru functii care nu sunt inca in contexul monadic

-- functie pentru a loga un mesaj, nu realizeaza nicio computatie
tell :: String -> WriterS ()
-- () - unit value, niciun rol util
tell log = Writer ((), log)

logIncrement :: Int -> WriterS Int
logIncrement x = do
  tell ("increment:" ++ show x ++ "\n") -- adaugare log la context
  return (x + 1) -- realizarea computatiei

-- log inrcrement 2 va folosi functia logIncrement de 2 ori, deci vom avea 2 loguri pe langa rezultatul final
logIncrement2 :: Int -> WriterS Int
logIncrement2 x = do
  y <- logIncrement x
  logIncrement y

-- functie recursiva generalizata pentru logIncrement2
-- primul parametru este cel care va fi incrementat
logIncrementN :: Int -> Int -> WriterS Int
logIncrementN x 1 = logIncrement x
logIncrementN x n = do
  y <- logIncrement x
  logIncrementN y (n - 1)
-- exemple
-- runWriter $ logIncrement 1
-- runWriter $ logIncrement2 1
-- runWriter $ logIncrementN 1 3
