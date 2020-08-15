class Bishop
    attr_reader :name, :file, :rank, :parent
    
    MOVES = [[1, 1], [-1, -1], [-1, 1], [1, -1]].freeze

    # def initialize(file, rank, symbol = nil, parent = nil)
    def initialize(file, rank, parent = nil)
      @file = file
      @rank = rank
      @name = 'B'
      # @symbol = symbol
      @parent = parent
      @children = []
    end
    
    def where_can_jump_from_here #legal_moves
      MOVES.map { |row, col| [row + file, col + rank] }
          .select { |row, col| row.between?(0,7) && col.between?(0,7) }
          .map { |coords| Bishop.new(*coords, self) }
    end
  end