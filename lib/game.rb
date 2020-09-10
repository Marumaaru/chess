require './lib/board'
require './lib/bishop'
require './lib/knight'
require './lib/rook'
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

  def play
    until board.checkmate?(side_to_move) || board.draw?(side_to_move)
      puts display_menu_options
      puts display_game_header(side_to_move, board.white_pieces_taken, board.black_pieces_taken)
      board.show
      print display_current_turn(side_to_move)
      move(side_to_move)
      next_player
    end
    puts 'Checkmate' if board.checkmate?(side_to_move)
    puts 'Claim draw?' if board.draw?(side_to_move)
  end

  def move(side_to_move)
    input = gets.chomp
    src = board.activate_piece(starting_rank_coords(input), starting_file_coords(input))
    trg = src.class.new(ending_file_coords(input), ending_rank_coords(input), side_to_move) if !src.nil?

    until valid_input?(input) && !src.nil? && correct_color?(src, side_to_move) && board.legal_move?(src, trg)
      show_error(src, trg, side_to_move, input)
      input = gets.chomp
      src = board.activate_piece(starting_rank_coords(input), starting_file_coords(input))
      trg = src.class.new(ending_file_coords(input), ending_rank_coords(input), side_to_move) if !src.nil?
    end
    board.piece_moves(src, trg)
  end

  def show_error(src, trg, side_to_move, input)
    if !valid_input?(input)
      puts display_error_invalid_input
    elsif src.nil?
      puts "The square #{split_lan(input).first} is empty"
    elsif !correct_color?(src, side_to_move)
      puts "You can't move #{src.color} #{src.class}. You're playing #{side_to_move.capitalize}'s"
    elsif !board.legal_move?(src, trg)
      puts "Invalid move: You're in check" if board.in_check?(side_to_move)
      puts 'Invalid move' if !board.valid_move?(src, trg) && !board.request_for_castling?(src, trg)
      puts 'Invalid move: the path is not free' if !board.path_free?(src, trg) && board.valid_move?(src, trg) && !board.request_for_castling?(src, trg)
      puts 'Castling is not possible' if board.request_for_castling?(src, trg) && !board.castling_permissible?(trg)
    end
  end

  def correct_color?(src, side_to_move)
    !src.nil? && src.color == side_to_move
  end

  def valid_input?(input)
    input.match?(/^[a-h][1-8][a-h][1-8]$/)
  end

  # def starting_coords(input) #origin_square
  #   [file_coord(split_lan(input)[0]), rank_coord(split_lan(input)[0])]
  # end

  def starting_rank_coords(input)
    rank_coord(split_lan(input).first)
  end

  def starting_file_coords(input)
    file_coord(split_lan(input).first)
  end

  # def ending_coords(input) #target_square
  #   [file_coord(split_lan(input)[1]), rank_coord(split_lan(input)[1])]
  # end

  def ending_rank_coords(input)
    rank_coord(split_lan(input).last)
  end

  def ending_file_coords(input)
    file_coord(split_lan(input).last)
  end

  def split_lan(input)
    input.scan(/[a-z][1-8]/)
  end

  def rank_coord(input) #convert_rank
    board.board.size - input.split('').last.to_i
  end

  def file_coord(input) #convert_file
    (input.split('').first.ord - 49).chr.to_i
  end

  def setup
    create_player('white')
    create_player('black')
    board.populate_board
  end

  def create_player(color)
    print display_name_prompt(color)
    name = gets.chomp
    players << Player.new(name, color)
  end

  def current_player
    players[current_player_idx]
  end

  def side_to_move
    players[current_player_idx].color
  end

  def next_player
    @current_player_idx = (@current_player_idx + 1) % 2
  end
end