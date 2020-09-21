# frozen_string_literal: true

# converts the move to the FAN format
module FanConverter
  def fan(src, trg, fan = [])
    fan.push(an_piece(src),
             an_pawn_capture(src, trg),
             an_capture(src, trg),
             an_trg_file(trg),
             an_trg_rank(trg),
             an_promotion(trg),
             an_en_passant(src, trg),
             an_check(src, trg))
    describe_castling(src, trg, fan)
    fan.join
  end

  def an_check(src, trg)
    '+' if placing_in_check?(src, trg)
  end

  def an_en_passant(src, trg)
    'e.p.' if en_passant?(src, trg)
  end

  def an_promotion(trg)
    "=#{promote(trg).symbol}" if promotion?(trg)
  end

  def an_capture(src, trg)
    'x' if capture?(trg) || en_passant?(src, trg)
  end

  def an_pawn_capture(src, trg)
    convert_file_from(src.file) if src.is_a?(Pawn) && (capture?(trg) || en_passant?(src, trg))
  end

  def an_piece(src)
    src.symbol unless src.is_a?(Pawn)
  end

  def an_trg_file(trg)
    convert_file_from(trg.file)
  end

  def an_trg_rank(trg)
    convert_rank_from(trg.rank)
  end

  def describe_castling(src, trg, fan)
    fan.clear.push('O-O') if request_for_castling?(src, trg) && trg.file == 6
    fan.clear.push('O-O-O') if request_for_castling?(src, trg) && trg.file == 2
  end

  def convert_file_from(column)
    (column.to_s.ord + 49).chr
  end

  def convert_rank_from(row)
    board.size - row
  end

  def placing_in_check?(src, trg)
    enemy_color = src.color == 'white' ? 'black' : 'white'
    original_trg = board[trg.rank][trg.file]
    place(trg)
    clean(src)
    result = in_check?(enemy_color)
    place(src)
    board[trg.rank][trg.file] = original_trg
    result
  end
end
