module Displayable
  include Colorable
  
  # def display_welcome_intro
  #   system 'clear'
  #   <<-'HEREDOC'
        
  #                 ┌─┐┬ ┬┌─┐┌─┐┌─┐
  #     Welcome to  │  ├─┤├┤ └─┐└─┐                    
  #                 └─┘┴ ┴└─┘└─┘└─┘                   4. Quit           
  #                                                               _:_
  #                                     3. Load game             '-.-'
  #                                                   ()        __.'.__
  #                       2. Two Players           .-:--:-.    |_______|
  #                                       ()        \____/      \=====/
  #     1. Single Player                  /\        {====}       )___(
  #                          (\=,        //\\        )__(       /_____\
  #      __      |'-'-'|    //  .\      (    )      /____\       |   |
  #     /  \     |_____|   (( \_  \      )__(        |  |        |   |
  #     \__/      |===|     ))  `\_)    /____\       |  |        |   |
  #    /____\     |   |    (/     \      |  |        |  |        |   |
  #     |  |      |   |     | _.-'|      |  |        |  |        |   |
  #     |__|      )___(      )___(      /____\      /____\      /_____\
  #    (====)    (=====)    (=====)    (======)    (======)    (=======)
  #    }===={    }====={    }====={    }======{    }======{    }======={
  #   (______)  (_______)  (_______)  (________)  (________)  (_________)

  # INFO: for input this program uses a variant of algebraic chess notation 
  #   termed long algebraic notation or fully expanded algebraic notation. 
  #            In long algebraic notation, moves specify both 
  #         the starting and ending squares, for example: e2e4.
      
  #     It has the advantage of clarity, particularly for less-skilled 
  #              players or players learning the game. 
    
  #   For the output is used figurine algebraic notation (or FAN) which 
  #    substitutes a piece symbol for the letter representing a piece, 
  #                for example: ♞c6 in place of Nc6. 
  #     (Pawns are unlabeled, just like in regular algebraic notation.) 
  #           This enables moves to be read independent of language.

  #   HEREDOC
  # end

  def display_welcome_intro
    system 'clear'
    <<-'HEREDOC'
               
                                  ┌─┐┬ ┬┌─┐┌─┐┌─┐                       
                      Welcome to  │  ├─┤├┤ └─┐└─┐                      
                                  └─┘┴ ┴└─┘└─┘└─┘

                1. Single Player      
                                                                _:_
            2. Two Players                                     '-.-'
                                                    ()        __.'.__
        3. Load game                             .-:--:-.    |_______|
                                        ()        \____/      \=====/
    4. Quit                             /\        {====}       )___(
                           (\=,        //\\        )__(       /_____\
       __      |'-'-'|    //  .\      (    )      /____\       |   |
      /  \     |_____|   (( \_  \      )__(        |  |        |   |
      \__/      |===|     ))  `\_)    /____\       |  |        |   |
     /____\     |   |    (/     \      |  |        |  |        |   |
      |  |      |   |     | _.-'|      |  |        |  |        |   |
      |__|      )___(      )___(      /____\      /____\      /_____\
     (====)    (=====)    (=====)    (======)    (======)    (=======)
     }===={    }====={    }====={    }======{    }======{    }======={
    (______)  (_______)  (_______)  (________)  (________)  (_________)

  INFO: for input this program uses a variant of algebraic chess notation 
    termed long algebraic notation or fully expanded algebraic notation. 
             In long algebraic notation, moves specify both 
          the starting and ending squares, for example: e2e4.
      
      It has the advantage of clarity, particularly for less-skilled 
               players or players learning the game. 
    
    For the output is used figurine algebraic notation (or FAN) which 
     substitutes a piece symbol for the letter representing a piece, 
                 for example: ♞c6 in place of Nc6. 
      (Pawns are unlabeled, just like in regular algebraic notation.) 
            This enables moves to be read independent of language.

    HEREDOC
  end

  def display_one_player_options
    <<~HEREDOC
      1. Black

      2. White

      3. Back to Main Menu
      
    HEREDOC
  end

  # def display_two_players_options
  #   <<~HEREDOC

  #     4. Back to Main Menu
      
  #   HEREDOC
  # end

  def display_game_header(side_to_move, white_pieces_taken, black_pieces_taken)
    <<~HEREDOC

        Event "Informal Game"
        Date #{Time.now.ctime}

        White "#{players.first.name.capitalize}"
        Black "#{players.last.name.capitalize}"

        White player taken: #{black_pieces_taken.join(', ')}
        Black player taken: #{white_pieces_taken.join(', ')}
      
    HEREDOC
  end

  def display_menu_options
    system 'clear'
    printf("#{reverse_color("%<new_game>-15s | %<load>-11s | %<save>-11s | %<main_menu>-15s | %<quit>-13s")}",
          { :new_game => "  (N)ew Game",
            :load => "  (L)oad",
            :save => "  (S)ave",
            :main_menu => "  (M)ain Menu",
            :quit => "  (Q)uit" })
  end

  def display_current_turn(side_to_move)
    "\n#{side_to_move.capitalize}'s Turn: "
  end

  def display_name_prompt(color)
    "\nWho will play #{color.capitalize}'s? "
  end

  def display_input_prompt
    "\nPlease make your choice: "
  end

  def display_game_loading
    # system 'clear'
    print "Loading your game "
    12.times do
      sleep(0.2)
      print "."
    end
    puts "#{green("Done!")} "
  end

  def display_report_game_saved
    print "\n#{green("Your game was successfully saved.")}"
  end

  def display_input_error
    "\e[31mThis move is not valid, please try again\e[0m"
  end

  def display_error_invalid_move_input
    "\n#{red("!! Invalid input")}\nSpecify both the starting and ending squares. For example: #{bold("e2e4")}.\nPlease try again: "
  end

  def display_error_invalid_move_check
    "\n#{red("!! Invalid move")}\nYou're in check. Please try again: "
  end

  def display_error_invalid_move(src)
    "\n#{red("!! Invalid move")}\n#{src.class} doesn't move like this. Please try again: "
  end

  def display_error_invalid_move_path
    "\n#{red("!! Invalid move")}\nThe path is not free. Please try again: "
  end

  def display_error_invalid_move_castling
    "\n#{red("!! Invalid move")}\nCastling is not permitted. Please try again: "
  end

  def display_error_src_is_empty(input)
    "\n#{red("!! Invalid move")}\nThe square #{split_lan(input).first} is empty. Please try again: "
  end

  def display_error_wrong_color(src, side_to_move)
    "\n#{red("!! Invalid move")}\nYou can't move #{src.color} #{src.class}. It's #{side_to_move.capitalize}'s turn. Please try again: "
  end

  def display_error_invalid_input
    "\n#{bg_red("ERROR")}: #{red("invalid input")}"
  end

  def display_warning_unsaved_game
    "\n#{orange("!! WARNING: all unsaved progress will be lost.")}\nDo you want to proceed [Y/N]? "
  end

  def display_save_game_prompt
    "\nEnter a name of your saving game: "
  end

  def display_warning_existing_filename(input)
    "\n#{orange("!! WARNING: the file '#{input}' already exists.")}\nWould you like to overwrite it [Y/N]? "
  end

  def display_load_game_prompt
    "\nPlease enter the name of the game you would like to load: "
  end

  def display_error_no_game_to_load
    "\n#{red("No file matches your entry!")}\nPlease choose a name from the list above: "
  end

  def display_resume_game_prompt
    "\nResume game [Y/N]? "
  end

  def display_congratulations
    # "\n#{players[current_player_idx].name.capitalize} is a winner today!"
  end

  def display_tie
    # "\n#{players[current_player_idx].name.capitalize} and #{players[next_player].name.capitalize}, You both are invincible!"
  end

  def display_restart_game_prompt
    "\nOne more round?\nPress 'y' to confirm: "
  end

  def display_farewell
    "Thank you and have a nice day!"
  end
end