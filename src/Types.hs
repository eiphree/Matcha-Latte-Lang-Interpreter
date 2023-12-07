module Types where

import Lang.AbsMatchalatte

import qualified Data.Map     as Map
import           Data.Char    (toLower)


data Value
    = IntV Integer
    | StrV String
    | BoolV Bool
    | VoidV
    | RefV Loc
    | FuncV Type [Arg] Block Env

instance Show Value where
    show (BoolV b)      = map toLower (show b)
    show (IntV i)       = show i
    show (StrV s)       = s
    show (RefV l)       = show l
    show VoidV          = "VOID"
    show (FuncV t args _ _)       = concat["function (", show args, ") -> ", show t]

printValue :: Value -> String
printValue = show

type Loc = Integer

newtype Env = Env { _env :: Map.Map Ident Loc } deriving Show

newtype Store = Store {_store :: Map.Map Loc Value} deriving Show

initEnv :: Env
initEnv = Env { _env = Map.empty }

initStore :: Store
initStore = Store { _store = Map.empty }

newloc :: Env -> Loc
newloc env = toInteger $ Map.size (_env env)
