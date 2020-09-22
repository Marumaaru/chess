# frozen_string_literal: true

require './lib/board'
require './lib/computer'
require './lib/modules/save_load'
require './lib/modules/setup'
require './lib/modules/lan_converter'

# Controller of the application/game flow
class Game
  include SaveLoad
  include Setup
  include LanConverter

  attr_reader :board, :players, :current_player_idx

  def initialize
    @board = Board.new
    @players = []
    @current_player_idx = 0
  end

  def play
    players_take_turns until game_finished?
    update_display
    announce_results
  end

  def game_finished?
    board.checkmate?(side_to_move) || board.draw?(side_to_move)
  end

  def players_take_turns
    update_display
    current_player.is_a?(Computer) ? current_player.move : move
    next_player
  end

  def update_display
    puts display_ribbon_bar
    puts display_tag_roster(board.white_pieces_taken, board.black_pieces_taken)
    board.show
    print display_current_turn(side_to_move)
  end

  def announce_results
    puts 'Checkmate' if board.checkmate?(side_to_move)
    puts 'Claim draw?' if board.draw?(side_to_move)
  end

  def move(src = nil, trg = nil)
    until move_verified?(src, trg)
      input = validated_input
      src = origin_square(input)
      trg = target_square(src, input) unless src.nil?
      show_error(src, trg, side_to_move, input)
    end
    board.piece_moves(src, trg)
  end

  def origin_square(input)
    board.activate_piece(starting_rank_coords(input), starting_file_coords(input))
  end

  def target_square(src, input)
    src.class.new(ending_file_coords(input), ending_rank_coords(input), side_to_move)
  end

  def move_verified?(src, trg)
    !src.nil? && correct_color?(src, side_to_move) && board.legal_move?(src, trg)
  end

  def validated_input
    input = gets.chomp
    until valid_input?(input)
      print display_error_invalid_move_input
      input = gets.chomp
    end
    if input.match?(/^[nlsmq]$/i)
      confirm(input.upcase)
    else
      input
    end
  end

  def show_error(src, trg, side_to_move, input)
    if src.nil?
      print display_error_src_is_empty(input)
    elsif !correct_color?(src, side_to_move)
      print display_error_wrong_color(src, side_to_move)
    elsif !board.legal_move?(src, trg)
      board.show_error(src, trg)
    end
  end

  def correct_color?(src, side_to_move)
    !src.nil? && src.color == side_to_move
  end

  def valid_input?(input)
    input.match?(/^[a-h][1-8][a-h][1-8]$|^[nlsmq]$/i)
  end

  def confirm(input)
    print display_warning_unsaved_game
    answer = gets[0].downcase
    if answer == 'y'
      ribbon_bar(input)
    else
      play
    end
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
