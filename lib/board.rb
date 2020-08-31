require 'pry'
class Board
  attr_reader :board, :history, :positions, :originals, :halfmove_clock, :move_sequence, :pieces_taken
  
  SIZE = 8

  def initialize
    @board = Array.new(SIZE) { Array.new(SIZE) }
    @history = []
    @positions = []
    @originals = []
    @halfmove_clock = 0
    @move_sequence = []
    @pieces_taken = []
  end

  def populate_board
    place_rooks

    save_rooks
    
    place_knights
    place_bishops
    place_queens
    place_kings

    save_kings

    place_white_pawns
    place_black_pawns
    # @originals = [board[7][4], board[0][4], board[7][7], board[7][0], board[0][7], board[0][0]]
  end

  def place_rooks
    place(Rook.new(0, 7, 'white'))
    place(Rook.new(7, 7, 'white'))
    place(Rook.new(0, 0, 'black'))
    place(Rook.new(7, 0, 'black'))
  end

  def place_knights
    place(Knight.new(1, 7, 'white'))
    place(Knight.new(6, 7, 'white'))
    place(Knight.new(1, 0, 'black'))
    place(Knight.new(6, 0, 'black'))
  end

  def place_bishops
    place(Bishop.new(2, 7, 'white'))
    place(Bishop.new(5, 7, 'white'))
    place(Bishop.new(2, 0, 'black'))
    place(Bishop.new(5, 0, 'black'))
  end

  def place_queens
    place(Queen.new(3, 7, 'white'))
    place(Queen.new(3, 0, 'black'))
  end

  def place_kings
    place(King.new(4, 7, 'white'))
    place(King.new(4, 0, 'black'))
  end

  def place_white_pawns
    place(Pawn.new(0, 6, 'white'))
    place(Pawn.new(1, 6, 'white'))
    place(Pawn.new(2, 6, 'white'))
    place(Pawn.new(3, 6, 'white'))
    place(Pawn.new(4, 6, 'white'))
    place(Pawn.new(5, 6, 'white'))
    place(Pawn.new(6, 6, 'white'))
    place(Pawn.new(7, 6, 'white'))
  end

  def place_black_pawns
    place(Pawn.new(0, 1, 'black'))
    place(Pawn.new(1, 1, 'black'))
    place(Pawn.new(2, 1, 'black'))
    place(Pawn.new(3, 1, 'black'))
    place(Pawn.new(4, 1, 'black'))
    place(Pawn.new(5, 1, 'black'))
    place(Pawn.new(6, 1, 'black'))
    place(Pawn.new(7, 1, 'black'))
  end

  def save_originals
    @originals << [board[7][4], board[0][4], board[7][7], board[7][0], board[0][7], board[0][0]]
  end

  def save_kings
    @originals << board[7][4]
    @originals << board[0][4]
  end

  def save_rooks
    @originals << board[7][7]
    @originals << board[7][0]
    @originals << board[0][7]
    @originals << board[0][0]
  end

  def valid_move?(src, trg)
    if src.class == Pawn
      if (src.rank - trg.rank).abs == 1 && src.file == trg.file &&
        board[trg.rank][trg.file].nil?
        if src.color == 'white'
          if (src.rank - trg.rank) > 0
            true
          else
            # puts "Invalid move"
            false
          end
        elsif src.color == 'black'
          if (src.rank - trg.rank) < 0
            true
          else
            # puts "Invalid move"
            false
          end
        end
      elsif (src.rank - trg.rank).abs == 2 &&
        board[trg.rank][trg.file].nil?
        if src.rank == 6 || src.rank == 1
          true
        else
          # puts "Invalid move"
          false
        end
      elsif (src.rank - trg.rank).abs == (src.file - trg.file).abs &&
            (src.rank - trg.rank).abs == 1 #&& otherwise can slide diagonally
        # unless board[trg.rank][trg.file].color == src.color
        if !board[trg.rank][trg.file].nil? && 
          board[trg.rank][trg.file].color != src.color
          if src.color == 'white'
            if (src.rank - trg.rank) > 0
              true
            else
              # puts "Invalid move"
              false
            end
          elsif src.color == 'black'
            if (src.rank - trg.rank) < 0
              true
            else
              # puts "Invalid move"
              false
            end
          end
        elsif board[trg.rank][trg.file].nil? && 
              en_passant?(src, trg)
          true
        else
          # puts "Invalid move"
          false
        end
      else
        # puts "Invalid move"
        false
      end
    elsif src.class == Knight
      if ((src.file - trg.file).abs == 1 && (src.rank - trg.rank).abs == 2) ||
        ((src.file - trg.file).abs == 2 && (src.rank - trg.rank).abs == 1)
        true
      else
        # puts 'Invalid move'
        false
      end
    elsif src.class == Bishop
      if (src.rank - trg.rank).abs == (src.file - trg.file).abs
        true
      else
        # puts 'Invalid move'
        false
      end
    elsif src.class == Rook
      if src.rank == trg.rank || src.file == trg.file
        true
      else
        # puts 'Invalid move'
        false
      end
    elsif src.class == King
      if (src.rank - trg.rank).abs <= 1 && (src.file - trg.file).abs <= 1
        true
      else
        # puts 'Invalid move'
        false
      end
    elsif src.class == Queen
      if (src.rank - trg.rank).abs == (src.file - trg.file).abs
        true
      elsif src.rank == trg.rank || src.file == trg.file
        true
      else
        # puts 'Invalid move'
        false
      end
    else
      true
    end
  end

  def path_free?(src, trg)
    if target_is_empty?(trg) || target_is_enemy?(src, trg)
      if no_obstacles_between?(src, trg)
        true
      else
        false
      end
    else
      false
    end
  end
  
  def no_obstacles_between?(src, trg)
    traversal = bfs_traversal(src, trg)
    route = route(traversal)
    if route.size <= 2
      true
    else
      route[1..route.size - 2].all? { |coords| board[coords[1]][coords[0]].nil? }
    end
  end

  def target_is_enemy?(src, trg)
    src.color != board[trg.rank][trg.file].color
  end

  def target_is_empty?(trg)
    board[trg.rank][trg.file].nil?
  end

  def enemy?(from, to) #trg_square_enemy?
    board[from[1]][from[0]].color != board[to[1]][to[0]].color
  end

  def empty?(coords)
    board[coords[1]][coords[0]].nil?
  end

  def bfs_traversal(src, trg, queue = [])
    queue << src
    until queue.empty?
      current = queue.shift
      return current if current.file == trg.file && current.rank == trg.rank

      current.where_can_jump_from_here.each { |child| queue << child }
    end
  end

  def piece_moves(from, to)
    src = board[from[1]][from[0]]
    trg = src.class.new(to[0], to[1], src.color)
    if valid_move?(src, trg)
      if path_free?(src, trg)
        if !in_check?(src.color) || getting_out_of_check?(src, trg)
          if threefold_repetition?(src, trg, src.color) || fifty_move? || dead_position?
            puts "Claim draw?"
          else
            move_sequence << fan(src, trg)
            pieces_taken << board[trg.rank][trg.file] if capture?(src, trg)
            place(trg)
            clean(src)
            clean_adjacent(src, trg) if en_passant?(src, trg)
            promote(trg) if promotion?(trg)
            history << [from, to]
            positions << [piece_placement, en_passant?(src, trg), castling_rights(src.color)]
            # if pawn_move? || capture?
            if src.is_a?(Pawn) || (!board[to[1]][to[0]].nil? && board[to[1]][to[0]].color != src.color)
              @halfmove_clock = 0
            else
              @halfmove_clock += 1
            end
          end
          show
          report
        else
          if checkmate?(src.color)
            puts "Checkmate"
          else
            puts "Invalid move: You're in check"
          end
        end
      else
        puts "Invalid move: the path is not free"
      end
    elsif request_for_castling?(src, trg)
      castling(src.color, trg) if castling_permissible?(src.color, trg)
      move_sequence << fan(src, trg)
      show
      report
    else
      puts "Invalid move"
    end
  end

  def route(node, route = [])
    if node.parent.nil?
      route << [node.file, node.rank]
      return route
    end
    route(node.parent, route)
    route << [node.file, node.rank]
  end

  def report
      move_sequence.each_slice(2).to_a.each_with_index.map { |move, idx| "\e[94m#{idx+1}.\e[0m #{move.join(' ')}" }.each_slice(4).to_a
  end

  def info_game
    ["White to move", "", "White player taken: figurine", "", "Black player taken: figurine", "", "Controls"]
  end

  def show #testing
    system 'clear'
    puts "\n     a  b  c  d  e  f  g  h"
    checkered_board.size.times do |idx|
      printf "%3s %-26s %-3s %-20s\n", 
        "#{board.size - idx}", 
        checkered_board[idx].join, 
        "#{board.size - idx}",
        if report[idx].nil?
          ""
        else
          report[idx].join(' ')
        end
    end
    puts "     a  b  c  d  e  f  g  h"
    puts "\nCommands: (N)ew Game (S)ave (L)oad (Q)uit"
  end

  def checkered_board
    board.map.with_index do |row, row_idx|
      row.map.with_index do |square, square_idx| 
        if square.nil?
          if  (row_idx - square_idx).abs.odd?
            "\e[30;104m   \e[0m" #black_on_lt_blue
          else
            "\e[30;47m   \e[0m" #black_on_bg_gray
          end
        else
          if  (row_idx - square_idx).abs.odd?
            "\e[30;104m #{square.symbol} \e[0m" #black_on_lt_blue

          else
            "\e[30;47m #{square.symbol} \e[0m" #black_on_bg_gray
          end
        end
      end
    end
  end

  def place(piece)
    board[piece.rank][piece.file] = piece
  end

  def clean(piece)
    board[piece.rank][piece.file] = nil
  end

  def find_pieces_by(color)
    list_of_pieces = []
    board.each do |row|
      row.each do |square|
        list_of_pieces << square if square.color == color unless square.nil?
      end
    end
    list_of_pieces
  end

  def find_kings
    list_of_pieces = []
    board.each do |row|
      row.each do |square|
        list_of_pieces << square if square.name == 'K' unless square.nil?
      end
    end
    list_of_pieces
  end

  def in_check?(color)
    color == 'white' ? enemy_color = 'black' : enemy_color = 'white'
    opponent_player_color_pieces = find_pieces_by(enemy_color)
    current_player_king = find_kings.select { |king| king if king.color == color }.first
    attackers = opponent_player_color_pieces.select { |piece| piece if valid_move?(piece, current_player_king) && path_free?(piece, current_player_king) }
    # return true unless attackers.empty? # -- future refactoring - change tests with 'false' for 'to be_nil'
    unless attackers.empty? 
      true
    else
      false
    end
  end

  def getting_out_of_check?(src, trg)
    original_trg = board[trg.rank][trg.file]
    # trg = src.class.new(trg.file, trg.rank, src.color)
    place(trg)
    clean(src)
    if !in_check?(src.color)
      place(src)
      board[trg.rank][trg.file] = original_trg
      true
    else
      place(src)
      board[trg.rank][trg.file] = original_trg
      false
    end
  end

  def checkmate?(color)
    no_legal_move_to_escape?(color) &&
    no_ally_can_capture_checking_piece?(color) &&
    no_ally_can_block_checking_piece?(color)
  end

  def no_legal_move_to_escape?(color)
    current_player_color_pieces = find_pieces_by(color)
    current_player_king = find_kings.select { |king| king if king.color == color }.first
    current_player_king.class::MOVES.map { |row, col| [row + current_player_king.file, col + current_player_king.rank] }
                                    .select { |row, col| row.between?(0,7) && col.between?(0,7) }
                                    .select { |row, col| board[col][row].nil? || board[col][row].color != current_player_king.color }
                                    .map { |coords| King.new(*coords, current_player_king.color) }
                                    .none? { |move| getting_out_of_check?(current_player_king, move) }
  end

  def no_empty_squares_not_under_attack?(color) #no_safe_squares #Can delete because inside #no_legal_move_to_escape
    current_player_color_pieces = find_pieces_by(color)
    current_player_king = find_kings.select { |king| king if king.color == color }.first
    current_player_king.class::MOVES.map { |row, col| [row + current_player_king.file, col + current_player_king.rank] }
                                    .select { |row, col| row.between?(0,7) && col.between?(0,7) }
                                    .select { |row, col| board[col][row].nil? }
                                    .map { |coords| King.new(*coords, current_player_king.color) }
                                    .none? { |move| getting_out_of_check?(current_player_king, move) }
  end

  def no_ally_can_capture_checking_piece?(color)
    current_player_color_pieces = find_pieces_by(color)
    current_player_king = find_kings.select { |king| king if king.color == color }.first

    color == 'white' ? enemy_color = 'black' : enemy_color = 'white'
    opponent_player_color_pieces = find_pieces_by(enemy_color)
    attackers = opponent_player_color_pieces.select { |piece| piece if valid_move?(piece, current_player_king) && path_free?(piece, current_player_king) }

    defenders = []
    current_player_color_pieces.each do |piece|
      attackers.each do |attacker|
        defenders << piece if valid_move?(piece, attacker) && path_free?(piece, attacker)
      end
    end
    
    defenders.none? { |defender| attackers.each { |attacker| getting_out_of_check?(defender, attacker) } }
  end

  def no_ally_can_block_checking_piece?(color)
    current_player_color_pieces = find_pieces_by(color)
    current_player_king = find_kings.select { |king| king if king.color == color }.first

    color == 'white' ? enemy_color = 'black' : enemy_color = 'white'
    opponent_player_color_pieces = find_pieces_by(enemy_color)
    attackers = opponent_player_color_pieces.select { |piece| piece if valid_move?(piece, current_player_king) && path_free?(piece, current_player_king) }
    
    blockers = []
  #could be solved with .none? or .any? like in #path_safe?
    current_player_color_pieces.each do |piece|
      attackers.each do |attacker|
        traversal = bfs_traversal(attacker, current_player_king)
        route = route(traversal)
        route[1..route.size - 2].each do |square|
          blockers << piece if valid_move?(piece, attacker.class.new(*square, attacker.color)) && 
                               path_free?(piece, attacker.class.new(*square, attacker.color)) &&
                               piece != current_player_king
        end
      end
    end
    blockers.empty?
  end

  def castling(color, trg)
    king = find_king(color)
    rook = find_rook(color, trg)
    if trg.is_a?(King) && trg.file == 6
      place(King.new(king.file + 2, king.rank, color))
      place(Rook.new(rook.file - 2, rook.rank, color))
    elsif trg.is_a?(King) && trg.file == 2
      place(King.new(king.file - 2, king.rank, color))
      place(Rook.new(rook.file + 3, rook.rank, color))
    end
    clean(king)
    clean(rook)
  end

  def request_for_castling?(src, trg)
    src.is_a?(King) && ((src.file - trg.file).abs == 2 && src.rank == trg.rank)
  end

  def find_king(color)
    board.flatten.find { |square| square.is_a?(King) && square.color == color }
  end

  #magic numbers 7 and 0
  def find_rook(color, trg)
    rooks = board.flatten.find_all { |square| square.is_a?(Rook) && square.color == color }
    if trg.is_a?(King) && trg.file == 6
      rooks.find { |rook| rook if rook.file == 7 }
    elsif trg.is_a?(King) && trg.file == 2
      rooks.find { |rook| rook if rook.file == 0 }
    end
  end

  def castling_permissible?(color, trg)
    king = find_king(color)
    rook = find_rook(color, trg)
    no_obstacles_between?(rook, king) &&
    path_safe?(rook, king) &&
    first_move?(king) &&
    first_move?(rook)
  end

  def path_safe?(src, trg)
    src.color == 'white' ? enemy_color = 'black' : enemy_color = 'white'
    opponent_player_color_pieces = find_pieces_by(enemy_color)

    traversal = bfs_traversal(src, trg)
    route = route(traversal)

    attackers = []
    opponent_player_color_pieces.each do |piece| 
      route.each do |square|
        attackers << piece if valid_move?(piece, src.class.new(*square, src.color)) && 
                 no_obstacles_between?(piece, src.class.new(*square, src.color))
                #  path_free?(piece, src.class.new(*square, src.color))
      end
    end
    attackers.empty?
  end

  def first_move?(piece) #do not like original (maybe INITIAL) and square here
    original = @originals.flatten.find do |square| 
      square.is_a?(piece.class) && 
      square.color == piece.color &&
      square.file == piece.file
    end
    original.eql?(piece)
  end

  def castling_rights(color)
    king = find_king(color)
    kingside_rook = board.flatten.find { |square| square.is_a?(Rook) && square.color == color && square.file == 7 }
    queenside_rook = board.flatten.find { |square| square.is_a?(Rook) && square.color == color && square.file == 0 }
    [first_move?(king) && first_move?(kingside_rook), first_move?(king) && first_move?(queenside_rook)]
  end

  def en_passant?(src, trg)
    correct_rank?(src) && 
    adjacent?(src) && 
    just_double_moved?(src) &&
    immediate_capture?(src, trg)
  end

  def correct_rank?(src)
    src.rank == 3 || src.rank == 4
  end

  def adjacent?(src)
    src.color == 'white' ? enemy_color = 'black' : enemy_color = 'white'
    left_adjacent = board[src.rank][src.file - 1]
    right_adjacent = board[src.rank][src.file + 1]
    (left_adjacent.is_a?(Pawn) && left_adjacent.color == enemy_color) ||
     (right_adjacent.is_a?(Pawn) && right_adjacent.color == enemy_color)
  end

  def just_double_moved?(src)
    left_adjacent = board[src.rank][src.file - 1]
    right_adjacent = board[src.rank][src.file + 1]

    last_trg_rank = @history.last.last.last
    last_trg_file = @history.last.last.first
    last_src_rank = @history.last.first.last
    last_src_file = @history.last.first.first

    (last_trg_rank - last_src_rank).abs == 2 &&
    ((right_adjacent.is_a?(Pawn) && right_adjacent.rank == last_trg_rank) || 
    (left_adjacent.is_a?(Pawn) && left_adjacent.rank == last_trg_rank))
  end

  def immediate_capture?(src, trg)
    left_adjacent = board[src.rank][src.file - 1]
    right_adjacent = board[src.rank][src.file + 1]
    if !left_adjacent.nil?
      (trg.rank == left_adjacent.rank - 1 && trg.file == left_adjacent.file) ||
      (trg.rank == left_adjacent.rank + 1 && trg.file == left_adjacent.file)
    elsif !right_adjacent.nil?
      (trg.rank == right_adjacent.rank - 1 && trg.file == right_adjacent.file) ||
      (trg.rank == right_adjacent.rank + 1 && trg.file == right_adjacent.file)
    end
  end

  def clean_adjacent(src, trg)
    left_adjacent = board[src.rank][src.file - 1]
    right_adjacent = board[src.rank][src.file + 1]

    if !left_adjacent.nil? && trg.file == left_adjacent.file
      clean(left_adjacent)
    elsif !right_adjacent.nil? && trg.file == right_adjacent.file
      clean(right_adjacent)
    end
  end

  def promotion?(trg) #eligible_for_promotion?(trg)
    (trg.is_a?(Pawn) && trg.rank == 0 && trg.color == 'white') ||
     (trg.is_a?(Pawn) && trg.rank == 7 && trg.color == 'black')
  end

  def promote(trg)
    puts "You pawn is eligible for promotion, please insert \n'B' for Bishop, 'N' for Knight, 'R' for Rook, 'Q' for Queen"
    input = gets.chomp
    new_piece = work_promotion_input(input, trg)
    place(new_piece)
  end

  def work_promotion_input(input, trg)
    if input.upcase == 'B'
      Bishop.new(trg.file, trg.rank, trg.color)
    elsif input.upcase == 'N'
      Knight.new(trg.file, trg.rank, trg.color)
    elsif input.upcase == 'R'
      Rook.new(trg.file, trg.rank, trg.color)
    elsif input.upcase == 'Q'
      Queen.new(trg.file, trg.rank, trg.color)
    end
  end

  def stalemate?(color)
    !in_check?(color) && no_legal_move_to_escape?(color)
  end

  #need to add side_to_move support, so
  #for each player threefold_repetition
  #or try to sort positions by odd and even 
  def threefold_repetition?(src, trg, color)
    actual_position = [piece_placement, en_passant?(src, trg), castling_rights(src.color)]
    positions.count { |position| position == actual_position } > 2
  end

  def piece_placement
    board.map { |row| row.map { |sq| sq.symbol if !sq.nil? } }
  end

  def fifty_move?
    halfmove_clock >= 100
  end

  def dead_position?
    bare_kings? || king_and_minor_vs_bare_king? || king_and_bishop_same_color?
  end
  
  def bare_kings?
    board.flatten.all? { |square| square.is_a?(King) || square.nil? }
  end

  def king_and_minor_vs_bare_king?
    minor_list = board.flatten.select { |square| !square.nil? && square.class != King }
    minor_list.size == 1 && (minor_list.first.is_a?(Bishop) || minor_list.first.is_a?(Knight))
  end

  def king_and_bishop_same_color?
    bishops = board.flatten.select { |square| !square.nil? && square.class != King }
    (bishops.size == 2 && bishops.first.is_a?(Bishop) && bishops.last.is_a?(Bishop)) &&
    (((bishops.first.rank - bishops.first.file).abs.even? && (bishops.last.rank - bishops.last.file).abs.even?) ||
    ((bishops.first.rank - bishops.first.file).abs.odd? && (bishops.last.rank - bishops.last.file).abs.odd?))
  end

  def fan(src, trg)
    if src.is_a?(Pawn)
      if capture?(src, trg)
        if placing_in_check?(src, trg)
          [convert_file_from(src.file), 'x', convert_file_from(trg.file), convert_rank_from(trg.rank), '+'].join
        elsif promotion?(trg)
          [convert_file_from(src.file), 'x', convert_file_from(trg.file), convert_rank_from(trg.rank), '=', promote(trg).symbol].join
        else
          [convert_file_from(src.file), 'x', convert_file_from(trg.file), convert_rank_from(trg.rank)].join
        end
      elsif en_passant?(src, trg)
        [convert_file_from(src.file), 'x', convert_file_from(trg.file), convert_rank_from(trg.rank), "e.p."].join
      elsif promotion?(trg)
        [convert_file_from(trg.file), convert_rank_from(trg.rank), '=', promote(trg).symbol].join
      elsif placing_in_check?(src, trg)
        [convert_file_from(trg.file), convert_rank_from(trg.rank), '+'].join
      else
        [convert_file_from(trg.file), convert_rank_from(trg.rank)].join
      end
    elsif src.is_a?(King) && (src.file - trg.file == -2 && src.rank == trg.rank)
      'O-O'
    elsif src.is_a?(King) && (src.file - trg.file == 2 && src.rank == trg.rank)
      'O-O-O'
    else
      if capture?(src, trg)
        if placing_in_check?(src, trg)
          [src.symbol, 'x', convert_file_from(trg.file), convert_rank_from(trg.rank), '+'].join
        else
          [src.symbol, 'x', convert_file_from(trg.file), convert_rank_from(trg.rank)].join
        end
      elsif placing_in_check?(src, trg)
        [src.symbol, convert_file_from(trg.file), convert_rank_from(trg.rank), '+'].join
      else
        [src.symbol, convert_file_from(trg.file), convert_rank_from(trg.rank)].join
      end
    end
  end

  def capture?(src, trg) #it's not capture, more target_sq_is_enemy?
    !board[trg.rank][trg.file].nil? && board[trg.rank][trg.file].color != src.color
  end

  def convert_file_from(column)
    (column.to_s.ord + 49).chr
  end

  def convert_rank_from(row)
    board.size - row
  end

  def placing_in_check?(src, trg)
    src.color == 'white' ? enemy_color = 'black' : enemy_color = 'white'
    original_trg = board[trg.rank][trg.file]

    place(trg)
    clean(src)
    if in_check?(enemy_color)
      place(src)
      board[trg.rank][trg.file] = original_trg
      true
    else
      place(src)
      board[trg.rank][trg.file] = original_trg
      false
    end
  end

  def white_pieces_taken
    pieces_taken.select  { |piece| piece if piece.color == 'white' }
                .map { |piece| piece.symbol }
  end

  def black_pieces_taken
    pieces_taken.select  { |piece| piece if piece.color == 'black' }
                .map { |piece| piece.symbol }
  end
end