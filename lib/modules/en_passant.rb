# frozen_string_literal: true

module EnPassant
  def en_passant?(src, trg)
    correct_rank?(src) &&
      captured_is_adjacent?(src) &&
      last_is_double_pawn_push? &&
      immediate_capture_reply?(src, trg)
  end

  def correct_rank?(src)
    src.rank == 3 || src.rank == 4
  end

  def captured_is_adjacent?(src)
    left_adjacent_enemy_pawn?(src) || right_adjacent_enemy_pawn?(src)
  end

  def left_adjacent_enemy_pawn?(src)
    left_adjacent = board[src.rank][src.file - 1]
    left_adjacent.is_a?(Pawn) && left_adjacent.color != src.color
  end

  def right_adjacent_enemy_pawn?(src)
    right_adjacent = board[src.rank][src.file + 1]
    right_adjacent.is_a?(Pawn) && right_adjacent.color != src.color
  end

  def last_is_double_pawn_push?
    last_src = @history.last.first
    last_trg = @history.last.last
    last_trg.is_a?(Pawn) && (last_trg.rank - last_src.rank).abs == 2
  end

  def immediate_capture_reply?(src, trg)
    last_trg = @history.last.last
    last_trg == captured_adjacent(src, trg)
  end

  def captured_adjacent(src, trg)
    src.color == 'white' ? board[trg.rank + 1][trg.file] : board[trg.rank - 1][trg.file]
  end

  def clean_adjacent(src, trg)
    clean(captured_adjacent(src, trg))
  end

  def capture_en_passant_performed?(src, trg)
    return if @history.empty?

    previous_src = @history[@history.size - 2].first
    previous_trg = @history[@history.size - 2].last
    previous_trg.is_a?(Pawn) &&
      (previous_src.rank - previous_trg.rank).abs == 2 &&
      previous_trg == captured_adjacent(src, trg)
  end

  # def capture_en_passant_performed?(src, trg)
  #   previous_src = @history[@history.size - 2].first if @history.size > 2
  #   previous_trg = @history[@history.size - 2].last if @history.size > 2
  #   previous_trg.is_a?(Pawn) &&
  #     (previous_src.rank - previous_trg.rank).abs == 2 &&
  #     previous_trg.file == trg.file &&
  #     (previous_trg.rank == trg.rank - 1 ||
  #       previous_trg.rank == trg.rank + 1)
  # end

  # def capture_en_passant_performed?(src, trg)
  #   return if @history.empty?

  #   last_src = @history.last.first
  #   last_trg = @history.last.last
  #   last_is_double_pawn_push? &&
  #   last_trg.file == trg.file &&
  #   (last_trg.rank == trg.rank - 1 || last_trg.rank == trg.rank + 1) &&
  #   board[last_trg.rank][last_trg.file].nil?
  # end

  def en_passant_rights
    pawns = board.flatten.find_all { |square| square.is_a?(Pawn) }
    pawns.map { |pawn| correct_rank?(pawn) && captured_is_adjacent?(pawn) && last_is_double_pawn_push? }
  end
end
