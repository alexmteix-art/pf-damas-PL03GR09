module Model where

import qualified Data.Map.Strict as Map

data Color = White | Black
    deriving (Show, Eq)

data Kind = Man | King
    deriving (Show, Eq)

data Piece = Piece
    { color :: Color
    , kind :: Kind
    } deriving (Show, Eq)

type Position = (Int, Int)         -- (row, column), ex: 0-7
type Board = Map.Map Position Piece


data GameState = GameState
    { board :: Board
    , turn :: Color
    } deriving (Show)



data MoveError
    = NoPieceAtSource
    | NotYourPiece
    | DestinationOccupied
    | IllegalDirection
    | MustCapture
    deriving (Show, Eq)