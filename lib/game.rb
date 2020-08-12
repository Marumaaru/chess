require './lib/board'
require './lib/knight'
require './lib/rook'
require './lib/bishop'
require './lib/queen'
require './lib/king'
require './lib/pawn'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
    populate_board
  end

  def populate_board
    place_rooks
    place_knights
    place_bishops
    place_queens
    place_kings
    place_white_pawns
    place_black_pawns
  end

  def place_rooks
    board.place(Rook.new(0,7))
    board.place(Rook.new(7,7))
    board.place(Rook.new(0,0))
    board.place(Rook.new(7,0))
  end

  def place_knights
    board.place(Knight.new(1, 7))
    board.place(Knight.new(6, 7))
    board.place(Knight.new(1, 0))
    board.place(Knight.new(6, 0))
  end

  def place_bishops
    board.place(Bishop.new(2, 7))
    board.place(Bishop.new(5, 7))
    board.place(Bishop.new(2, 0))
    board.place(Bishop.new(5, 0))
  end

  def place_queens
    board.place(Queen.new(3, 7))
    board.place(Queen.new(3, 0))
  end

  def place_kings
    board.place(King.new(4, 7))
    board.place(King.new(4, 0))
  end

  def place_white_pawns
    board.place(Pawn.new(0, 6))
    board.place(Pawn.new(1, 6))
    board.place(Pawn.new(2, 6))
    board.place(Pawn.new(3, 6))
    board.place(Pawn.new(4, 6))
    board.place(Pawn.new(5, 6))
    board.place(Pawn.new(6, 6))
    board.place(Pawn.new(7, 6))
  end

  def place_black_pawns
    board.place(Pawn.new(0, 1))
    board.place(Pawn.new(1, 1))
    board.place(Pawn.new(2, 1))
    board.place(Pawn.new(3, 1))
    board.place(Pawn.new(4, 1))
    board.place(Pawn.new(5, 1))
    board.place(Pawn.new(6, 1))
    board.place(Pawn.new(7, 1))
  end
end