require 'pry'
class Board
  attr_reader :board
  
  SIZE = 8
  EMPTY_SQUARE = ' '

  def initialize
    @board = Array.new(SIZE) { Array.new(SIZE, EMPTY_SQUARE) }
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
            (src.rank - trg.rank).abs == 1 && #otherwise can slide diagonally
            board[trg.rank][trg.file] != EMPTY_SQUARE
        unless board[trg.rank][trg.file].color == src.color
        # if board[trg.rank][trg.file].color != src.color
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
    traversal = bfs_traversal(src, trg)
    route = route(traversal)
  # bnding.pry
    if target_is_empty?(trg) || target_is_enemy?(src, trg)
      if route.size <= 2
        true
      elsif no_obstacles_on?(route)
        true
      else
        false
      end
    else
      false
    end
  end
  
  def no_obstacles_on?(route)
    route[1..route.size - 2].all? { |coords| board[coords[1]][coords[0]] == EMPTY_SQUARE }
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
        # if !in_check?(src) || src.is_a?(King)
        if !in_check?(src) || getting_out_of_check?(src, trg)
        # unless in_check?(src)
          place(trg)
          clean(src)
          # route[1..route.size-1].each { |move| board[move[1]][move[0]] = '*' }
          show
        else
  # binding.pry
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

  def in_check?(src)
    src.color == 'white' ? enemy_color = 'black' : enemy_color = 'white'
    opponent_player_color_pieces = find_pieces_by(enemy_color)
    current_player_king = find_kings.select { |king| king if king.color == src.color }.first
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
    if !in_check?(src)
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
    !ally_can_capture_checking_piece?(color) &&
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

  def ally_can_capture_checking_piece?(color)
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
end