module IOplay where

type Pos = (Int, Int)

cls :: IO()
cls = putStr "\ESC[2J"

seqn        :: [IO a] -> IO()
seqn []     = return ()
seqn (a:as) = do 
                 a
                 seqn as

goto        ::  Pos -> IO()
goto (x, y) = putStr("\ESC[" ++ show y ++ ";" ++ show x ++ "H")

writeat       :: Pos -> String -> IO()
writeat p xs  =  do 
                  goto p
                  putStr xs
