module RunIM where

import Types
import InterpreterException
import Eval
import           Lang.AbsMatchalatte
import           Control.Monad.Except
import           Control.Monad.Reader
import           Control.Monad.State

runIM :: Program -> IO (Either InterpreterException (), Store)
runIM program = runStateT (runExceptT (runReaderT (evalProgram program) initEnv)) initStore