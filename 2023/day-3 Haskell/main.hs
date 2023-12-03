import Data.Char (isDigit)
import Data.Maybe (isJust, mapMaybe)
import Data.Set qualified as Set
import System.Environment (lookupEnv)

-- NOTE: mi scias ke `length l` estas `O(n)`, sed mi estas pigra.

main :: IO ()
main = do
  input <- getContents
  let accInit = ReduceLineAcc {linesInLineAcc = [], numListRev = [], symbolCoords = []}
  let ReduceLineAcc {linesInLineAcc, numListRev, symbolCoords} = foldr reduceLine accInit $ zip (map Row [0 ..]) (lines input)
  let numList = reverse numListRev

  envPart2 <- lookupEnv "PART_2"

  case envPart2 of
    Nothing -> do
      let ids = collectAdjacentNumIdsForAllSymbols linesInLineAcc (map charWithCoordToCoord symbolCoords)
      print $ sum $ map (\(NumId id) -> numList !! id) ids
    Just _ -> do
      let asteriskCoords = map charWithCoordToCoord $ filter (\(char, _, _) -> char == '*') symbolCoords
      let numIdsGroupedByAsterisk = map (collectAdjacentNumIds linesInLineAcc) asteriskCoords
      let numIdsOfGears = filter (\l -> length l == 2) numIdsGroupedByAsterisk
      print $ sum $ map (\[NumId idA, NumId idB] -> (numList !! idA) * (numList !! idB)) numIdsOfGears

charWithCoordToCoord (char, row, col) = (row, col)

collectAdjacentNumIds :: [[Maybe NumId]] -> (Row, Col) -> [NumId]
collectAdjacentNumIds lines coords =
  dedup $ Data.Maybe.mapMaybe (\(Row r, Col c) -> lines !! r !! c) (getGoodAdjacentPositions lines coords)

collectAdjacentNumIdsForAllSymbols :: [[Maybe NumId]] -> [(Row, Col)] -> [NumId]
collectAdjacentNumIdsForAllSymbols lines coords =
  dedup $ Data.Maybe.mapMaybe (\(Row r, Col c) -> lines !! r !! c) (coords >>= getGoodAdjacentPositions lines)

dedup :: (Ord a) => [a] -> [a]
dedup = Set.toList . Set.fromList

deltas = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]

getGoodAdjacentPositions :: [[a]] -> (Row, Col) -> [(Row, Col)]
getGoodAdjacentPositions lines (Row row, Col col) =
  let adjs =
        map
          ( \(deltaRaw, deltaCol) ->
              (Row $ row Prelude.+ deltaRaw, Col $ col Prelude.+ deltaCol)
          )
          deltas
      results =
        filter
          ( \(Row row, Col col) ->
              row >= 0 && col >= 0 && row <= length lines - 1 && col <= length (lines !! row) - 1
          )
          adjs
   in results

newtype NumId = NumId Int deriving (Show, Eq, Ord)

(+) (NumId a) (NumId b) = NumId $ a Prelude.+ b

newtype Row = Row Int deriving (Show)

newtype Col = Col Int deriving (Show)

data ReduceLineAcc = ReduceLineAcc
  { linesInLineAcc :: [[Maybe NumId]],
    numListRev :: [Int],
    symbolCoords :: [(Char, Row, Col)]
  }
  deriving (Show)

reduceLine :: (Row, String) -> ReduceLineAcc -> ReduceLineAcc
reduceLine (row, line) ReduceLineAcc {linesInLineAcc, numListRev, symbolCoords} =
  ReduceLineAcc
    { linesInLineAcc = lineInCharAcc : linesInLineAcc,
      numListRev = map read numTextListRevInCharAcc ++ numListRev,
      symbolCoords = symbolCoordsInCharAcc ++ symbolCoords
    }
  where
    accInit = ReduceCharAcc {lineInCharAcc = [], numTextListRevInCharAcc = [], symbolCoordsInCharAcc = []}
    ReduceCharAcc {lineInCharAcc, numTextListRevInCharAcc, symbolCoordsInCharAcc} =
      foldr (makeReduceChar (row, length line, NumId $ length numListRev)) accInit line

data ReduceCharAcc = ReduceCharAcc
  { lineInCharAcc :: [Maybe NumId],
    numTextListRevInCharAcc :: [String],
    symbolCoordsInCharAcc :: [(Char, Row, Col)]
  }
  deriving (Show)

makeReduceChar :: (Row, Int, NumId) -> Char -> ReduceCharAcc -> ReduceCharAcc
makeReduceChar (row, lineLength, numIdOffset) char (ReduceCharAcc {lineInCharAcc, numTextListRevInCharAcc, symbolCoordsInCharAcc})
  | isDigit char && isHeadNum lineInCharAcc =
      ReduceCharAcc
        { lineInCharAcc = Just (numIdOffset Main.+ NumId (length numTextListRevInCharAcc - 1)) : lineInCharAcc,
          numTextListRevInCharAcc = (char : head numTextListRevInCharAcc) : tail numTextListRevInCharAcc,
          symbolCoordsInCharAcc
        }
  | isDigit char && not (isHeadNum lineInCharAcc) =
      ReduceCharAcc
        { lineInCharAcc = Just (numIdOffset Main.+ NumId (length numTextListRevInCharAcc)) : lineInCharAcc,
          numTextListRevInCharAcc = [char] : numTextListRevInCharAcc,
          symbolCoordsInCharAcc
        }
  | char == '.' =
      ReduceCharAcc
        { lineInCharAcc = Nothing : lineInCharAcc,
          numTextListRevInCharAcc,
          symbolCoordsInCharAcc
        }
  | otherwise =
      ReduceCharAcc
        { lineInCharAcc = Nothing : lineInCharAcc,
          numTextListRevInCharAcc,
          symbolCoordsInCharAcc = (char, row, Col (lineLength - length lineInCharAcc - 1)) : symbolCoordsInCharAcc
        }

isHeadNum :: [Maybe NumId] -> Bool
isHeadNum [] = False
isHeadNum (h : _) = isJust h
