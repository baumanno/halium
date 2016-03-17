-- | helper functions for manipulating Onionoo-data
module Util where

import Import

import qualified Data.List as L
import Data.Time

-- | pretty-print a value given in seconds; will return full days, hours,
-- minutes
-- TODO: filter out the useless elements ("0h 45m", get rid oh 0h)
prettyDate :: NominalDiffTime -> String
prettyDate diff = 
  let -- | each of these might be > 60, so we still need to drill down 
      totalSeconds, totalMinutes, totalHours, totalDays :: Integer
      totalSeconds = floor (realToFrac diff :: Double)
      totalMinutes = totalSeconds `div` 60 
      totalHours = totalMinutes `div` 60
      totalDays = totalHours `div` 24

      -- | these are the real values, i.e. full units of time
      minutes = totalMinutes `mod` 60
      hours   = totalHours `mod` 24 
      days    = totalDays
  in show days ++ "d " ++ show hours ++ "h " ++ show minutes ++ " m "

-- | format a value given in bytes to the highest possible unit, avoiding
-- "0.xx" values
formatBytes :: Int -> String
formatBytes bytes = 
  let 
    bites :: [String] -- teehee 
    bites = ["B/s", "kB/s", "MB/s", "GB/s"]
    (val, unit) = L.last $ filter ((>1) . fst) $ L.zip (byteFracs $ realToFrac bytes) bites
  in
    show (round val) ++ unit

-- | infinite list of fractions of the original bytes; this is fine since we'll
-- be zipping it with a much shorter list, laziness to the rescue.
byteFracs :: Double -> [Double]
byteFracs bytes = bytes : map (/ 1000) (byteFracs bytes)
