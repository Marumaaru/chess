# frozen_string_literal: true

require './lib/board'
require './lib/computer'
require 'yaml'

class Game
  Player = Struct.new(:name, :color)

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
    puts display_tag_roster(side_to_move, board.white_pieces_taken, board.black_pieces_taken)
    # board.flip(side_to_move)
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

  def ribbon_bar(input)
    case input
    when 'N'
      start_two_players_game
    when 'L'
      load_game.play
    when 'S'
      save_game
    when 'M'
      start_game
    when 'Q'
      quit
    end
  end

  def to_yaml
    YAML.dump(self)
  end

  def from_yaml(game)
    YAML.load(File.read(game))
  end

  def save_game
    filename = prompt_save_name
    File.open(File.join(Dir.pwd, "/saved/#{filename}.yaml"), 'w') { |file| file << to_yaml }
    puts display_report_game_saved
    resume_game
  end

  def load_game
    show_saved_games
    filename = choose_game_to_load
    # print display_game_loading
    from_yaml("./saved/#{filename}.yaml")
  end

  def saved_games
    Dir.entries('saved/')
       .reject { |entry| File.directory?(entry) }
       .map { |file| File.basename(file, '.yaml') }
  end

  def show_saved_games
    system 'clear'
    puts "Saved games:\n\n"
    saved_games.each { |game| puts "  > #{game}" }
  end

  def choose_game_to_load
    print display_load_game_prompt
    input = gets.downcase.chomp
    until saved_games.include?(input)
      print display_error_no_game_to_load
      input = gets.downcase.chomp
    end
    input
  end

  def prompt_save_name
    print display_save_game_prompt
    input = gets.chomp
    while existing_filename?(input)
      return input if overwrite?(input)

      print display_save_game_prompt
      input = gets.chomp
    end
    input
  end

  def existing_filename?(input)
    File.exist?(File.join(Dir.pwd, "/saved/#{input}.yaml"))
  end

  def overwrite?(input)
    print display_warning_existing_filename(input)
    answer = gets[0].downcase
    answer == 'y'
  end

  def resume_game
    print display_resume_game_prompt
    answer = gets[0].downcase
    if answer == 'y'
      play
    else
      main_menu
    end
  end

  def starting_rank_coords(input)
    rank_coord(split_lan(input).first)
  end

  def starting_file_coords(input)
    file_coord(split_lan(input).first)
  end

  def ending_rank_coords(input)
    rank_coord(split_lan(input).last)
  end

  def ending_file_coords(input)
    file_coord(split_lan(input).last)
  end

  def split_lan(input)
    input.downcase.scan(/[a-z][1-8]/)
  end

  def rank_coord(input)
    board.board.size - input.split('').last.to_i
  end

  def file_coord(input)
    (input.split('').first.ord - 49).chr.to_i
  end

  def setup_single_player_game
    system 'clear'
    color = choose_color
    create_player(color)
    create_computer_player(assign_color(color))
    board.populate_board
  end

  def choose_color
    print display_color_prompt
    input = gets.chomp.to_i
    until input.between?(1, 2)
      print display_error_invalid_input
      input = gets.chomp.to_i
    end
    input == 1 ? 'white' : 'black'
  end

  def assign_color(color)
    color == 'white' ? 'black' : 'white'
  end

  def create_computer_player(color)
    if color == 'white'
      players.unshift(Computer.new(color, board))
    else
      players << Computer.new(color, board)
    end
  end

  def setup_two_players_game
    system 'clear'
    create_player('white')
    create_player('black')
    board.populate_board
  end

  def new_round
    @board = Board.new
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
