{-
What does a MONAD do?

1. It gets us from point A to point B (past and future)
2. It gives us control over the computation (monad vs applicative)
3. It makes the syntax simpler (do blocks and just bind op in general)
-}

{- Monada Maybe este definita in GHC.Base

class Applicative m => Monad m where
  (>>=) :: m a -> (a -> m b) -> m b
    -- we get something wrapped
    -- we get that something from the wrapper
    -- based on it, we create a new something
    -- we wrap it
    -- we throw out the new wrapped something

  (>>) :: m a -> m b -> m b
  return :: a -> m a

instance Monad Maybe where
  return = Just
  Just va >>= k   = k va
  Nothing >>= _   = Nothing


class Functor f => Applicative f where
  pure :: a -> f a
  (<*>) :: f (a -> b) -> f a -> f b
instance Applicative Maybe where
  pure = return
  mf <*> ma = do
    f <- mf
    va <- ma
    return (f va)

instance Functor Maybe where
  fmap f ma = pure f <*> ma
-}


{-  
  EXEMPLU DE SCRIERE CU MONADE
  return 3 :: Maybe Int
  Just 3
  (Just 3) >>= (\ x -> if (x>0) then Just (x*x) else Nothing)
  Just 9
-}


-- Let's discuss this example:
safeRootPlus10Div2 :: Double -> Maybe Double
safeRootPlus10Div2 x =
  case safeRoot x of
    Nothing -> error "The input is less than 0"
    Just s  ->
      let r = s + 10
      in
        case is5 r of
          Nothing -> Nothing
          Just r -> return (r / 2)


safeRootPlus10Div2Do :: Double -> Maybe Double
safeRootPlus10Div2Do x = do
  s <- case safeRoot x of
    Nothing -> error "The input is less than 0"
    Just val  -> return val
  r <- is5 (s + 10)
  return (r / 2)


safeRoot :: Double -> Maybe Double
safeRoot x
  | x < 0     = Nothing
  | otherwise = Just (sqrt x)


is5 :: Double -> Maybe Double
is5 x
  | x == 5 = Just 5
  | otherwise = Nothing





-- EXERCITIUL 1
-- functie care verifica daca un intreg este pozitiv
pos :: Int -> Bool
pos  x = if (x >= 0) then True else False

-- aceeasi functie dar in contextul Maybe, folosind operatorul monadic bind
fct :: Maybe Int ->  Maybe Bool
fct  mx =  mx  >>= (\x -> Just (pos x))


-- aceeasi functie dar in contextul Maybe, folosind do notation, mai usor de citit (syntactic sugar)
fct' :: Maybe Int ->  Maybe Bool
fct' mx = do
  x <- mx -- x ia valoarea din mx, daca mx este Just x, altfel returneaza Nothing
  return (pos x)



-- EXERCITIUL 2: Vrem sa definim o functie care aduna 2 valori de tipul Maybe Int
-- functie in contextul maybe, folosind do-notation
addM :: Maybe Int -> Maybe Int -> Maybe Int
addM mx my = do
  x <- mx -- x ia valoarea din mx, daca mx este Just x, altfel computatia returneaza Nothing
  y <- my -- y ia valoarea din my, daca my este Just y, altfel computatia returneaza Nothing
  return $ (x + y)


-- functie care aduna in siguranta 2 intregi in contextul Maybe
addM1 :: Maybe Int -> Maybe Int -> Maybe Int
addM1 (Just x) (Just y) = Just (x + y)
addM1 _ _ = Nothing

{-
  >addM (Just 4) (Just 3)
  Just 7
  >addM (Just 4) Nothing
  Nothing
  >addM Nothing Nothing
  Nothing
-}

-- EXERCITIUL 3
-- rescrieti functiile folosind notatia monadica cu do

-- produsul cartezian a 2 liste, folosind operatorul monadic bind si functii lambda  
cartesian_product xs ys = xs >>= ( \x -> (ys >>= \y-> return (x,y)))

-- aceeasi functie dar in contextul Maybe, folosind do notation, care face list comprehension intr-o maniera mai clara
cartesian_product' :: [a] -> [b] -> [(a, b)]
cartesian_product' xs ys = do
  x <- xs -- fiecare element x din xs
  y <- ys -- fiecare element y din ys
  return (x, y) -- returnam tuplul (x, y)


-- aplica functia f pe fiecare element din lista xs si pe fiecare element din lista ys, si returneaza lista rezultata
prod f xs ys = [f x y | x <- xs, y<-ys]

myFunc a b = a * b
myProd = prod' myFunc [4,5] [5,6]

-- similar cu exemplul anterior pentru produsul cartezian
prod' :: (a -> b -> c) -> [a] -> [b] -> [c]
prod' f xs ys = do
  x <- xs
  y <- ys
  return (f x y)

myGetLine :: IO String -- functia face operatii de Input/Output
-- citeste un caracter, il trimite la functia lambda (x)
myGetLine = getChar >>= \x ->
      if x == '\n' then -- daca x citeste return
          return [] -- returneaza lista vida
      else
          myGetLine >>= \xs -> return (x:xs) -- altfel, citeste restul sirului si il returneaza


-- acelasi lucru dar folosind do notation, care face codul mai usor de citit
myGetLine' :: IO String
myGetLine' = do
  x <- getChar -- citeste un singur caracter din input
  if x == '\n' then 
    return []
    else do
      xs <- myGetLine' 
      return (x:xs)



-- calculeaza radicalul unui numar (float)
prelNo noin = sqrt noin

-- functie care citeste un numar de la tastatura, afiseaza radicalul sau, folosind notatia do, printeaza loguri pentru
-- ce s-a citit si ce s-a afisat
ioNumber = do
  noin <- readLn :: IO Float -- citeste un float de la tastatura
  putStrLn $ "Intrare\n" ++ (show noin) -- putStrLn afiseaza un string la output
  let noout = prelNo noin -- calculeaza radicalul numarului citit
  putStrLn $ "Iesire" -- afiseaza un string la output
  print noout -- afiseaza radicalul numarului


-- acelasi lucru ca mai sus, dar folosind notatia lambda cu operatorul >>=
ioNumberDo =
  (readLn :: IO Float) >>= \noin ->
    (putStrLn ("Intrare\n" ++ (show noin))
       >> let noout = prelNo noin
           in putStrLn "Iesire" >> print noout)




data Person = Person { name :: String, age :: Int }

showPersonN :: Person -> String
showPersonN p = "NAME: " ++ name p

showPersonA :: Person -> String
showPersonA p = "AGE: " ++ show (age p)

{-
showPersonN $ Person "ada" 20
"NAME: ada"
showPersonA $ Person "ada" 20
"AGE: 20"
-}

showPerson :: Person -> String
showPerson p = "(" ++ showPersonN p ++ ", " ++ showPersonA p ++ ")" 

{-
showPerson $ Person "ada" 20
"(NAME: ada, AGE: 20)"
-}


-- tipul Reader, care aplica o functie (o computatie) care primeste un environment env si intoarce un rezultat de tip a
-- tipul reader are o functie si atat
newtype Reader env a = Reader { runReader :: env -> a }


-- definim instante pentru functor, applicative si monade pentru Reader
instance Monad (Reader env) where
  return x = Reader (\_ -> x)
  --intoarce tipul a
  --return = Reader const

-- (>>=) :: Reader env a -> (a -> Reader env b) -> Reader env b
  ma >>= k = Reader f -- k este o functie care primeste argument de tip a
    where 
      f env = 
        let a = runReader ma env -- am extras tipul din computatie
        in  runReader (k a) env 
        -- am aplicat a functiei k; runReader (k a) este OBIECTUL de tip Reader, adica FUNCTIA care primeste un environment

{-
  (Monad m)
  (>>=) :: m a -> (a -> m b) -> m b
    -- we get something wrapped
    -- we get that something from the wrapper
    -- based on it, we create a new something
    -- we wrap it
    -- we throw out the new wrapped something
-}


instance Applicative (Reader env) where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)       

instance Functor (Reader env) where              
  fmap f ma = pure f <*> ma    

-- ask creeaza o computatie/functie care intoarce acelasi environment, computatia este identitate
ask :: Reader env env
ask = Reader id

mshowPersonN ::  Reader Person String
mshowPersonN = do
  p <- ask -- foloseste ask pentru a obtine environment-ul (tipul de date persoana)
  return ("NAME: " ++ (name p)) -- folosim monada Reader pentru a afisa numele, rezultatul computatiei
--mshowPersonN = ask >>= \p -> (return ("NAME: " ++ (name p)))
{-
  m = Reader env (Reader Person)
  (>>=) :: m a -> (a -> m b) -> m b

  ask :: Reader Person Person deci a = Person
  \p -> (return (String))

  return :: a -> m a
  a -> m b   este Person -> Reader Person String
  return :: String -> Reader Person String

  afisam numele (Reader Person String) cu monada reader
-}
  
mshowPersonA ::  Reader Person String
mshowPersonA = do
  p <- ask -- foloseste ask pentru a obtine environment-ul (tipul de date persoana)
  return ("AGE: " ++ show (age p)) -- folosim moanada Reader pentru a afisa varsta, rezultatul computatiei

mshowPerson ::  Reader Person String
mshowPerson = do 
  x <- mshowPersonN -- computatie care extrage numele din environmentul Persoana
  y <- mshowPersonA -- computatie care extrage varsta din environmentul Persoana
  return ( "(" ++ x ++ ", " ++ y ++ ")") -- afisarea rezultatului

{-
runReader mshowPersonN  $ Person "ada" 20
"NAME:ada"
runReader mshowPersonA  $ Person "ada" 20
"AGE:20"
runReader mshowPerson  $ Person "ada" 20
"(NAME:ada,AGE:20)"
-}