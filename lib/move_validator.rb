module MoveValidator
  def valid_move?(src, trg)
    if src.is_a?(Pawn)
      pawn_move_is_valid?(src, trg)
    elsif src.is_a?(Knight)
      knight_move_is_valid?(src, trg)
    elsif src.is_a?(Bishop)
      bishop_move_is_valid?(src, trg)
    elsif src.is_a?(Rook)
      rook_move_is_valid?(src, trg)
    elsif src.is_a?(King)
      king_move_is_valid?(src, trg)
    elsif src.is_a?(Queen)
      queen_move_is_valid?(src, trg)
    end
  end

  def pawn_move_is_valid?(src, trg)
    if target_square_is_empty?(trg)
      pawn_move_forward?(src, trg) &&
        (pawn_regular_move?(src, trg) ||
        pawn_two_square_advance?(src, trg) ||
        (pawn_diagonal_move?(src, trg) && en_passant?(src, trg)))
    else
      pawn_move_forward?(src, trg) &&
        target_square_is_enemy?(src, trg) &&
        pawn_diagonal_move?(src, trg)
    end
  end

  def pawn_regular_move?(src, trg)
    (src.rank - trg.rank).abs == 1 && src.file == trg.file
  end

  def pawn_two_square_advance?(src, trg)
    (src.rank - trg.rank).abs == 2 && src.file == trg.file &&
    (src.rank == 1 || src.rank == 6)
  end

  def pawn_diagonal_move?(src, trg)
    (src.rank - trg.rank).abs == (src.file - trg.file).abs && (src.rank - trg.rank).abs == 1
  end

  def pawn_move_forward?(src, trg)
    (src.color == 'white' && (src.rank - trg.rank).positive?) ||
      (src.color == 'black' && (src.rank - trg.rank).negative?)
  end

  def knight_move_is_valid?(src, trg)
    ((src.file - trg.file).abs == 1 && (src.rank - trg.rank).abs == 2) ||
      ((src.file - trg.file).abs == 2 && (src.rank - trg.rank).abs == 1)
  end

  def bishop_move_is_valid?(src, trg)
    (src.rank - trg.rank).abs == (src.file - trg.file).abs
  end

  def rook_move_is_valid?(src, trg)
    src.rank == trg.rank || src.file == trg.file
  end

  def king_move_is_valid?(src, trg)
    (src.rank - trg.rank).abs <= 1 && (src.file - trg.file).abs <= 1
  end

  def queen_move_is_valid?(src, trg)
    ((src.rank - trg.rank).abs == (src.file - trg.file).abs) ||
      (src.rank == trg.rank || src.file == trg.file)
  end
end