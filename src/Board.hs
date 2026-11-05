module Board
  ( -- * Construction
    initialBoard
  , emptyBoard
    -- * Geometry
  , inBounds
  , isDarkSquare
  , opponent
    -- * Queries
  , pieceAt
  , isEmpty
  , piecesOf
  , countPieces
    -- * Updates
  , movePiece
  , removePiece
  ) where

import qualified Data.Map.Strict as Map
import Model

-- | A board with no pieces.
emptyBoard :: Board
emptyBoard = Map.empty

-- | The other player.
opponent :: Color -> Color
opponent White = Black
opponent Black = White

-- | Is the position inside the 8x8 grid?
inBounds :: Position -> Bool
inBounds (r, c) = r >= 0 && r <= 7 && c >= 0 && c <= 7

-- | Pieces only ever stand on dark squares: those where row + col is odd.
isDarkSquare :: Position -> Bool
isDarkSquare (r, c) = odd (r + c)

-- | Which colour starts on a given row (if any)?
-- Black occupies rows 0-2, White occupies rows 5-7, rows 3-4 are empty.
startingColor :: Int -> Maybe Color
startingColor r
  | r <= 2    = Just Black
  | r >= 5    = Just White
  | otherwise = Nothing

-- | The standard starting position: 12 men per side on the dark squares.
initialBoard :: Board
initialBoard = Map.fromList
  [ ((r, c), Piece col Man)
  | r <- [0 .. 7]
  , c <- [0 .. 7]
  , isDarkSquare (r, c)
  , Just col <- [startingColor r]   -- keeps only rows that have a colour
  ]

-- | What is on this square, if anything?
pieceAt :: Position -> Board -> Maybe Piece
pieceAt = Map.lookup

-- | Is the square free?
isEmpty :: Position -> Board -> Bool
isEmpty pos b = not (Map.member pos b)

-- | All pieces of one colour, with their positions.
piecesOf :: Color -> Board -> [(Position, Piece)]
piecesOf col = Map.toList . Map.filter ((== col) . color)

-- | How many pieces does a colour have on the board?
countPieces :: Color -> Board -> Int
countPieces col = length . piecesOf col

-- | Move whatever is on source to destination.
-- Returns 'Nothing' if there is no piece at source.
-- (It does not check game rules, that belongs in the Rules module.)
movePiece :: Position -> Position -> Board -> Maybe Board
movePiece src dst b = do
  p <- Map.lookup src b
  Just (Map.insert dst p (Map.delete src b))

-- | Remove the piece at a position (used for captures).
-- Does nothing if the square is already empty.
removePiece :: Position -> Board -> Board
removePiece = Map.delete