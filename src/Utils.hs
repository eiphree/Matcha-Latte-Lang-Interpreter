-- {-# LANGUAGE FlexibleContexts #-}
module Utils where

-- import Lang.AbsMatchalatte
-- import InterpreterException
-- import IM
-- import Types
-- import qualified Data.Map     as Map
-- import           Data.Char    (toLower)
-- import           Control.Monad.Except
-- import Control.Monad.Reader
-- import           Control.Monad.State
-- import           Data.Maybe


-- evalTopDef :: TopDef -> IM Env
-- evalTopDef(GlbDcl _ decl) = evalDecl decl

-- evalTopDef(FnDef _ t ident args block) = do
--     env <- ask
--     let fun = FuncV t args block env
--     updateEnv ident fun

-- evalTopDefSeq :: [TopDef] -> IM Env
-- evalTopDefSeq [] = ask
-- evalTopDefSeq (td:tds) = do
--     newEnv <- evalTopDef td
--     local (const newEnv) (evalTopDefSeq tds)

-- evalProgram :: Program -> IM ()
-- evalProgram (Program pos tds) = do
--     mainEnv <- evalTopDefSeq tds
--     local (const mainEnv) (evalExpr (EApp pos (Ident "main") []))
--     return ()

-- --evalExpr (EApp _ fun argExprs)

-- evalStmt :: Stmt -> IM Env

-- evalStmt (Empty _) = ask

-- evalStmt(BStmt _ block) = evalBlock block

-- evalStmt(DStmt _ decl) = evalDecl decl

-- evalStmt(Ass _ var expr) = do
--     val <- evalExpr expr
--     loc <- lookupLoc var
--     updateStore loc val
--     -- store <- get
--     -- let updatedStore = Map.insert loc val $ _store store
--     -- modify (\store -> store { _store = updatedStore})
--     ask

-- evalStmt(Incr _ var) = do
--     IntV val <- lookupVar var
--     loc <- lookupLoc var
--     updateStore loc $ IntV $ val + 1
--     ask

-- evalStmt(Decr _ var) = do
--     IntV val <- lookupVar var
--     loc <- lookupLoc var
--     updateStore loc $ IntV $ val - 1
--     ask

-- evalStmt(Ret pos expr) = do
--     val <- evalExpr expr
--     throwError $ Return val pos

-- evalStmt(VRet pos) = do
--     throwError $ Return VoidV pos

-- evalStmt(Cond _ expr block) = do
--     BoolV val <- evalExpr expr
--     if val then evalBlock block else ask

-- evalStmt(CondElse _ expr block1 block2) = do
--     BoolV val <- evalExpr expr
--     if val then evalBlock block1 else evalBlock block2

-- evalStmt(While a expr block) = do
--     BoolV val <- evalExpr expr
--     if val then evalBlock block >> evalStmt (While a expr block) else ask

-- evalStmt(SExp _ expr) = do
--     evalExpr expr
--     ask

-- evalStmt(Print _ expr) = do
--     val <- evalExpr expr
--     liftIO $ putStrLn (printValue val)
--     ask

-- evalStmt _ = ask
-- --     | Break a
-- --     | Cont a

-- evalBlock :: Block -> IM Env
-- evalBlock (Block _ stmts) = do
--     env <-ask
--     -- local (const env) (evalMultipleStmts stmts)
--     evalSeq stmts
--     return env

-- evalDecl :: Decl -> IM Env
-- evalDecl (Dcl _ t []) = ask
-- evalDecl (Dcl pos t (item:items)) = do
--     val <- evalItem t item
--     let var = itemIdent item
--     newEnv <- updateEnv var val
--     local (const newEnv) (evalDecl (Dcl pos t items))
--     where
--         itemIdent :: Item -> Ident
--         itemIdent item = case item of
--             NoInit _ ident -> ident
--             Init _ ident _ -> ident

-- evalSeq :: [Stmt] -> IM Env
-- evalSeq [] = ask
-- evalSeq (stmt:stmts) = do
--     newEnv <- evalStmt stmt
--     local(const newEnv) (evalSeq stmts)

-- -- updateAtLoc :: Loc -> Value -> IM ()
-- -- updateAtLoc l mval = modify(& at l ?~ mval)

-- evalItem :: Type -> Item -> IM Value
-- evalItem t (Init pos _ expr) = do
--     val <- evalExpr expr
--     matching <- matchingType t val
--     if matching then return val else throwError $ MismatchedType pos
--     -- TODO
--     -- case val of
--     --     correspondingType t -> return val
--     --     _ -> throwError MismatchedType pos
--     --     where
--     --         correspondingType :: Type -> 

-- evalItem t (NoInit _ _) = return $ defVal t
--     -- where
--     --     defVal :: Type -> Value
--     --     defVal t = case t of
--     --         Int _ -> IntV 0
--     --         Str _ -> StrV ""
--     --         Bool _ -> BoolV False 
--     --         _ -> undefined

-- defVal :: Type -> Value
-- defVal t = case t of
--             Int _ -> IntV 0
--             Str _ -> StrV ""
--             Bool _ -> BoolV False
--             _ -> undefined

-- matchingBasicType :: Type -> Value -> Bool
-- matchingBasicType t val =
--     case (t, val) of
--         (Int _, IntV _) -> True
--         (Str _, StrV _) -> True
--         (Bool _, BoolV _) -> True
--         (Void _, VoidV) -> True
--         _ -> False

-- matchingType :: Type -> Value -> IM Bool
-- matchingType t val =
--     case (t, val) of
--         (_, RefV loc) ->  do
--             actualVal <- lookupVal loc
--             return $ matchingBasicType t val
--         _ -> return $ matchingBasicType t val

-- updateStore :: Loc -> Value -> IM ()
-- updateStore loc val = do
--     store <- get
--     let updatedStore = Map.insert loc val $ _store store
--     modify (\store -> store { _store = updatedStore})

-- updateEnv :: Ident -> Value -> IM Env
-- updateEnv var val = do
--     env <- ask
--     store <- get
--     case val of
--         RefV loc -> do
--             let newEnv = Map.insert var loc $ _env env
--             return Env {_env = newEnv}
--         _ -> do
--             let loc = newloc env
--             updateStore loc val
--             let newEnv = Map.insert var loc $ _env env
--             return Env {_env = newEnv}


-- lookupLoc :: Ident -> IM Loc
-- lookupLoc var = do
--     env <- ask
--     return $ fromJust $ Map.lookup var (_env env)

-- lookupVal :: Loc -> IM Value
-- lookupVal loc = do
--     store <- gets _store
--     return $ fromJust $ Map.lookup loc store

-- lookupVar :: Ident -> IM Value
-- lookupVar = lookupLoc >=> lookupVal

-- evalExpr :: Expr -> IM Value
-- evalExpr (EVar _ var) = do
--     lookupVar var

-- evalExpr (ELitInt _ n) = return $ IntV n

-- evalExpr (ELitTrue a) = return $ BoolV True

-- evalExpr (ELitFalse a) = return $ BoolV False

-- evalExpr (EString _ str) = return $ StrV str

-- evalExpr (EVoid _) = return VoidV

-- evalExpr (ERef _ var) = do
--     loc <- lookupLoc var
--     return $ RefV loc

-- evalExpr (Not _ expr) = do
--     BoolV b <- evalExpr expr
--     return $ BoolV $ not b

-- evalExpr (Neg _ expr) = do
--     IntV n <- evalExpr expr
--     return $ IntV $ (-1) * n

-- evalExpr (EMul _ expr1 (Times _) expr2) = do
--     IntV val1 <- evalExpr expr1
--     IntV val2 <- evalExpr expr2
--     return $ IntV $ val1 * val2

-- evalExpr (EMul pos expr1 (Div _) expr2) = do
--     IntV val1 <- evalExpr expr1
--     IntV val2 <- evalExpr expr2
--     case val2 of
--         0  -> throwError $ DivisionByZero pos
--         _ -> return $ IntV $ div val1 val2

-- evalExpr (EMul pos expr1 (Mod _) expr2) = do
--     IntV val1 <- evalExpr expr1
--     IntV val2 <- evalExpr expr2
--     case val2 of
--         0  -> throwError $ DivisionByZero pos
--         _ -> return $ IntV $ mod val1 val2

-- evalExpr (EAdd _ expr1 (Plus _) expr2) = do
--     IntV val1 <- evalExpr expr1
--     IntV val2 <- evalExpr expr2
--     return $ IntV $ val1 + val2

-- evalExpr (EAdd _ expr1 (Minus _) expr2) = do
--     IntV val1 <- evalExpr expr1
--     IntV val2 <- evalExpr expr2
--     return $ IntV $ val1 - val2

-- evalExpr (ERel _ expr1 op expr2) = do
--     IntV val1 <- evalExpr expr1
--     IntV val2 <- evalExpr expr2
--     return $ BoolV $ operator op val1 val2
--     where
--         operator :: Ord a => RelOp -> (a -> a -> Bool)
--         operator op = case op of
--             LTH _ -> (<)
--             LE _  -> (<=)
--             GTH _ -> (>)
--             GE _  -> (>=)
--             EQU _ -> (==)
--             NE _  -> (/=)

-- evalExpr (EAnd _ expr1 expr2) = do
--     BoolV val1 <- evalExpr expr1
--     BoolV val2 <- evalExpr expr2
--     return $ BoolV $ val1 && val2

-- evalExpr (EOr _ expr1 expr2) = do
--     BoolV val1 <- evalExpr expr1
--     BoolV val2 <- evalExpr expr2
--     return $ BoolV $ val1 || val2

-- evalExpr (EApp pos fun argExprs) = do
--     --env <- ask
--     FuncV t args block funEnv <- lookupVar fun
--     if length argExprs /= length args
--         then throwError $ WrongArgumentsNumber pos
--         else
--             do
--                 argVals <- mapM evalExpr argExprs
--                 newFunEnv <- addArgsToEnv args argVals
--                 local (const newFunEnv) (evalBlock block >> return VoidV) `catchError` catchReturn
--                     where
--                         catchReturn :: InterpreterException -> IM Value
--                         catchReturn  err =
--                             case err of
--                                 Return val _ -> return val
--                                 _ -> throwError err


-- addArgsToEnv :: [Arg] -> [Value] -> IM Env
-- addArgsToEnv _ [] = ask
-- addArgsToEnv [] _ = ask
-- addArgsToEnv ((Arg pos t var):args) (val:vals) = do
--     --val <- evalItem t item
--     --let var = itemIdent item
--     -- case val of
--     --     RefV loc 
--     matching <- matchingType t val
--     if matching then do
--         newEnv <- updateEnv var val
--         local (const newEnv) (addArgsToEnv args vals)
--     else throwError $ MismatchedType pos
--     -- where
--     --     itemIdent :: Item -> Ident
--     --     itemIdent item = case item of
--     --         NoInit _ ident -> ident
--     --         Init _ ident _ -> ident    

-- -- getLocOrAdd :: Ident -> Type -> IM (Env, Loc)
-- -- getLocOrAdd var t = do
-- --     env <- ask
-- --     let loc = Map.lookup var (_env env)
-- --     case loc of
-- --         Just l -> return (env, l)
-- --         Nothing -> do
-- --             let val = defVal t
-- --             newEnv <- updateEnv var val
-- --             let l = fromJust $ Map.lookup var (_env newEnv)
-- --             return (newEnv, l)

--     --return $ fromJust $ Map.lookup var (_env env)

-- --     | EApp a Ident [Expr' a]
-- --     | FuncV Type [Arg] Block Env
-- -- type Arg = Arg' BNFC'Position
-- -- data Arg' a = Arg a (Type' a) Ident



-- -- błędy, referencje, print, spr typów przy przypisaniu i evaluacji itemów
-- -- pliki, cabal, własny main :')), sprawdzanie typów, break + continue, tablice, krotki
