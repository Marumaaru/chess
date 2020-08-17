require 'pry'
class Board
  attr_reader :board
  
  SIZE = 8
  EMPTY_SQUARE = ' '

  def initialize
    @board = Array.new(SIZE) { Array.new(SIZE, EMPTY_SQUARE) }
  end

  def valid_move?(src, trg)
    if src.class == Pawn
      if src.rank == 6 || src.rank == 1
        if (src.rank - trg.rank).abs <= 2
          true
        else
          puts "Invalid move"
          false
        end
      elsif src.color == 'white'
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
      else
        if (src.rank - trg.rank).abs == 1 && src.file == trg.file
          true
        else
          puts "Invalid move"
          false
        end
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
      if (src.rank - trg.rank).abs == (src.file - trg.file).abs ||
          src.rank == trg.rank || src.file == trg.file
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

  def path_free?(route)
    route[1..route.size].all? { |coords| board[coords[1]][coords[0]] == EMPTY_SQUARE }
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
    # bfs_traversal(src, trg)
    traversal = bfs_traversal(src, trg)
    route = route(traversal)
    if path_free?(route) && valid_move?(src, trg)
      place(trg)
      clean(src)
      show
    end
    # route.each { |move| board[move[1]][move[0]] = '*' }
  end

  #Queen and Pawn non working moves!


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
          # square.symbol
          square.name
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