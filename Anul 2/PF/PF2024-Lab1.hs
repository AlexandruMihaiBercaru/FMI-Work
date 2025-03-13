myInt = 31415926535897932384626433832795028841971693993751058209749445923

--double :: Integer -> Integer
double x = x + x

               
triple :: Integer -> Integer
triple x = 3 * x

maxim :: Integer -> Integer -> Integer
--valoarea returnata este ultima
maxim x y = if x > y then x 
       else y



{-
maxim x y
    | x  > y = x
    | otherwise y
-}