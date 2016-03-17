module Util where

import Import

import qualified Data.List as L
import Data.Time

prettyDate :: NominalDiffTime -> String
prettyDate diff = 
  let -- | each of these might be > 60, so we still need to drill down 
      totalSeconds, totalMinutes, totalHours, totalDays :: Integer
      totalSeconds = floor (realToFrac diff :: Double)
      totalMinutes = totalSeconds `div` 60 
      totalHours = totalMinutes `div` 60
      totalDays = totalHours `div` 24

      -- seconds = totalSeconds `mod` 60
      minutes = totalMinutes `mod` 60
      hours   = totalHours `mod` 24 
      days    = totalDays
  in show days ++ "d " ++ show hours ++ "h " ++ show minutes ++ " m "

formatBytes :: Int -> String
formatBytes bytes = 
  let 
    bites :: [String]
    bites = ["B/s", "kB/s", "MB/s", "GB/s"]
    (val, unit) = L.last $ filter ((>1) . fst) $ L.zip (byteFracs $ realToFrac bytes) bites
  in
    show (round val) ++ unit

byteFracs :: Double -> [Double]
byteFracs bytes = bytes : map (/ 1000) (byteFracs bytes)
