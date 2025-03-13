import Data.List


--definirea de functii
funx :: Int -> Int
--funx n 
--    | n <= 1 = 0
--    | otherwise = n + 1
funx 0 = 0
funx 1 = 1
funx n = n + 1


myInt = 31415926535897932384626433832795028841971693993751058209749445923

--exercitiul 3
double :: Integer -> Integer
double x = x + x
--daca se modifica indentarea -> eroare


maxim :: Integer -> Integer -> Integer
maxim x y =
    if (x > y)
        then x
        else y



--EXERCITIUL 4 - MAXIM3
maxim3 :: Integer -> Integer -> Integer -> Integer
maxim3 a b c =
    if (a > b)
        then if (a > c)
                then a
                else c
        else
            if (c > b)
                then c
                else b 
--maxim 3 7 6
--maxim 1 2 5
                
             

max3 :: Integer -> Integer -> Integer -> Integer
max3 x y z = 
    let
        u = maxim x y
    in 
        maxim  u z


--EXERCITIUL4 - MAXIM4
maxim4 :: Integer -> Integer -> Integer -> Integer -> Integer
maxim4 x y z t =
    let
        u = maxim x y
    in 
        let 
            v = maxim u z
        in
            maxim v t
--maxim4 3 7 5 6  


--test a b c d =
    --(maxim4 a b c d >= a && maxim4 a b c d >= b && maxim4 a b c d >= c && maxim4 a b c d >= d)



--EXERCITIUL 6
--6a)
sumsq :: Integer -> Integer -> Integer    
sumsq a b = a ^ 2 + b ^ 2
--sumsq 3 4

--6b)
paritate :: Integer -> [Char]
paritate x
    | mod x 2 == 0 = "Par"
    | otherwise = "Impar"

--6c)
factorial :: Integer -> Integer
factorial 0 = 1
factorial n = n * factorial (n-1)


--6d)
funct :: Integer -> Integer -> Bool
funct a b = 
    if (a > 2 * b)
        then True
        else False


--6e)
maxiL :: [Integer] -> Integer
maxiL [x] = x
maxiL (x : xs) = 
    if (maxiL xs > x) 
        then maxiL xs
        else x
--maxiL [4, 6, 2, 9, 3, 6]
--maxiL [2, 4, ..] - merge?



--EXERCITIUL 7
poly :: Double -> Double -> Double -> Double -> Double
poly a b c x = a * x ^ 2 + b * x + c
--poly 1 2 1 3


--EXERCITIUL 8
eeny :: Integer -> String
eeny n
    | even n = "eeny"
    | otherwise = "meeny"



--EXERCITIUL 9
fizzbuzz :: Integer -> String
fizzbuzz nr
    | nr `mod` 15 == 0 = "FizzBuzz"
    | nr `mod` 3 == 0  = "Fizz"
    | nr `mod` 5 == 0 = "Buzz"
    | otherwise = ""


fizzbuzz2 :: Integer -> String
fizzbuzz2 nr = 
    if mod nr 3 == 0
        then 
            if mod nr 5 /= 0
                then "Fizz"
                else "FizzBuzz"
        else
            if mod nr 5 == 0
                then "Buzz"
                else ""


fibonacciCazuri :: Integer -> Integer
fibonacciCazuri n
    | n < 2     = n
    | otherwise = fibonacciCazuri (n - 1) + fibonacciCazuri (n - 2)


fibonacciEcuational :: Integer -> Integer
fibonacciEcuational 0 = 0
fibonacciEcuational 1 = 1
fibonacciEcuational n =
    fibonacciEcuational (n - 1) + fibonacciEcuational (n - 2)
    

--Exercitiul 10
tribonacci :: Integer -> Integer
tribonacci n
    | n <= 2 = 1
    | n == 3 = 2
    | otherwise = tribonacci(n - 1) + tribonacci(n - 2) + tribonacci(n - 3)

tribonacciEcuational :: Integer -> Integer
tribonacciEcuational 1 = 1
tribonacciEcuational 2 = 1
tribonacciEcuational 3 = 2
tribonacciEcuational n = tribonacciEcuational(n - 1) + tribonacciEcuational(n - 2) + tribonacciEcuational(n - 3)


--Exercitiul 11
binomial :: Integer -> Integer -> Integer
binomial n 0 = 1
binomial 0 k = 0
binomial n k = binomial (n-1) k + binomial (n-1) (k-1)
