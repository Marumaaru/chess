class Bishop
    attr_reader :name, :file, :rank  
    
  #   MOVES = [[1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [-2, 1], [2, -1], [-2, -1]].freeze
    
    def initialize(file, rank, parent = nil) 
      @file = file
      @rank = rank
      @name = 'B'
      @parent = parent
      @children = []
    end
    
  #   def where_can_jump_from_here(file, rank) #legal_moves
  #     MOVES.map { |row, col| [row + file, col + rank] }
  #         .select { |row, col| row.between?(0,7) && col.between(0,7) }
  #         .map { |coords| Knight.new(*coords, self) }
  #   end
  end