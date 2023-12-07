module InterpreterException where

import Types
import Lang.AbsMatchalatte
import           Data.Maybe

data RuntimeException a
    = DivisionByZero a
    | MismatchedType a
    | WrongArgumentsNumber a
    | IdentNotFound Ident a
    | InvalidReference a
    | Return Value a
    | Other a

type InterpreterException = RuntimeException BNFC'Position

exceptionString :: InterpreterException -> String
exceptionString err = case err of
    DivisionByZero _ -> "Runtime Exception: division by zero"
    MismatchedType _ -> "Runtime Exception: wrong type"
    WrongArgumentsNumber _ -> "Runtime Exception: incorrect number of function arguments"
    IdentNotFound ident _ -> concat["Runtime Exception: ", show ident, " not found"]
    _ -> "Runtime Exception: other"

getPosition :: InterpreterException -> BNFC'Position
getPosition (DivisionByZero pos) = pos
getPosition (MismatchedType pos) = pos
getPosition (WrongArgumentsNumber pos) = pos
getPosition (IdentNotFound _ pos) = pos
getPosition (InvalidReference pos) = pos
getPosition (Return _ pos) = pos
getPosition (Other pos) = pos

posString :: BNFC'Position -> String
posString (Just (line, column)) = concat ["line ", show line, ", column ", show column]
posString _ = "unknow position"