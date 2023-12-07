module InterpreterUtils where

import Lang.AbsMatchalatte
import InterpreterException
import IM
import Types
import qualified Data.Map     as Map
import           Control.Monad.Except
import           Control.Monad.Reader
import           Control.Monad.State
import           Data.Maybe

defVal :: Type -> Value
defVal t = case t of
            Int _ -> IntV 0
            Str _ -> StrV ""
            Bool _ -> BoolV False
            _ -> undefined


matchingBasicType :: Type -> Value -> Bool
matchingBasicType t val =
    case (t, val) of
        (Int _, IntV _) -> True
        (Str _, StrV _) -> True
        (Bool _, BoolV _) -> True
        (Void _, VoidV) -> True
        _ -> False

matchingType :: Type -> Value -> IM Bool
matchingType t val =
    case (t, val) of
        (_, RefV loc) ->  do
            actualVal <- lookupVal loc
            return $ matchingBasicType t val
        _ -> return $ matchingBasicType t val

updateStore :: Loc -> Value -> IM ()
updateStore loc val = do
    store <- get
    let updatedStore = Map.insert loc val $ _store store
    modify (\store -> store { _store = updatedStore})

updateEnv :: Ident -> Value -> IM Env
updateEnv var val = do
    env <- ask
    store <- get
    case val of
        RefV loc -> do
            let newEnv = Map.insert var loc $ _env env
            return Env {_env = newEnv}
        _ -> do
            let loc = newloc env
            updateStore loc val
            let newEnv = Map.insert var loc $ _env env
            return Env {_env = newEnv}


lookupLoc :: Ident -> BNFC'Position -> IM Loc
lookupLoc var pos = do
    env <- ask
    case Map.lookup var (_env env) of
        Just loc -> return loc
        _ -> throwError $ IdentNotFound var pos

lookupVal :: Loc -> IM Value
lookupVal loc = do
    store <- gets _store
    return $ fromJust $ Map.lookup loc store

lookupVar :: Ident -> BNFC'Position -> IM Value
lookupVar var pos = do
    loc <- lookupLoc var pos
    lookupVal loc

addArgsToEnv :: [Arg] -> [Value] -> IM Env
addArgsToEnv _ [] = ask
addArgsToEnv [] _ = ask
addArgsToEnv ((Arg pos t var):args) (val:vals) = do
    matching <- matchingType t val
    if matching then do
        newEnv <- updateEnv var val
        local (const newEnv) (addArgsToEnv args vals)
    else throwError $ MismatchedType pos