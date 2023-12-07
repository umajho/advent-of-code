module Main

import Data.String
import Data.Maybe
import System

getLinesUntilEmpty : IO (List String)
getLinesUntilEmpty = getLinesUntilEmpty' []
  where
  getLinesUntilEmpty' : List String -> IO (List String)
  getLinesUntilEmpty' prev = do
    line <- getLine
    if line == "" then
      pure $ reverse prev
      else getLinesUntilEmpty'(line::prev)

data HandType = FiveOfAKind| FourOfAKind | FullHouse
              | ThreeOfAKind | TwoPair | OnePair | HighCard

handTypeValue : HandType -> Integer
handTypeValue ht = case ht of
  FiveOfAKind => 7 ; FourOfAKind  => 6 ; FullHouse  => 5 ; ThreeOfAKind  => 4
  TwoPair     => 3 ; OnePair      => 2 ; HighCard   => 1

getHandType : Bool -> String -> Maybe HandType
getHandType isPart2 raw = do
  let sortedCards =
    sortBy (\(_, a) => \(_, b) => compare b a ) $
    rawToCardList raw

  if not isPart2 then getHandType' sortedCards
    else mergeJToHead sortedCards >>= getHandType'
  where

  getHandType' : List (Char, Integer) -> Maybe HandType
  getHandType' list =
    if Prelude.List.length list == 1 then Just FiveOfAKind
    else if Prelude.List.length list == 2 then
      -- Eĉ se ni jam scias, ke la `list` ne estas malplena, ni ankoraŭ ne povas
      -- uzi `head` senpere…
      head' list >>=
        (\(_, n) => if n == 4 then Just FourOfAKind else Just FullHouse)
    else if Prelude.List.length list == 3 then
      head' list >>=
        (\(_, n) => if n == 3 then Just ThreeOfAKind else Just TwoPair)
    else if Prelude.List.length list == 4 then
      Just OnePair
    else Just HighCard

  rawToCardList : String -> List (Char, Integer)
  rawToCardList = foldr insertCard [] . unpack
  where
    insertCard : Char -> List (Char, Integer) -> List (Char, Integer)
    insertCard card [] = [(card, 1)]
    insertCard card ((headCard, headCount)::t) =
      if card == headCard
      then (headCard, headCount+1) :: t
      else (headCard, headCount) :: insertCard card t

  mergeJToHead : List (Char, Integer) -> Maybe (List (Char, Integer))
  mergeJToHead l = do
    let (jN, l) = foldr reduceJAndRest (0, []) l
    case l of
      (headChar, headN)::tail => Just $ (headChar, headN + jN)::tail
      [] => Just [('J', jN)]
    where
      reduceJAndRest : (Char, Integer) -> (Integer, List (Char, Integer)) ->
                       (Integer, List (Char, Integer))
      reduceJAndRest (char, n) (jN, l) =
        if char == 'J' then (n, l) else (jN, (char, n)::l)

record Hand where
  constructor MkHand
  type : HandType ; raw : String ; bid : Integer
  weight : Integer

pow_13_5 = 371_293

parseLine : Bool -> String -> Maybe Hand
parseLine isPart2 l = do
  let x = pack . unpack $ "foo"
  let parts = words l
  raw <- head' parts
  type <- getHandType isPart2 raw
  bid <- last' parts >>= parseInteger
  let weight = pow_13_5 * (handTypeValue type) + (calcRawWeight isPart2 raw)
  Just $ MkHand type raw bid weight
  where

  getCharWeight : (isPart2 : Bool) -> Char -> Integer
  getCharWeight False char = case char of
    'A' => 12 ; 'K' => 11 ; 'Q' => 10 ; 'J' => 9 ; 'T' => 8
    '9' => 7  ; '8' => 6  ; '7' => 5  ; '6' => 4
    '5' => 3  ; '4' => 2  ; '3' => 1  ; '2' => 0
    otherwise => -pow_13_5 * 8
  getCharWeight True char = case char of
    'A' => 12 ; 'K' => 11 ; 'Q' => 10 ; 'T' => 9
    '9' => 8  ; '8' => 7  ; '7' => 6  ; '6' => 5
    '5' => 4  ; '4' => 3  ; '3' => 2  ; '2' => 1 ; 'J' => 0 ; 
    otherwise => -pow_13_5 * 8

  calcRawWeight : Bool -> String -> Integer
  calcRawWeight isPart2 = (foldr (\n => \acc => acc*13 + n) 0)
                . (map (getCharWeight isPart2))
                . reverse
                . unpack

getIsPart2 : IO (Bool)
getIsPart2 = do
  envPart2 <- getEnv "PART_2"
  case envPart2 of
      Just _ => pure True
      Nothing => pure False

main : IO ()
main = do
  isPart2 <- getIsPart2

  lines <- getLinesUntilEmpty
  let hands = sequence $ map (parseLine isPart2) lines
  case hands of
    Just hands => do
      let sortedHands = sortBy (\a => \b => compare a.weight b.weight) hands
      let ranks = map natToInteger [1..(length sortedHands)]
      let totalWinnings = sum $
        -- mi ne scias kial mi ne povas skribi ĉi tiun kiel
        -- `zipWith (*) ranks (map bid sortedHands)`.
        zipWith (\x => \hand => x * hand.bid) ranks sortedHands
      print totalWinnings
    Nothing => putStrLn("?")
