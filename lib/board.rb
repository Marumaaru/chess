# frozen_string_literal: true

require './lib/move_validator'
require './lib/colorable'
require './lib/displayable'
require './lib/bishop'
require './lib/knight'
require './lib/rook'
require './lib/queen'
require './lib/king'
require './lib/pawn'

require 'pry'

class Board
  include MoveValidator
  include Colorable
  include Displayable

  attr_reader :board, :history, :positions, :originals, :halfmove_clock, :move_record, :pieces_taken

  SIZE = 8

  def initialize
    @board = Array.new(SIZE) { Array.new(SIZE) }
    @history = []
    @positions = []
    @originals = []
    @halfmove_clock = 0
    @move_record = []
    @pieces_taken = []
  end

  def populate_board
    place_rooks
    place_knights
    place_bishops
    place_queens
    place_kings
    save_originals
    place_white_pawns
    place_black_pawns
  end

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
    SIZE.times { |file| place(Pawn.new(file, 6, 'white')) }
  end

  def place_black_pawns
    SIZE.times { |file| place(Pawn.new(file, 1, 'black')) }
  end

  # initial_piece_placement
  def save_originals
    save_kings
    save_rooks
  end

  def save_kings
    @originals.push(board[7][4], board[0][4])
  end

  def save_rooks
    @originals.push(board[7][7], board[7][0], board[0][7], board[0][0])
  end

  # path_legal?
  def path_free?(src, trg)
    (target_square_is_empty?(trg) || target_square_is_enemy?(src, trg)) &&
      no_obstacles_between?(src, trg)
  end

  def no_obstacles_between?(src, trg)
    traversal = bfs_traversal(src, trg)
    route = route(traversal)
    route.size <= 2 || all_squares_are_empty_on?(route)
  end

  def all_squares_are_empty_on?(route)
    route[1..route.size - 2].all? { |coords| board[coords[1]][coords[0]].nil? }
  end

  def target_square_is_empty?(trg)
    board[trg.rank][trg.file].nil?
  end

  def target_square_is_enemy?(src, trg)
    board[trg.rank][trg.file].color != src.color
  end

  def bfs_traversal(src, trg, queue = [])
    queue << src
    until queue.empty?
      current = queue.shift
      return current if current.file == trg.file && current.rank == trg.rank

      current.where_can_jump_from_here.each { |child| queue << child }
    end
  end

  def route(node, route = [])
    if node.parent.nil?
      route << [node.file, node.rank]
      return route
    end
    route(node.parent, route)
    route << [node.file, node.rank]
  end

  def activate_piece(rank, file)
    board[rank][file]
  end

  def piece_moves(src, trg)
    update_game_record(src, trg)
    update_board(src, trg)
  end

  def legal_move?(src, trg)
    (valid_move?(src, trg) &&
    path_free?(src, trg) &&
    (!in_check?(src.color) || getting_out_of_check?(src, trg))) ||
      (request_for_castling?(src, trg) && castling_permissible?(trg))
  end

  def update_game_record(src, trg)
    move_record << fan(src, trg)
    update_pieces_taken(src, trg)
    positions << [src.color, piece_placement, en_passant_rights, castling_rights]
    history << [src, trg]
  end

  def update_pieces_taken(src, trg)
    pieces_taken << board[trg.rank][trg.file] if capture?(trg)
    pieces_taken << captured_adjacent(src, trg) if en_passant?(src, trg)
  end

  def update_board(src, trg)
    castling(trg) if request_for_castling?(src, trg) && castling_permissible?(trg)
    place(trg)
    clean(src)
    clean_adjacent(src, trg) if capture_en_passant_performed?(src, trg)
    promote(trg) if promotion?(trg)
  end

  def show_error(src, trg)
    invalid_move_check(src) ||
      invalid_move(src, trg) ||
      invalid_move_path(src, trg) ||
      invalid_move_castling(src, trg)
  end

  def invalid_move_check(src)
    return unless in_check?(src.color)

    print display_error_invalid_move_check
  end

  def invalid_move(src, trg)
    return unless !valid_move?(src, trg) && !request_for_castling?(src, trg)

    print display_error_invalid_move(src)
  end

  def invalid_move_path(src, trg)
    return unless !path_free?(src, trg) && valid_move?(src, trg) && !request_for_castling?(src, trg)

    print display_error_invalid_move_path
  end

  def invalid_move_castling(src, trg)
    return unless request_for_castling?(src, trg) && !castling_permissible?(trg)

    print display_error_invalid_move_castling
  end

  def update_halfmove_clock(src, trg)
    if capture?(trg) || src.is_a?(Pawn)
      @halfmove_clock = 0
    else
      @halfmove_clock += 1
    end
  end

  def notation_window
    move_record.each_slice(2).to_a.each_with_index
               .map { |move, idx| "\e[94m#{idx + 1}.\e[0m #{move.join(' ')}" }
               .each_slice(4).to_a
  end

  def show
    puts '     a  b  c  d  e  f  g  h'
    checkered_board.size.times do |idx|
      printf("%<rank>3s %<board>-26s %<rank>-3s %<notation_window>-20s\n",
             { rank: "#{board.size - idx}",
               board: checkered_board[idx].join,
               notation_window: show_move_notation(idx) })
    end
    puts '     a  b  c  d  e  f  g  h'
  end

  def show_move_notation(idx)
    if notation_window[idx].nil?
      ''
    else
      notation_window[idx].join(' ')
    end
  end

  def checkered_board
    board.map.with_index do |row, row_idx|
      row.map.with_index do |square, square_idx|
        if square.nil?
          paint_empty_squares(row_idx, square_idx)
        else
          paint_populated_squares(row_idx, square_idx, square)
        end
      end
    end
  end

  def paint_empty_squares(row_idx, square_idx)
    if (row_idx - square_idx).abs.odd?
      black_on_lt_blue('   ')
    else
      black_on_gray('   ')
    end
  end

  def paint_populated_squares(row_idx, square_idx, square)
    if (row_idx - square_idx).abs.odd?
      black_on_lt_blue(" #{square.symbol} ")
    else
      black_on_gray(" #{square.symbol} ")
    end
  end

  def place(piece)
    board[piece.rank][piece.file] = piece
  end

  def clean(piece)
    board[piece.rank][piece.file] = nil
  end

  def find_king(color)
    board.flatten.find { |square| square.is_a?(King) && square.color == color }
  end

  def find_pieces_by(color)
    board.flatten.find_all { |square| !square.nil? && square.color == color }
  end

  def in_check?(color)
    enemy_color = color == 'white' ? 'black' : 'white'
    opponent_player_color_pieces = find_pieces_by(enemy_color)
    current_player_king = find_king(color)
    opponent_player_color_pieces.any? do |piece|
      valid_move?(piece, current_player_king) &&
        path_free?(piece, current_player_king)
    end
  end

  def getting_out_of_check?(src, trg)
    original_trg = board[trg.rank][trg.file]
    make_simulation(src, trg)
    result = !in_check?(src.color)
    revert_changes(src, trg, original_trg)
    result
  end

  def make_simulation(src, trg)
    place(trg)
    clean(src)
  end

  def revert_changes(src, trg, original_trg)
    place(src)
    board[trg.rank][trg.file] = original_trg
  end

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
    current_player_color_pieces = find_pieces_by(color)
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

  def castling_rights
    white_king = find_king('white')
    black_king = find_king('black')
    [first_move?(white_king), first_move?(black_king)]
  end

  def en_passant_rights
    pawns = board.flatten.find_all { |square| square.is_a?(Pawn) }
    pawns.map { |pawn| correct_rank?(pawn) && captured_is_adjacent?(pawn) && last_is_double_pawn_push? }
  end

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
    previous_src = @history[@history.size - 2].first
    previous_trg = @history[@history.size - 2].last
    previous_trg.is_a?(Pawn) &&
      (previous_src.rank - previous_trg.rank).abs == 2 &&
      previous_trg == captured_adjacent(src, trg)
  end

  def promotion?(trg)
    (trg.is_a?(Pawn) && trg.rank == 0 && trg.color == 'white') ||
      (trg.is_a?(Pawn) && trg.rank == 7 && trg.color == 'black')
  end

  def promote(trg)
    print display_promotion_prompt
    input = gets.chomp
    new_piece = transform(input.upcase, trg)
    place(new_piece)
  end

  def transform(input, trg)
    case input
    when 'B'
      transform_to_bishop(trg)
    when 'N'
      transform_to_knight(trg)
    when 'R'
      transform_to_rook(trg)
    when 'Q'
      transform_to_queen(trg)
    end
  end

  def transform_to_bishop(trg)
    Bishop.new(trg.file, trg.rank, trg.color)
  end

  def transform_to_knight(trg)
    Knight.new(trg.file, trg.rank, trg.color)
  end

  def transform_to_rook(trg)
    Rook.new(trg.file, trg.rank, trg.color)
  end

  def transform_to_queen(trg)
    Queen.new(trg.file, trg.rank, trg.color)
  end

  def draw?(color)
    stalemate?(color) || threefold_repetition? || fifty_move? || dead_position?
  end

  def stalemate?(color)
    !in_check?(color) &&
      no_legal_move_to_escape?(color) &&
      no_ally_can_capture_checking_piece?(color) &&
      no_ally_can_block_checking_piece?(color)
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
      pieces.all? do |piece|
        piece.is_a?(Bishop) &&
          ((piece.rank - piece.file).abs.even? ||
           (piece.rank - piece.file).abs.odd?)
      end
  end

  def find_pieces_except_king
    board.flatten.select { |square| !square.nil? && square.class != King }
  end

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

  def capture?(trg)
    !board[trg.rank][trg.file].nil? && board[trg.rank][trg.file].color != trg.color
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

  def white_pieces_taken
    pieces_taken.select { |piece| piece if piece.color == 'white' }.map(&:symbol)
  end

  def black_pieces_taken
    pieces_taken.select { |piece| piece if piece.color == 'black' }.map(&:symbol)
  end
end
