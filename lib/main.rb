# frozen_string_literal: true

require_relative 'board.rb'
require_relative 'displayable.rb'
require_relative 'game.rb'

include Displayable

def start_game
  puts display_welcome_intro
  print display_input_prompt
  input = gets.chomp.to_i
  until input.between?(1, 4)
    print display_error_invalid_input
    input = gets.chomp.to_i
  end
  main_menu(input)
end

def main_menu(input)
  case input
  when 1
    start_single_player_game
  when 2
    start_two_players_game
  when 3
    load_game_menu
  when 4
    quit
  end
end

def start_single_player_game
  game = Game.new
  game.setup_single_player_game
  game.play
  restart(game)
end

def start_two_players_game
  game = Game.new
  game.setup_two_players_game
  game.play
  restart(game)
end

def load_game_menu
  game = Game.new
  game.load_game.play
end

def quit
  puts display_farewell
  exit
end

def restart(game)
  puts display_restart_game_prompt
  input = gets.chomp.downcase
  if input == 'y'
    game.new_round
    game.play
  else
    puts display_farewell
  end
end

start_game
