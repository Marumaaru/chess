module InCheck
  def in_check?(color)
    enemy_color = color == 'white' ? 'black' : 'white'
    opponent_player_color_pieces = find_pieces_by(enemy_color)
    current_player_king = find_king(color)
    opponent_player_color_pieces.any? do |piece|
      valid_move?(piece, current_player_king) &&
        path_free?(piece, current_player_king)
    end
  end

  def find_king(color)
    board.flatten.find { |square| square.is_a?(King) && square.color == color }
  end

  def find_pieces_by(color)
    board.flatten.find_all { |square| !square.nil? && square.color == color }
  end

  def getting_out_of_check?(src, trg)
    original_trg = board[trg.rank][trg.file]
    make_simulation(src, trg)
    result = !in_check?(src.color)
    revert_changes(src, trg, original_trg)
    result
  end

  def make_simulation(src, trg)
    fake_trg = src.class.new(trg.file, trg.rank, src.color)
    place(fake_trg)
    clean(src)
  end

  def revert_changes(src, trg, original_trg)
    place(src)
    board[trg.rank][trg.file] = original_trg
  end
end