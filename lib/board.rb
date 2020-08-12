class Board
  attr_reader :board
  
  SIZE = 8

  def initialize
    @board = Array.new(SIZE) { Array.new(SIZE, ' ') }
  end

  def show
    puts "\n    a   b   c   d   e   f   g   h  "
    puts '  +---+---+---+---+---+---+---+---+'
    board.each_with_index do |row, idx|
      puts "#{board.size - idx} | " + row.each { |square| square }.join(' | ') + " | #{board.size - idx}"
      puts '  +---+---+---+---+---+---+---+---+'
    end
    puts '    a   b   c   d   e   f   g   h  '
  end

  def place(piece)
    board[piece.rank][piece.file] = piece.name
  end
end