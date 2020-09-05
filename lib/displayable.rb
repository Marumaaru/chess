module Displayable
  include Colorable

  def display_welcome_intro
    system 'clear'
    <<-'HEREDOC'
            
                                                      
               
                ┌─┐┬ ┬┌─┐┌─┐┌─┐                       _:_
    Welcome to  │  ├─┤├┤ └─┐└─┐                      '-.-'
                └─┘┴ ┴└─┘└─┘└─┘             ()      __.'.__
                                         .-:--:-.  |_______|
                                  ()      \____/    \=====/
                                  /\      {====}     )___(
                       (\=,      //\\      )__(     /_____\
       __    |'-'-'|  //  .\    (    )    /____\     |   |
      /  \   |_____| (( \_  \    )__(      |  |      |   |
      \__/    |===|   ))  `\_)  /____\     |  |      |   |
     /____\   |   |  (/     \    |  |      |  |      |   |
      |  |    |   |   | _.-'|    |  |      |  |      |   |
      |__|    )___(    )___(    /____\    /____\    /_____\
     (====)  (=====)  (=====)  (======)  (======)  (=======)
     }===={  }====={  }====={  }======{  }======{  }======={
    (______)(_______)(_______)(________)(________)(_________)

    HEREDOC
  end

  def display_main_menu
    <<-HEREDOC

                        1. One Player 

                        2. Two Players
      
                        3. Load game

                        4. Quit
            
    HEREDOC
  end

  def display_one_player_options
    <<~HEREDOC
      1. Black

      2. White

      3. Back to Main Menu
      
    HEREDOC
  end

  def display_two_players_options
    <<~HEREDOC

      4. Back to Main Menu
      
    HEREDOC
  end

  def display_name_prompt(color)
    "Who will play #{color.capitalize}'s? "
  end

  def display_input_prompt
    "Please make your choice: "
  end

  def display_game_loading
    system 'clear'
    print "Loading your game "
    12.times do
      sleep(0.2)
      print "."
    end
    puts "#{green("Done!")} "
  end

  def display_report_game_saved
    print "\nYour game was successfully saved."
  end

  def display_input_error
    "\e[31mThis move is not valid, please try again\e[0m"
  end

  def display_error_invalid_input
    "#{bg_red("ERROR")}: #{red("invalid input")}"
  end

  def display_congratulations
    # "\n#{players[current_player_idx].name.capitalize} is a winner today!"
  end

  def display_tie
    # "\n#{players[current_player_idx].name.capitalize} and #{players[next_player].name.capitalize}, You both are invincible!"
  end

  def display_restart_game_prompt
    "\nOne more round?\nPress 'y' for yes (or any other key for no): "
  end

  def display_farewell
    "Thank you and have a nice day!"
  end
end