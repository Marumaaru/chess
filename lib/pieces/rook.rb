class Rook
  attr_reader :name, :file, :rank, :parent, :color, :symbol
  
  MOVES = [[1, 0], [-1, 0], [0, 1], [0, -1]].freeze
  
  def initialize(file, rank, color, parent = nil) 
    @file = file
    @rank = rank
    @name = 'R'
    @color = color
    @symbol = assign_symbol_by(color)
    @parent = parent
    @children = []
  end

  def assign_symbol_by(color)
    color == 'white' ? "\u2656" : "\u265C"
  end
  
  def where_can_jump_from_here #legal_moves
    MOVES.map { |row, col| [row + file, col + rank] }
        .select { |row, col| row.between?(0,7) && col.between?(0,7) }
        .map { |coords| Rook.new(*coords, color, self) }
  end
end