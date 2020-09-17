# frozen_string_literal: true

require 'yaml'

module SaveLoad
  include Displayable

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
end