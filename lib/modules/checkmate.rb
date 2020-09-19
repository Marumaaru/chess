# frozen_string_literal: true

module Checkmate
  def checkmate?(color)
    in_check?(color) &&
      no_legal_move_to_escape?(color) &&
      no_ally_can_capture_checking_piece?(color) &&
      no_ally_can_block_checking_piece?(color)
  end

  def no_legal_move_to_escape?(color)
    current_player_king = find_king(color)
    all_moves = current_player_king.where_can_jump_from_here
    valid_moves = all_moves.select do |move|
      target_square_is_empty?(move) ||
        target_square_is_enemy?(current_player_king, move)
    end
    valid_moves.none? { |move| getting_out_of_check?(current_player_king, move) } if valid_moves.any?
  end

  def find_attackers(color)
    enemy_color = color == 'white' ? 'black' : 'white'
    current_player_king = find_king(color)
    opponent_player_color_pieces = find_pieces_by(enemy_color)
    opponent_player_color_pieces.select do |piece|
      piece if valid_move?(piece, current_player_king) &&
               path_free?(piece, current_player_king)
    end
  end

  def no_ally_can_capture_checking_piece?(color)
    current_player_color_pieces = find_pieces_by(color).reject { |piece| piece.is_a?(King) }
    attackers = find_attackers(color)
    defenders = find_defenders(current_player_color_pieces, attackers)
    attackers.any? && defenders.none?
  end

  def find_defenders(current_player_color_pieces, attackers)
    current_player_color_pieces.map do |piece|
      attackers.map do |attacker|
        valid_move?(piece, attacker) &&
          path_free?(piece, attacker) &&
          getting_out_of_check?(piece, attacker)
      end
    end.flatten
  end

  def no_ally_can_block_checking_piece?(color)
    current_player_color_pieces = find_pieces_by(color)
    current_player_king = find_king(color)
    attackers = find_attackers(color)
    blockers = find_blockers(current_player_color_pieces, attackers, current_player_king)
    attackers.any? && blockers.none?
  end

  def find_blockers(current_player_color_pieces, attackers, current_player_king)
    current_player_color_pieces.map do |piece|
      attackers.map do |attacker|
        traversal = bfs_traversal(attacker, current_player_king)
        route = route(traversal)
        blockable_squares(route, piece, attacker, current_player_king)
      end
    end.flatten
  end

  def blockable_squares(route, piece, attacker, current_player_king)
    route[1..route.size - 2].map do |square|
      valid_move?(piece, attacker.class.new(*square, attacker.color)) &&
        path_free?(piece, attacker.class.new(*square, attacker.color)) &&
        piece != current_player_king
    end
  end
end
