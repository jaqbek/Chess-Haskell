module Board.Board
(
  Board(Board),
  Square(Piece),
  showSquare,
  readSquare,
  boardToList,
  initBoard
) where

import Board.Pieces

type Square = Maybe Piece
data Board = Board (Vector(Vector Square)) deriving (Eq)

showSquare :: Square -> Char
showSquare = maybe ' ' showPiece

readSquare :: Char -> Square
readSquare ' ' = Nothing
readSquare c   = Just (readPiece c)

boardToList :: Board -> [[Square]]
boardToList (Board l) = toList $ V.map toList l

initBoard :: Board
initBoard = Board $ fromList $ map fromList $ concat [
  [ whiteRearLine, whiteFrontLine ]
  , (replicate 4 emptyLine)
  , [ blackFrontLine , blackRearLine]
  ]
  where
    whiteFrontLine   = frontLine White
    whiteRearLine    = rearLine White
    blackFrontLine   = frontLine Black
    blackRearLine    = rearLine Black
    emptyLine        = replicate 8 Nothing
    frontLine player = replicate 8 $ Just $ Piece player Pawn
    rearLine  player = map (Just . (Piece player)) [
      Rook
      ,Knight
      ,Bishop
      ,Queen
      ,King
      ,Bishop
      ,Knight
      ,Rook
      ]


instance Show Board where
  show board = (unlines ((borderLine : boardStr) ++ [borderLine,bottomLegend]))
    where
      l                    = boardToList board
      boardStr             = zipWith showLine (reverse [1..8]) $ reverse l
      showSquare Nothing   = " "
      showSquare (Just pp) = show pp
      borderLine           = " " ++ (replicate 36 '-' )

      showLine :: Integer -> [Square] -> String
      showLine i pps       =
        (intercalate " | " $ (show i) : (map showSquare pps) ) ++ " |"
      bottomLegend         =
        (intercalate " | " $ ( " " : map (:[]) ['A'..'H'] ) ) ++ " |"