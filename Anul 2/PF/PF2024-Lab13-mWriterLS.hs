-- modificare monada pentru a salva logurile intr-o lista, in loc de a avea un singur string separat de newline
-- l-am denumit WriterLS pentru a face diferenta intre ele
newtype WriterLS a = Writer
  { runWriter :: (a, [String]) -- modificare definitie tip
  }

instance Monad WriterLS where
  return va = Writer (va, [])
  -- variabila adusa in context nu va avea niciun log, deci o lista vida in loc de empty string
  -- restul raman neschimbate, deoarce operatorul ++ se foloseste si pentru string-uri (care este o lista de caractere!)
  ma >>= k =
    let (va, log1) = runWriter ma
        (vb, log2) = runWriter (k va)
     in Writer (vb, log1 ++ log2)

instance Applicative WriterLS where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)

instance Functor WriterLS where
  fmap f ma = pure f <*> ma

-- singurul lucru care mai schimba, cand adaugam un log, practica adaugam o lista cu un singur log,
-- care va fi concatenata cu alte liste de loguri daca se mai realizeaza computatii
tell :: String -> WriterLS ()
tell log = Writer ((), [log])

logIncrement :: Int -> WriterLS Int
logIncrement x = do
  tell ("increment:" ++ show x ++ "\n")
  return (x + 1)

logIncrement2 :: Int -> WriterLS Int
logIncrement2 x = do
  y <- logIncrement x
  logIncrement y

logIncrementN :: Int -> Int -> WriterLS Int
logIncrementN x 1 = logIncrement x
logIncrementN x n = do
  y <- logIncrement x
  logIncrementN y (n - 1)

main :: IO ()
main = print $ runWriter $ logIncrementN 2 4
-- aceleasi exemple
-- runWriter $ logIncrement 1
-- runWriter $ logIncrement2 1
-- runWriter $ logIncrementN 1 3
