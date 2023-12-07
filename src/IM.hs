module IM where

import           InterpreterException
import           Types
import           Lang.AbsMatchalatte
import           Control.Monad.Except
import           Control.Monad.Reader
import           Control.Monad.State

type IM = ReaderT Env (ExceptT InterpreterException (StateT Store IO))