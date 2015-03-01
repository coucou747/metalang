import Text.Printf
import Control.Applicative
import Control.Monad
import Data.Array.MArray
import Data.Array.IO
import Data.Char
import System.IO
import Data.IORef
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
fact n =
  let h i o =
        if i <= n
        then do let p = o * i
                h (i + 1) p
        else return o in
        h 2 1

show0 lim nth =
  do t <- array_init lim (\ i ->
                            return i)
     pris <- array_init lim (\ j ->
                               return False)
     let f k q =
           if k <= lim - 1
           then do n <- fact (lim - k)
                   let nchiffre = q `quot` n
                   let r = q `rem` n
                   let g l s =
                         if l <= lim - 1
                         then ifM (fmap not (readIOA pris l))
                                  (do if s == 0
                                      then do printf "%d" (l :: Int) :: IO ()
                                              writeIOA pris l True
                                      else return ()
                                      let u = s - 1
                                      g (l + 1) u)
                                  (g (l + 1) s)
                         else f (k + 1) r in
                         g 0 nchiffre
           else let e m =
                      if m <= lim - 1
                      then ifM (fmap not (readIOA pris m))
                               (do printf "%d" (m :: Int) :: IO ()
                                   e (m + 1))
                               (e (m + 1))
                      else printf "\n" :: IO () in
                      e 0 in
           f 1 nth

main =
  do show0 10 999999
     return ()


