require './lib/board'
require './lib/knight'
require './lib/rook'
require './lib/bishop'
require './lib/queen'
require './lib/king'
require './lib/pawn'

class Game
  Player = Struct.new(:name, :color)

  attr_reader :board, :players, :current_player_idx

  def initialize
    @board = Board.new
    @players = []
    @current_player_idx = 0
  end

  def setup
    create_player(1)
    create_player(2)
    populate_board
    # board.show
  end

  def convert_rank_algebraic_notation(input)
    third_letter = input.split('')[2].to_i
    board.board.size - third_letter
  end

  def convert_file_algebraic_notation(input)
    second_letter = input.split('')[1]
    (second_letter.ord - 49).chr.to_i
  end

  def create_player(player_number)
    # print display_name_prompt(player_number)
    name = gets.chomp
    players << Player.new(name, assign_color(player_number))
  end

  def assign_color(player_number)
    player_number.eql?(1) ? 'white' : 'black'
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
    board.place(Rook.new(0, 7, "\u2656"))
    board.place(Rook.new(7, 7, "\u2656"))
    board.place(Rook.new(0, 0, "\u265C"))
    board.place(Rook.new(7, 0, "\u265C"))
  end

  def place_knights
    board.place(Knight.new(1, 7, "\u2658"))
    board.place(Knight.new(6, 7, "\u2658"))
    board.place(Knight.new(1, 0, "\u265E"))
    board.place(Knight.new(6, 0, "\u265E"))
  end

  def place_bishops
    board.place(Bishop.new(2, 7, "\u2657"))
    board.place(Bishop.new(5, 7, "\u2657"))
    board.place(Bishop.new(2, 0, "\u265D"))
    board.place(Bishop.new(5, 0, "\u265D"))
  end

  def place_queens
    board.place(Queen.new(3, 7, "\u2655"))
    board.place(Queen.new(3, 0, "\u265B"))
  end

  def place_kings
    board.place(King.new(4, 7, "\u2654"))
    board.place(King.new(4, 0, "\u265A"))
  end

  def place_white_pawns
    board.place(Pawn.new(0, 6, "\u2659"))
    board.place(Pawn.new(1, 6, "\u2659"))
    board.place(Pawn.new(2, 6, "\u2659"))
    board.place(Pawn.new(3, 6, "\u2659"))
    board.place(Pawn.new(4, 6, "\u2659"))
    board.place(Pawn.new(5, 6, "\u2659"))
    board.place(Pawn.new(6, 6, "\u2659"))
    board.place(Pawn.new(7, 6, "\u2659"))
  end

  def place_black_pawns
    board.place(Pawn.new(0, 1, "\u265f"))
    board.place(Pawn.new(1, 1, "\u265f"))
    board.place(Pawn.new(2, 1, "\u265f"))
    board.place(Pawn.new(3, 1, "\u265f"))
    board.place(Pawn.new(4, 1, "\u265f"))
    board.place(Pawn.new(5, 1, "\u265f"))
    board.place(Pawn.new(6, 1, "\u265f"))
    board.place(Pawn.new(7, 1, "\u265f"))
  end
end