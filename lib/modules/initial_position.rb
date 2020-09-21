# frozen_string_literal: true

# places pieces on their initial position
module InitialPosition
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
    Board::SIZE.times { |file| place(Pawn.new(file, 6, 'white')) }
  end

  def place_black_pawns
    Board::SIZE.times { |file| place(Pawn.new(file, 1, 'black')) }
  end
end
