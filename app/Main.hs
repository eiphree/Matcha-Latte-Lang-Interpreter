module Main where 

import           IM
import           RunIM
import           Eval 
import           InterpreterException
import           Lang.AbsMatchalatte
import           Lang.ParMatchalatte (myLexer, pProgram)
import           System.Environment    (getArgs)
import           System.Exit           (exitFailure, exitSuccess)
import           System.IO             (getContents, hPutStr, hPutStrLn, stderr)
import           Data.Maybe

type Err = Either String


main :: IO ()
main = do
    args <- getArgs
    case args of
        [] -> getContents >>= interpret
        [file] -> interpretFile file
        _ -> do
            putStrLn "Invalid parameter - provide one file to interpret or run interpreter without argument to pass program from standard input"
            exitFailure

interpretFile :: FilePath -> IO ()
interpretFile file = do
    content <- readFile file
    interpret content

interpret :: String -> IO ()
interpret s = case pProgram (myLexer s) of
    Right parsedProgram -> do
            (result, _) <- runIM parsedProgram
            case result of
                Right _ ->
                    exitSuccess
                Left err -> do
                    let pos = getPosition err
                    let errStr = exceptionString err
                    hPutStr stderr errStr 
                    hPutStr stderr " at "
                    hPutStrLn stderr $ posString pos
                    exitFailure
    Left errStr -> do
        hPutStrLn stderr errStr
        exitFailure