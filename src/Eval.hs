module Eval where

import Lang.AbsMatchalatte
import InterpreterException
import InterpreterUtils
import IM
import Types
import qualified Data.Map     as Map
import           Control.Monad.Except
import           Control.Monad.Reader
import           Control.Monad.State
import           Data.Maybe


evalTopDef :: TopDef -> IM Env

evalTopDef(GlbDcl _ decl) = evalDecl decl

evalTopDef(FnDef _ t ident args block) = do
    env <- ask
    let fun = FuncV t args block env
    updateEnv ident fun


evalTopDefSeq :: [TopDef] -> IM Env

evalTopDefSeq [] = ask

evalTopDefSeq (td:tds) = do
    newEnv <- evalTopDef td
    local (const newEnv) (evalTopDefSeq tds)


evalProgram :: Program -> IM ()

evalProgram (Program pos tds) = do
    mainEnv <- evalTopDefSeq tds
    local (const mainEnv) (evalExpr (EApp pos (Ident "main") []))
    return ()


evalStmt :: Stmt -> IM Env

evalStmt (Empty _) = ask

evalStmt(BStmt _ block) = evalBlock block

evalStmt(DStmt _ decl) = evalDecl decl

evalStmt(Ass pos var expr) = do
    val <- evalExpr expr
    loc <- lookupLoc var pos
    updateStore loc val
    ask

evalStmt(Incr pos var) = do
    IntV val <- lookupVar var pos
    loc <- lookupLoc var pos
    updateStore loc $ IntV $ val + 1
    ask

evalStmt(Decr pos var) = do
    IntV val <- lookupVar var pos
    loc <- lookupLoc var pos
    updateStore loc $ IntV $ val - 1
    ask

evalStmt(Ret pos expr) = do
    val <- evalExpr expr
    throwError $ Return val pos

evalStmt(VRet pos) = do
    throwError $ Return VoidV pos

evalStmt(Cond _ expr block) = do
    BoolV val <- evalExpr expr
    if val then evalBlock block else ask

evalStmt(CondElse _ expr block1 block2) = do
    BoolV val <- evalExpr expr
    if val then evalBlock block1 else evalBlock block2

evalStmt(While a expr block) = do
    BoolV val <- evalExpr expr
    if val then evalBlock block >> evalStmt (While a expr block) else ask

evalStmt(SExp _ expr) = do
    evalExpr expr
    ask

evalStmt(Print _ expr) = do
    val <- evalExpr expr
    liftIO $ putStrLn (printValue val)
    ask

evalStmt _ = ask


evalBlock :: Block -> IM Env

evalBlock (Block _ stmts) = do
    env <-ask
    evalSeq stmts
    return env


evalDecl :: Decl -> IM Env

evalDecl (Dcl _ t []) = ask

evalDecl (Dcl pos t (item:items)) = do
    val <- evalItem t item
    let var = itemIdent item
    newEnv <- updateEnv var val
    local (const newEnv) (evalDecl (Dcl pos t items))
    where
        itemIdent :: Item -> Ident
        itemIdent item = case item of
            NoInit _ ident -> ident
            Init _ ident _ -> ident

evalSeq :: [Stmt] -> IM Env

evalSeq [] = ask

evalSeq (stmt:stmts) = do
    newEnv <- evalStmt stmt
    local(const newEnv) (evalSeq stmts)


evalItem :: Type -> Item -> IM Value

evalItem t (Init pos _ expr) = do
    val <- evalExpr expr
    matching <- matchingType t val
    if matching then return val else throwError $ MismatchedType pos

evalItem t (NoInit _ _) = return $ defVal t


evalExpr :: Expr -> IM Value

evalExpr (EVar pos var) = do
    lookupVar var pos

evalExpr (ELitInt _ n) = return $ IntV n

evalExpr (ELitTrue a) = return $ BoolV True

evalExpr (ELitFalse a) = return $ BoolV False

evalExpr (EString _ str) = return $ StrV str

evalExpr (EVoid _) = return VoidV

evalExpr (ERef pos var) = do
    loc <- lookupLoc var pos
    return $ RefV loc

evalExpr (Not _ expr) = do
    BoolV b <- evalExpr expr
    return $ BoolV $ not b

evalExpr (Neg _ expr) = do
    IntV n <- evalExpr expr
    return $ IntV $ (-1) * n

evalExpr (EMul _ expr1 (Times _) expr2) = do
    IntV val1 <- evalExpr expr1
    IntV val2 <- evalExpr expr2
    return $ IntV $ val1 * val2

evalExpr (EMul pos expr1 (Div _) expr2) = do
    IntV val1 <- evalExpr expr1
    IntV val2 <- evalExpr expr2
    case val2 of
        0  -> throwError $ DivisionByZero pos
        _ -> return $ IntV $ div val1 val2

evalExpr (EMul pos expr1 (Mod _) expr2) = do
    IntV val1 <- evalExpr expr1
    IntV val2 <- evalExpr expr2
    case val2 of
        0  -> throwError $ DivisionByZero pos
        _ -> return $ IntV $ mod val1 val2

evalExpr (EAdd _ expr1 (Plus _) expr2) = do
    IntV val1 <- evalExpr expr1
    IntV val2 <- evalExpr expr2
    return $ IntV $ val1 + val2

evalExpr (EAdd _ expr1 (Minus _) expr2) = do
    IntV val1 <- evalExpr expr1
    IntV val2 <- evalExpr expr2
    return $ IntV $ val1 - val2

evalExpr (ERel _ expr1 op expr2) = do
    IntV val1 <- evalExpr expr1
    IntV val2 <- evalExpr expr2
    return $ BoolV $ operator op val1 val2
    where
        operator :: Ord a => RelOp -> (a -> a -> Bool)
        operator op = case op of
            LTH _ -> (<)
            LE _  -> (<=)
            GTH _ -> (>)
            GE _  -> (>=)
            EQU _ -> (==)
            NE _  -> (/=)

evalExpr (EAnd _ expr1 expr2) = do
    BoolV val1 <- evalExpr expr1
    BoolV val2 <- evalExpr expr2
    return $ BoolV $ val1 && val2

evalExpr (EOr _ expr1 expr2) = do
    BoolV val1 <- evalExpr expr1
    BoolV val2 <- evalExpr expr2
    return $ BoolV $ val1 || val2

evalExpr (EApp pos fun argExprs) = do
    FuncV t args block funEnv <- lookupVar fun pos
    if length argExprs /= length args
        then throwError $ WrongArgumentsNumber pos
        else
            do
                argVals <- mapM evalExpr argExprs
                newFunEnv <- addArgsToEnv args argVals
                local (const newFunEnv) (evalBlock block >> return VoidV) `catchError` catchReturn
                    where
                        catchReturn :: InterpreterException -> IM Value
                        catchReturn  err =
                            case err of
                                Return val _ -> return val
                                _ -> throwError err
