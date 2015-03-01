import Text.Printf
import Control.Applicative
import Control.Monad
import Data.Array.MArray
import Data.Array.IO
import Data.Char
import System.IO
import Data.IORef

(<&&>) a b =
	do c <- a
	   if c then b
		 else return False
(<||>) a b =
	do c <- a
	   if c then return True
		 else b
ifM :: IO Bool -> IO a -> IO a -> IO a
ifM c i e =
  do b <- c
     if b then i else e
writeIOA :: IOArray Int a -> Int -> a -> IO ()
writeIOA = writeArray
readIOA :: IOArray Int a -> Int -> IO a
readIOA = readArray
array_init :: Int -> ( Int -> IO out ) -> IO (IOArray Int out)
array_init len f = newListArray (0, len - 1) =<< g 0
  where g i =
           if i == len
           then return []
           else fmap (:) (f i) <*> g (i + 1)

main :: IO ()
divisible n t size =
  let b i =
        if i <= size - 1
        then ifM (((==) 0) <$> ((rem n) <$> (readIOA t i)))
                 (return True)
                 (b (i + 1))
        else return False in
        b 0

find n t used nth =
  let a e f =
        if f /= nth
        then ifM (divisible e t f)
                 (do let g = e + 1
                     a g f)
                 (do writeIOA t f e
                     let h = e + 1
                     let j = f + 1
                     a h j)
        else readIOA t (f - 1) in
        a n used

main =
  do t <- array_init 10001 (\ i ->
                              return 2)
     printf "%d\n" =<< ((find 3 t 1 10001)::IO Int)


