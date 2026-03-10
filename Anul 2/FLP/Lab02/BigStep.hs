module BigStep ( bsStmt ) where

import Syntax ( AExpr(..), BExpr(..), Stmt(..) )
import State ( get, set, State )
import Configurations ( Conf(..), Conf1(..) )
import Parser ( aconf, bconf, parseFirst, sconf, Parser ) -- for testing purposes

{- big-step semantics for arithmetic expressions

Examples:

>>> testExpr "< 5 , >"
< 5 >

>>> testExpr "< x , a |-> 3, x |-> 4 >"
< 4 >

>>> testExpr "< x + a, a |-> 3, x |-> 4 >"
< 7 >

>>> testExpr "< x - a, a |-> 3, x |-> 4 >"
< 1 >

>>> testExpr "< x * a, a |-> 3, x |-> 4 >"
< 12 >
-}
unwrap :: Conf1 Integer -> Integer
unwrap (Conf1 x) = x

bsExpr :: Conf AExpr -> Conf1 Integer
bsExpr (Conf (ENum n) stare) = Conf1 n
bsExpr (Conf (EId var) stare) = Conf1 (get stare var)
bsExpr (Conf (EPlu (EId var1) (EId var2)) stare) = Conf1 (val1 + val2)
  where
    val1 = get stare var1
    val2 = get stare var2
bsExpr (Conf (EMinu (EId var1) (EId var2)) stare) = Conf1 (val1 - val2)
  where
    val1 = get stare var1
    val2 = get stare var2
bsExpr (Conf (EMul (EId var1) (EId var2)) stare) = Conf1 (val1 * val2)
  where
    val1 = get stare var1
    val2 = get stare var2
bsExpr (Conf (EPlu aexp1 aexp2) stare) = Conf1 ((unwrap $ bsExpr (Conf aexp1 stare)) + (unwrap $ bsExpr (Conf aexp2 stare)))
bsExpr (Conf (EMinu aexp1 aexp2) stare) = Conf1 ((unwrap $ bsExpr (Conf aexp1 stare)) - (unwrap $ bsExpr (Conf aexp2 stare)))
bsExpr (Conf (EMul aexp1 aexp2) stare) = Conf1 ((unwrap $ bsExpr (Conf aexp1 stare)) * (unwrap $ bsExpr (Conf aexp2 stare)))

                                          
{- big-step semantics for boolean expressions

Examples:
>>> testBExpr "< true, >"
< True >

>>> testBExpr "< false, >"
< False >

>>> testBExpr "< x == a, a |-> 3, x |-> 4 >"
< False >

>>> testBExpr "< a <= x, a |-> 3, x |-> 4 >"
< True >

>>> testBExpr "< !(a <= x), a |-> 3, x |-> 4 >"
< False >

>>> testBExpr "< true && false, >"
< False >

>>> testBExpr "< true || false, >"
< True >
-}

unwrapBExp :: Conf1 Bool -> Bool
unwrapBExp (Conf1 y) = y

compareEq :: Conf AExpr -> Conf AExpr -> Bool
compareEq (Conf e1 st1) (Conf e2 st2) = val1 == val2
  where
    val1 = unwrap (bsExpr (Conf e1 st1))
    val2 = unwrap (bsExpr (Conf e2 st2)) 

compareLe :: Conf AExpr -> Conf AExpr -> Bool
compareLe (Conf e1 st1) (Conf e2 st2) = val1 <= val2
  where
    val1 = unwrap (bsExpr (Conf e1 st1))
    val2 = unwrap (bsExpr (Conf e2 st2)) 


bsBExpr :: Conf BExpr -> Conf1 Bool
bsBExpr (Conf BTrue stare) = Conf1 True
bsBExpr (Conf BFalse stare) = Conf1 False
bsBExpr (Conf (BEq aexp1 aexp2) stare) = Conf1 $ compareEq (Conf aexp1 stare) (Conf aexp2 stare)
bsBExpr (Conf (BLe aexp1 aexp2) stare) = Conf1 $ compareLe (Conf aexp1 stare) (Conf aexp2 stare)
bsBExpr (Conf (BNot bexp) stare) = Conf1 $ not $ unwrapBExp $ bsBExpr (Conf bexp stare)
bsBExpr (Conf (BAnd bexp1 bexp2) stare) = Conf1 $ (unwrapBExp $ bsBExpr (Conf bexp1 stare)) && (unwrapBExp $ bsBExpr (Conf bexp2 stare))
bsBExpr (Conf (BOr bexp1 bexp2) stare) = Conf1 $ (unwrapBExp $ bsBExpr (Conf bexp1 stare)) || (unwrapBExp $ bsBExpr (Conf bexp2 stare))


{- big-step semantics for statements

Examples:

>>> testStmt "< skip, >"
<  >

>>> testStmt "< x := x + 1, a |-> 3, x |-> 4 >"
< x |-> 5, a |-> 3 >

>>> testStmt "< x := x + 1; a := x + a, a |-> 3, x |-> 4 >"
< a |-> 8, x |-> 5 >

>>> testStmt "< if a <= x then max := x else max := a, a |-> 3, x |-> 4 >"
< max |-> 4, a |-> 3, x |-> 4 >

>>> testStmt "< while a <= x do x := x - a, a |-> 7, x |-> 33 >"
< x |-> 5, a |-> 7 >
-}
unwrapState :: Conf1 State -> State
unwrapState (Conf1 sigma) = sigma


bsStmt :: Conf Stmt -> Conf1 State
bsStmt (Conf SSkip stare) = Conf1 stare
bsStmt (Conf (SAss var aexp) stare) = Conf1 stare1
  where
    stare1 = set stare var (unwrap . bsExpr $ Conf aexp stare)
bsStmt (Conf (SSeq stm1 stm2) stare) = Conf1 (unwrapState (bsStmt (Conf stm2 sigma1)))
  where
    sigma1 = unwrapState $ bsStmt (Conf stm1 stare)


bsStmt (Conf (SIf bexp stm1 stm2) stare) = 
  if valAdev == True then
    Conf1 (unwrapState $ bsStmt (Conf stm1 stare))
  else 
    Conf1 (unwrapState $ bsStmt (Conf stm2 stare))
  where
    valAdev = unwrapBExp $ bsBExpr (Conf bexp stare)


bsStmt (Conf (SWhile bexp stmt) stare) =  
  if valAdev == True then
    let stare2 = unwrapState $ bsStmt (Conf stmt stare) in Conf1 (unwrapState $ bsStmt (Conf (SWhile bexp stmt) stare2))
  else 
    Conf1 stare
  where
    valAdev = unwrapBExp $ bsBExpr (Conf bexp stare)




-- Below are the functions used for a nice testing experience
-- they combine running the actual function being tested with parsing
-- to allow specifying the input configuration as a string
--
-- These, together with the Show instances in the Configurations, State, and Syntax modules
-- make the input and output look closer to how it would look on paper.

test :: Show c => (c -> c') -> Parser c -> String -> c'
test f p s = f c
  where
    c = case parseFirst p s of
      Right c -> c
      Left err -> error ("parse error: " ++ err)

testExpr :: String -> Conf1 Integer
testExpr = test bsExpr aconf

testBExpr :: String -> Conf1 Bool
testBExpr = test bsBExpr bconf

testStmt :: String -> Conf1 State
testStmt = test bsStmt sconf
