class Pawn
    attr_reader :name, :file, :rank, :parent
    
    MOVES = [0, 1].freeze
    
    def initialize(file, rank, parent = nil) 
      @file = file
      @rank = rank
      @name = 'P'
      # @symbol = symbol
      @parent = parent
      @children = []
    end
    
    def where_can_jump_from_here #legal_moves
      MOVES.map { |row, col| [row + file, col + rank] }
          .select { |row, col| row.between?(0,7) && col.between?(0,7) }
          .map { |coords| Pawn.new(*coords, self) }
    end
  end