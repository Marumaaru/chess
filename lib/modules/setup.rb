# frozen_string_literal: true

module Setup
  Player = Struct.new(:name, :color)

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
end
