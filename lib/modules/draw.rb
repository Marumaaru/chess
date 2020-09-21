# frozen_string_literal: true

# contains everything related to the Draw conditions
module Draw
  def draw?(color)
    stalemate?(color) || threefold_repetition? || fifty_move? || dead_position?
  end

  def stalemate?(color)
    !in_check?(color) && no_legal_move_to_escape?(color)
  end

  def threefold_repetition?
    positions.group_by(&:itself).transform_values(&:count).any? { |_k, v| v > 2 }
  end

  def piece_placement
    board.map { |row| row.map { |square| square&.symbol } }
    # board.map { |row| row.map { |square| square.symbol unless square.nil? } }
  end

  def fifty_move?
    halfmove_clock >= 100
  end

  def dead_position?
    bare_kings? || king_and_minor_vs_bare_king? || king_and_bishop_same_color?
  end

  def bare_kings?
    board.flatten.all? { |square| square.is_a?(King) || square.nil? }
  end

  def king_and_minor_vs_bare_king?
    pieces = find_pieces_except_king
    pieces.size == 1 && pieces.all? { |el| el.is_a?(Bishop) || el.is_a?(Knight) }
  end

  def king_and_bishop_same_color?
    pieces = find_pieces_except_king
    pieces.size == 2 &&
      pieces.all? { |piece| piece.is_a?(Bishop) } &&
      (pieces.all? { |piece| light_square?(piece) } ||
      pieces.all? { |piece| dark_square?(piece) })
  end

  def light_square?(piece)
    (piece.rank - piece.file).abs.even?
  end

  def dark_square?(piece)
    (piece.rank - piece.file).abs.odd?
  end

  def find_pieces_except_king
    board.flatten.select { |square| !square.nil? && square.class != King }
  end
end
