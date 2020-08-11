import System.Random
import Control.Monad.State

randomSt :: (RandomGen g, Random a) => state g a
randomSt = state random