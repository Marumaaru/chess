# frozen_string_literal: true

# contains everything related to the Castling move
module Castling
  def castling(trg)
    king = find_king(trg.color)
    rook = find_rook(trg)
    perform_switch(king, rook, trg)
    clean(rook)
    clean(king)
  end

  def perform_switch(king, rook, trg)
    if trg.file == 6
      kingside_castling(king, rook)
    elsif trg.file == 2
      queenside_castling(king, rook)
    end
  end

  def kingside_castling(king, rook)
    place(King.new(king.file + 2, king.rank, king.color))
    place(Rook.new(rook.file - 2, rook.rank, rook.color))
  end

  def queenside_castling(king, rook)
    place(King.new(king.file - 2, king.rank, king.color))
    place(Rook.new(rook.file + 3, rook.rank, rook.color))
  end

  def request_for_castling?(src, trg)
    src.is_a?(King) && ((src.file - trg.file).abs == 2 && src.rank == trg.rank)
  end

  def find_rook(trg)
    rooks = board.flatten.find_all do |square|
      square.is_a?(Rook) && square.color == trg.color
    end
    identify_rook(rooks, trg)
  end

  def identify_rook(rooks, trg)
    if trg.file == 6
      rooks.find { |rook| rook if rook.file == 7 }
    elsif trg.file == 2
      rooks.find { |rook| rook if rook.file == 0 }
    end
  end

  def castling_permissible?(trg)
    king = find_king(trg.color)
    rook = find_rook(trg)
    target_square_is_empty?(trg) &&
      no_obstacles_between?(king, trg) &&
      path_safe?(king, trg) &&
      first_move?(king) &&
      first_move?(rook)
  end

  def path_safe?(src, trg)
    enemy_color = src.color == 'white' ? 'black' : 'white'
    opponent_player_color_pieces = find_pieces_by(enemy_color)
    traversal = bfs_traversal(src, trg)
    route = route(traversal)
    squares_under_attack(opponent_player_color_pieces, route, src).flatten.none?
  end

  def squares_under_attack(opponent_player_color_pieces, route, src)
    opponent_player_color_pieces.map do |piece|
      route.map do |square|
        valid_move?(piece, src.class.new(*square, src.color)) &&
          no_obstacles_between?(piece, src.class.new(*square, src.color))
      end
    end
  end

  def first_move?(piece)
    @originals.flatten.find do |square|
      square.is_a?(piece.class) && square.color == piece.color && square.file == piece.file
    end.eql?(piece)
  end

  def save_originals_for_castling_check
    save_kings
    save_rooks
  end

  def save_kings
    @originals.push(board[7][4], board[0][4])
  end

  def save_rooks
    @originals.push(board[7][7], board[7][0], board[0][7], board[0][0])
  end

  def castling_rights
    white_king = find_king('white')
    black_king = find_king('black')
    [first_move?(white_king), first_move?(black_king)]
  end
end
