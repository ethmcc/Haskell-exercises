import IOplay

data Op =  Add | Sub | Mul | Div deriving (Show)

--todo: Redefine the combinatorial function choices using a list 
--      comprehension rather than the library functions concat and map
--todo: Modify program to produce the nearest solutions 
--      if no exact solution is possible.
--      Order the solutions using a suitable measure of simplicity.

valid         :: Op -> Int -> Int -> Bool
valid Add x y = x <= y
valid Sub x y = x > y
valid Mul x y = x /= 1 && y /= 1 && x <= y
valid Div x y = y /= 1 && x `mod` y == 0

apply         :: Op -> Int -> Int -> Int
apply Add x y = x + y
apply Sub x y = x - y
apply Mul x y = x * y
apply Div x y = x `div` y

data Expr = Val Int | App Op Expr Expr deriving (Show)

values             :: Expr -> [Int]
values (Val n)     = [n]
values (App _ l r) = values l ++ values r

eval             :: Expr -> [Int]
eval (Val n)     = [n | n>0]
eval (App o l r) = [apply o x y | x <- eval l,
                                  y <- eval r,
                                  valid o x y]

subs         :: [a] -> [[a]]
subs []      = [[]]
subs (x: xs) =  yss ++ map (x:) yss
                where yss = subs xs
interleave          :: a -> [a] -> [[a]]
interleave x []     = [[x]]
interleave x (y:ys) = (x : y : ys) : map (y:) (interleave x ys)

perms        :: [a] -> [[a]]
perms []     = [[]]
perms (x:xs) = concat (map (interleave x) (perms xs))

choices     :: [a] -> [[a]]
choices xs  = concat(map perms (subs xs))

solution        :: Expr -> [Int] -> Int -> Bool
solution e ns n = elem (values e) (choices ns) && eval e == [n]

split        :: [a] -> [([a],[a])]
split []     = []
split [_]    = []
split (x:xs) = ([x],xs):[(x:ls,rs) | (ls, rs)<- split xs]

exprs           :: [Int] -> [Expr]
exprs []        = []
exprs [n]       = [Val n]
exprs ns        = [ e | (ls, rs) <- split ns,
                        l <- exprs ls,
                        r <- exprs rs,
                        e <- combine l r]

type Result = (Expr, Int)

results         :: [Int] -> [Result]
results []      = []
results [n]     = [(Val n, n) | n>0]
results ns      = [res | (ls,rs) <- split ns,
                         lx <- results ls,
                         ry <- results rs,
                         res <- combine' lx ry]

combine     :: Expr -> Expr -> [Expr]
combine l r = [App o l r | o <- ops]

combine'     :: Result -> Result -> [Result]
combine' (l,x) (r,y) = [(App o l r, apply o x y) | o <- ops,
                                                   valid o x y]

ops :: [Op]
ops = [Add, Sub, Mul, Div]

solutions       :: [Int] -> Int -> [Expr]
solutions ns n  = [ e |  ns' <- choices ns,
                         (e,m) <- results ns',
                         m == n]

appendNewline :: String -> String
appendNewline = (flip (++)) "\n"

main :: IO ()
main = do
        putStr "Enter a list of numbers \n"
        numbers <- getLine 
        putStr "Enter a target number \n"
        target <- getLine
        seqn $ map (putStr.appendNewline.show) (solutions (read numbers :: [Int]) (read target :: Int))









