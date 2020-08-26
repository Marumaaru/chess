require 'pry'
class Board
  attr_reader :board, :history
  
  SIZE = 8
  EMPTY_SQUARE = ' '

  def initialize
    @board = Array.new(SIZE) { Array.new(SIZE, EMPTY_SQUARE) }
    @history = []
  end

  def populate_board
    place_rooks
    place_knights
    place_bishops
    place_queens
    place_kings
    place_white_pawns
    place_black_pawns
    # originals = save_originals
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
    # @cloned = board
    # original_white_king = board[7][4]
    # original_black_king = board[0][4]
    # original_white_kingside_rook = board[7][7]
    # original_white_queenside_rook = board[7][0]
    # original_black_kingside_rook = board[0][7]
    # original_black_queenside_rook = board[0][0]
    @originals = [board[7][4], board[0][4], board[7][7], board[7][0], board[0][7], board[0][0]]
  end


  #define special moves: postponed
  #King: castling
  #Pawn: en passant and promotion

  #create a Module 'Move_Validator'
  #put there valid_move?(src, trg)
  #create a separate test file & copy-paste
  #refactor heavily!!!(or it's better wait and then refactor)

  def valid_move?(src, trg)
    if src.class == Pawn
      if (src.rank - trg.rank).abs == 1 && src.file == trg.file &&
        board[trg.rank][trg.file] == EMPTY_SQUARE
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
        board[trg.rank][trg.file] == EMPTY_SQUARE
        if src.rank == 6 || src.rank == 1
          true
        else
          # puts "Invalid move"
          false
        end
      elsif (src.rank - trg.rank).abs == (src.file - trg.file).abs &&
            (src.rank - trg.rank).abs == 1 #&& otherwise can slide diagonally
            # board[trg.rank][trg.file] != EMPTY_SQUARE
        # unless board[trg.rank][trg.file].color == src.color
        if board[trg.rank][trg.file] != EMPTY_SQUARE && 
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
        elsif board[trg.rank][trg.file] == EMPTY_SQUARE && 
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

  # def origin_square(from)
  #   board[from[1]][from[0]]
  # end

  # def target_square(from, to)
  #   from.class.new(to[0], to[1])
  # end

  def path_free?(src, trg)
    if target_is_empty?(trg) || target_is_enemy?(src, trg)
      # if route.size <= 2
        # true
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
# binding.pry
    if route.size <= 2
      true
    else
      route[1..route.size - 2].all? { |coords| board[coords[1]][coords[0]] == EMPTY_SQUARE }
    end
  end

  def target_is_enemy?(src, trg)
    src.color != board[trg.rank][trg.file].color
  end

  def target_is_empty?(trg)
    board[trg.rank][trg.file] == EMPTY_SQUARE
  end

  def enemy?(from, to) #trg_square_enemy?
    board[from[1]][from[0]].color != board[to[1]][to[0]].color
  end

  def empty?(coords)
    board[coords[1]][coords[0]] == EMPTY_SQUARE
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
  # binding.pry
    if valid_move?(src, trg)
      if path_free?(src, trg)
        if !in_check?(src.color) || getting_out_of_check?(src, trg)
          place(trg)
          clean(src)
          clean_adjacent(src, trg) if en_passant?(src, trg)
          promote(trg) if promotion?(trg)
          history << [from, to]
          # route[1..route.size-1].each { |move| board[move[1]][move[0]] = '*' }
          show
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

  def show
    puts "\n    a   b   c   d   e   f   g   h  "
    puts '  +---+---+---+---+---+---+---+---+'
    mapped_board.each_with_index do |row, idx|
      puts "#{board.size - idx} | " + row.join(' | ') + " | #{board.size - idx}"
      puts '  +---+---+---+---+---+---+---+---+'
    end
    puts '    a   b   c   d   e   f   g   h  '
  end

  def mapped_board
    board.map do |row|
      row.map do |square| 
        if square == EMPTY_SQUARE
          EMPTY_SQUARE
        elsif square == '*'
          '*'
        else
          square.symbol
          # square.name
        end
      end
    end
  end

  def place(piece)
    board[piece.rank][piece.file] = piece
  end

  def clean(piece)
    board[piece.rank][piece.file] = EMPTY_SQUARE
  end

  # def find_pieces_by(input)
  #   first_letter = input.split('').first
  #   list_of_pieces = []
  #   board.each do |row|
  #     row.each do |square|
  #       list_of_pieces << square if square.name.eql?(first_letter) unless square == EMPTY_SQUARE
  #     end
  #   end
  #   list_of_pieces
  # end

  def find_pieces_by(color)
    list_of_pieces = []
    board.each do |row|
      row.each do |square|
        list_of_pieces << square if square.color == color unless square == EMPTY_SQUARE
      end
    end
    list_of_pieces
  end

  def find_kings
    list_of_pieces = []
    board.each do |row|
      row.each do |square|
        list_of_pieces << square if square.name == 'K' unless square == EMPTY_SQUARE
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

  # def getting_out_of_check?(src, trg)
  #   place(trg)
  #   clean(src)
  #   if !in_check?(src)
  #     place(src)
  #     clean(trg)
  #     true
  #   else
  #     place(src)
  #     clean(trg)
  #     false
  #   end
  # end

  def getting_out_of_check?(src, trg)
    original_trg = board[trg.rank][trg.file]
    trg = src.class.new(trg.file, trg.rank, src.color)
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
                                    .select { |row, col| board[col][row] == EMPTY_SQUARE || board[col][row].color != current_player_king.color }
                                    .map { |coords| King.new(*coords, current_player_king.color) }
                                    .none? { |move| getting_out_of_check?(current_player_king, move) }
  end

  def no_capture_moves?(color) #Can delete because inside #no_legal_move_to_escape
    current_player_color_pieces = find_pieces_by(color)
    current_player_king = find_kings.select { |king| king if king.color == color }.first
    current_player_king.class::MOVES.map { |row, col| [row + current_player_king.file, col + current_player_king.rank] }
                                    .select { |row, col| row.between?(0,7) && col.between?(0,7) }
                                    .select { |row, col| board[col][row].color != current_player_king.color unless board[col][row] == EMPTY_SQUARE }
                                    .map { |coords| King.new(*coords, current_player_king.color) }
                                    .none? { |move| getting_out_of_check?(current_player_king, move) }
  end

  def no_empty_squares_not_under_attack?(color) #no_safe_squares #Can delete because inside #no_legal_move_to_escape
    current_player_color_pieces = find_pieces_by(color)
    current_player_king = find_kings.select { |king| king if king.color == color }.first
    current_player_king.class::MOVES.map { |row, col| [row + current_player_king.file, col + current_player_king.rank] }
                                    .select { |row, col| row.between?(0,7) && col.between?(0,7) }
                                    .select { |row, col| board[col][row] == EMPTY_SQUARE }
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
  # binding.pry #could be solved with .none? or .any? like in #path_safe?
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

  #DRY to unique #castling(color)
  # def short_castling(color)
  #   if color == 'white'
  #     king_original_pos = board[7][4]
  #     rook_kingside_original_pos = board[7][7]
  #     place(King.new(6, 7, color))
  #     place(Rook.new(5, 7, color))
  #     clean(king_original_pos)
  #     clean(rook_kingside_original_pos)
  #   else
  #     king_original_pos = board[0][4]
  #     rook_kingside_original_pos = board[0][7]
  #     place(King.new(6, 0, color))
  #     place(Rook.new(5, 0, color))
  #     clean(king_original_pos)
  #     clean(rook_kingside_original_pos)
  #   end
  # end

  # def long_castling(color)
  #   if color == 'white'
  #     king_original_pos = board[7][4]
  #     rook_queenside_original_pos = board[7][0]
  #     place(King.new(2, 7, color))
  #     place(Rook.new(3, 7, color))
  #     clean(king_original_pos)
  #     clean(rook_kingside_original_pos)
  #   else
  #     king_original_pos = board[0][4]
  #     rook_queenside_original_pos = board[0][0]
  #     place(King.new(2, 0, color))
  #     place(Rook.new(3, 0, color))
  #     clean(king_original_pos)
  #     clean(rook_queenside_original_pos)
  #   end
  # end

  def castling(color, input)
    king = find_king(color)
    rook = find_rook(color, input)
    if input == '00'
      place(King.new(king.file + 2, king.rank, color))
      place(Rook.new(rook.file - 2, rook.rank, color))
    else
      place(King.new(king.file - 2, king.rank, color))
      place(Rook.new(rook.file + 3, rook.rank, color))
    end
    clean(king)
    clean(rook)
  end

  #IDEA FOR REFACTORING
  # if input == '00'
  #   short_castling(king, rook, color)
  # else
  #   long_castling(king, rook)
  # end

  # def short_castling(king, rook, color)
  #   place(King.new(king.file + 2, king.rank, color))
  #   place(Rook.new(rook.file - 2, rook.rank, color))
  #   clean(king)
  #   clean(rook)
  # end

  # def long_castling(king, rook, color)
  #   place(King.new(king.file - 2, king.rank, color))
  #   place(Rook.new(rook.file + 3, rook.rank, color))
  #   clean(king)
  #   clean(rook)
  # end

  # def perform_switch(king, rook)

  # end

  def castling_permissible?(color, input)
    king = find_king(color)
    rook = find_rook(color, input)
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

    opponent_player_color_pieces.none? do |piece| 
      route.each do |square|
        piece if valid_move?(piece, src.class.new(*square, src.color)) && 
                 path_free?(piece, src.class.new(*square, src.color))
      end
    end
  end

  # def king_first_move?(king)
  #   original_king = @originals.flatten.find { |square| square.is_a?(King) && square.color == king.color }
  #   original_king.eql?(king)
  # end

  # def rook_first_move?(rook)
  #   original_rook = @originals.flatten.find { |square| square.is_a?(Rook) && square.color == rook.color && square.file == rook.file }
  #   original_rook.eql?(rook)
  # end

  def first_move?(piece) #do not like original (maybe INITIAL) and square here
    original = @originals.flatten.find do |square| 
      square.is_a?(piece.class) && 
      square.color == piece.color &&
      square.file == piece.file
    end
    original.eql?(piece)
  end

  #WAS AN IDEA! NOT very good but elegant
  #it adds an additional square to the path
  #adds a square from the piece has arrived previsouly
  #i.e. parent

  # def first_move?(piece)
  #   piece.parent.nil?
  # end

  def find_king(color)
    board.flatten.find { |square| square.is_a?(King) && square.color == color }
  end

  #magic numbers 7 and 0
  def find_rook(color, input)
    rooks = board.flatten.find_all { |square| square.is_a?(Rook) && square.color == color }
    if input == '00'
      rooks.find { |rook| rook if rook.file == 7 }
    else
      rooks.find { |rook| rook if rook.file == 0 }
    end
  end

  def en_passant?(src, trg)
    correct_rank?(src) && 
    adjacent?(src) && 
    just_double_moved?(src) &&
    capture?(src, trg)
  end

  def correct_rank?(src)
    src.rank == 3 || src.rank == 4
  end

  def adjacent?(src)
    src.color == 'white' ? enemy_color = 'black' : enemy_color = 'white'
    left_adjacent = board[src.rank][src.file - 1]
    right_adjacent = board[src.rank][src.file + 1]
    #left_adjacent.is_a?(Pawn)
    (left_adjacent != EMPTY_SQUARE && left_adjacent.color == enemy_color) ||
     (right_adjacent != EMPTY_SQUARE && right_adjacent.color == enemy_color)
  end

  def just_double_moved?(src)
    left_adjacent = board[src.rank][src.file - 1]
    right_adjacent = board[src.rank][src.file + 1]

    last_trg_rank = @history.last.last.last
    last_trg_file = @history.last.last.first
    last_src_rank = @history.last.first.last
    last_src_file = @history.last.first.first

    # if (last_trg_rank - last_src_rank).abs == 2
    #   if left_adjacent.is_a?(Pawn) &&
    #     left_adjacent.rank == last_trg_rank
    #     true
    #   elsif right_adjacent.is_a?(Pawn) &&
    #     right_adjacent.rank == last_trg_rank
    #     true
    #   else
    #     false
    #   end
    # else
    #   false
    # end

    (last_trg_rank - last_src_rank).abs == 2 &&
    ((right_adjacent.is_a?(Pawn) && right_adjacent.rank == last_trg_rank) || 
    (left_adjacent.is_a?(Pawn) && left_adjacent.rank == last_trg_rank))

  end

  def capture?(src, trg)
    left_adjacent = board[src.rank][src.file - 1]
    right_adjacent = board[src.rank][src.file + 1]
    if left_adjacent != EMPTY_SQUARE
      (trg.rank == left_adjacent.rank - 1 && trg.file == left_adjacent.file) ||
      (trg.rank == left_adjacent.rank + 1 && trg.file == left_adjacent.file)
    elsif right_adjacent != EMPTY_SQUARE
      (trg.rank == right_adjacent.rank - 1 && trg.file == right_adjacent.file) ||
      (trg.rank == right_adjacent.rank + 1 && trg.file == right_adjacent.file)
    end
  end

  def clean_adjacent(src, trg)
    left_adjacent = board[src.rank][src.file - 1]
    right_adjacent = board[src.rank][src.file + 1]

    if left_adjacent != EMPTY_SQUARE && trg.file == left_adjacent.file
      clean(left_adjacent)
    elsif right_adjacent != EMPTY_SQUARE && trg.file == right_adjacent.file
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

end