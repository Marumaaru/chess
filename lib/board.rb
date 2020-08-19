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
  
  def valid_move?(src, trg)
    if src.class == Pawn
      if (src.rank - trg.rank).abs == 1 && src.file == trg.file
        if src.color == 'white'
          if (src.rank - trg.rank) > 0
            true
          else
            puts "Invalid move"
            false
          end
        elsif src.color == 'black'
          if (src.rank - trg.rank) < 0
            true
          else
            puts "Invalid move"
            false
          end
        end
      elsif (src.rank - trg.rank).abs == 2
        if src.rank == 6 || src.rank == 1
          true
        else
          puts "Invalid move"
          false
        end
      elsif (src.rank - trg.rank).abs == (src.file - trg.file).abs && 
            board[trg.rank][trg.file] != EMPTY_SQUARE
        unless board[trg.rank][trg.file].color == src.color
        # if board[trg.rank][trg.file].color != src.color
          true
        else
          puts "Invalid move"
          false
        end
      else
        puts "Invalid move"
        false
      end
    elsif src.class == Knight
      if ((src.file - trg.file).abs == 1 && (src.rank - trg.rank).abs == 2) ||
        ((src.file - trg.file).abs == 2 && (src.rank - trg.rank).abs == 1)
        true
      else
        puts 'Invalid move'
        false
      end
    elsif src.class == Bishop
      if (src.rank - trg.rank).abs == (src.file - trg.file).abs
        true
      else
        puts 'Invalid move'
        false
      end
    elsif src.class == Rook
      if src.rank == trg.rank || src.file == trg.file
        true
      else
        puts 'Invalid move'
        false
      end
    elsif src.class == King
      if (src.rank - trg.rank).abs <= 1 && (src.file - trg.file).abs <= 1
        true
      else
        puts 'Invalid move'
        false
      end
    elsif src.class == Queen
      if (src.rank - trg.rank).abs == (src.file - trg.file).abs
        true
      elsif src.rank == trg.rank || src.file == trg.file
        true
      else
        puts 'Invalid move'
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
    if src.class == Queen
      bishop_traversal = bfs_traversal(Bishop.new(src.file, src.rank, src.color), Bishop.new(trg.file, trg.rank, trg.color))
      bishop_route = route(bishop_traversal)
      rook_traversal = bfs_traversal(Rook.new(src.file, src.rank, src.color), Rook.new(trg.file, trg.rank, trg.color))
      rook_route = route(rook_traversal)
      bishop_route[1..bishop_route.size].all? { |coords| board[coords[1]][coords[0]] == EMPTY_SQUARE } &&
      rook_route[1..rook_route.size].all? { |coords| board[coords[1]][coords[0]] == EMPTY_SQUARE }
    else
      traversal = bfs_traversal(src, trg)
      route = route(traversal)
      route[1..route.size].all? { |coords| board[coords[1]][coords[0]] == EMPTY_SQUARE }
    end
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
    if valid_move?(src, trg)
      if path_free?(src, trg)
        place(trg)
        clean(src)
        # route[1..route.size-1].each { |move| board[move[1]][move[0]] = '*' }
        show
      else
        if empty?(to)
          puts "Invalid move: the path is not free"
        elsif enemy?(from, to)
          place(trg)
          clean(src)
          show
        else
          puts "Invalid move: the path is not free"
        end
      end
    end
    # route.each { |move| board[move[1]][move[0]] = '*' }
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

  def find_pieces_by(input)
    first_letter = input.split('').first
    list_of_pieces = []
    board.each do |row|
      row.each do |square|
        list_of_pieces << square if square.name.eql?(first_letter) unless square == EMPTY_SQUARE
      end
    end
    list_of_pieces
  end
end