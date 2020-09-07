require './lib/move_validator'
require './lib/colorable'

require 'pry'

class Board
  include MoveValidator
  include Colorable

  attr_reader :board, :history, :positions, :originals, :halfmove_clock, :move_sequence, :pieces_taken

  SIZE = 8

  def initialize
    @board = Array.new(SIZE) { Array.new(SIZE) }
    @history = []
    @positions = []
    @originals = []
    @halfmove_clock = 0
    @move_sequence = []
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

  # def piece_moves(from, to)
  def piece_moves(src, trg)
    update_game_statistics(src, trg)
    update_board(src, trg)
    show
    # elsif draw?(color)

    # elsif checkmate?(src.color)

    # if valid_move?(src, trg)
    #   if path_free?(src, trg)
    #     if !in_check?(src.color) || getting_out_of_check?(src, trg)
    #       if draw?(color)
    #         puts 'Claim draw?'
    #       else
    #         move_sequence << fan(src, trg)
    #         pieces_taken << board[trg.rank][trg.file] if capture?(src, trg)
    #         # src.color replace by side_to_move/color
    #         positions << [src.color, piece_placement, en_passant_rights, castling_rights]
    #         history << [src, trg]
    #         update_halfmove_clock(src, trg)
    #         place(trg)
    #         clean(src)
    #         clean_adjacent(src, trg) if en_passant?(src, trg)
    #         promote(trg) if promotion?(trg)
    #       end
    #       show
    #       report
    #     else
    #       if checkmate?(src.color)
    #         puts 'Checkmate'
    #       else
    #         puts "Invalid move: You're in check"
    #       end
    #     end
    #   else
    #     puts 'Invalid move: the path is not free'
    #   end
    # elsif request_for_castling?(src, trg)
    #   if castling_permissible?(trg)
    #     move_sequence << fan(src, trg) # keep before #castling otherwise will not clear the king
    #     castling(trg)
    #     # src.color replace by side_to_move/color
    #     positions << [src.color, piece_placement, en_passant_rights, castling_rights]
    #     show
    #     report
    #   else
    #     puts 'Castling is not possible'
    #   end
    # else
    #   puts 'Invalid move'
    # end
  end

  # def correct_color?(src, side_to_move)
  #   src.color == side_to_move
  # end

  def legal_move?(src, trg)
    (valid_move?(src, trg) &&
    path_free?(src, trg) &&
    (!in_check?(src.color) || getting_out_of_check?(src, trg))) ||
    (request_for_castling?(src, trg) && castling_permissible?(trg))
  end

  def update_game_statistics(src, trg)
    move_sequence << fan(src, trg)
    pieces_taken << board[trg.rank][trg.file] if capture?(src, trg)
    # src.color replace by side_to_move/color
    positions << [src.color, piece_placement, en_passant_rights, castling_rights]
    history << [src, trg]
  end

  def update_board(src, trg)
    castling(trg) if castling_permissible?(trg)
    place(trg)
    clean(src)
    clean_adjacent(src, trg) if en_passant?(src, trg)
    promote(trg) if promotion?(trg)
  end

  def show_error(src, trg)
    puts "Invalid move: You're in check" if in_check?(src.color)
    puts 'Invalid move' if !valid_move?(src, trg) && !request_for_castling?(src, trg)
    puts 'Invalid move: the path is not free' if !path_free?(src, trg) && valid_move?(src, trg) && !request_for_castling?(src, trg)
    puts 'Castling is not possible' if request_for_castling?(src, trg) && !castling_permissible?(trg)
  end

  def update_halfmove_clock(src, trg)
    if capture?(src, trg) || src.is_a?(Pawn)
      @halfmove_clock = 0
    else
      @halfmove_clock += 1
    end
  end

  def report
    move_sequence.each_slice(2).to_a.each_with_index
                 .map { |move, idx| "\e[94m#{idx + 1}.\e[0m #{move.join(' ')}" }
                 .each_slice(4).to_a
  end

  def show
    system 'clear'
    puts "\n     a  b  c  d  e  f  g  h"
    checkered_board.size.times do |idx|
      printf "%3s %-26s %-3s %-20s\n",
             "#{board.size - idx}",
             checkered_board[idx].join,
             "#{board.size - idx}",
             if report[idx].nil?
               ''
             else
               report[idx].join(' ')
             end
    end
    puts '     a  b  c  d  e  f  g  h'
    puts "\nCommands: (N)ew Game (S)ave (L)oad (Q)uit"
  end

  def checkered_board
    board.map.with_index do |row, row_idx|
      row.map.with_index do |square, square_idx|
        if square.nil?
          if (row_idx - square_idx).abs.odd?
            black_on_lt_blue('   ')
          else
            black_on_gray('   ')
          end
        else
          if (row_idx - square_idx).abs.odd?
            black_on_lt_blue(" #{square.symbol} ")
          else
            black_on_gray(" #{square.symbol} ")
          end
        end
      end
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
    color == 'white' ? enemy_color = 'black' : enemy_color = 'white' # maybe opponent_color
    opponent_player_color_pieces = find_pieces_by(enemy_color)
    current_player_king = find_king(color)
    opponent_player_color_pieces.any? { |piece| valid_move?(piece, current_player_king) && path_free?(piece, current_player_king) }
  end

  def getting_out_of_check?(src, trg)
    original_trg = board[trg.rank][trg.file]
    # make_simulation(src, trg)
    place(trg)
    clean(src)
    result = !in_check?(src.color)
    # revert_changes(src, trg)
    place(src)
    board[trg.rank][trg.file] = original_trg
    result
  end

  def checkmate?(color)
    in_check?(color) && 
      no_legal_move_to_escape?(color) &&
      no_ally_can_capture_checking_piece?(color) &&
      no_ally_can_block_checking_piece?(color)
  end

  def no_legal_move_to_escape?(color)
    current_player_king = find_king(color)
    current_player_king.where_can_jump_from_here
                       .select { |move| target_square_is_empty?(move) ||
                                        target_square_is_enemy?(current_player_king, move) }
                       .none? { |move| getting_out_of_check?(current_player_king, move) }
  end

  def find_attackers(color) # side_to_move #current_player_color
    color == 'white' ? enemy_color = 'black' : enemy_color = 'white'
    current_player_king = find_king(color)
    opponent_player_color_pieces = find_pieces_by(enemy_color)
    opponent_player_color_pieces.select { |piece| piece if valid_move?(piece, current_player_king) && path_free?(piece, current_player_king) }
  end

  def find_defenders(color)
    current_player_color_pieces = find_pieces_by(color)
    attackers = find_attackers(color)
    current_player_color_pieces.map do |piece|
      attackers.map do |attacker|
        piece if valid_move?(piece, attacker) && path_free?(piece, attacker)
      end
    end.flatten.compact
  end

  def no_ally_can_capture_checking_piece?(color)
    attackers = find_attackers(color)
    defenders = find_defenders(color)
    defenders.none? { |defender| attackers.each { |attacker| getting_out_of_check?(defender, attacker) } }
  end

  def no_ally_can_block_checking_piece?(color)
    current_player_color_pieces = find_pieces_by(color)
    current_player_king = find_king(color)
    attackers = find_attackers(color)
    current_player_color_pieces.map do |piece|
      attackers.map do |attacker|
        traversal = bfs_traversal(attacker, current_player_king)
        route = route(traversal)
        route[1..route.size - 2].map do |square|
          valid_move?(piece, attacker.class.new(*square, attacker.color)) &&
            path_free?(piece, attacker.class.new(*square, attacker.color)) &&
            piece != current_player_king
        end
      end
    end.flatten.none?
  end

  def castling(trg) # wing/side
    king = find_king(trg.color)
    rook = find_rook(trg)
    perform_switch(king, rook, trg)
    clean(rook)
    clean(king)
  end

  def perform_switch(king, rook, trg)
    if trg.file == 6
      place(King.new(king.file + 2, king.rank, king.color))
      place(Rook.new(rook.file - 2, rook.rank, rook.color))
    elsif trg.file == 2
      place(King.new(king.file - 2, king.rank, king.color))
      place(Rook.new(rook.file + 3, rook.rank, rook.color))
    end
  end

  def request_for_castling?(src, trg)
    src.is_a?(King) && ((src.file - trg.file).abs == 2 && src.rank == trg.rank)
  end

  # magic numbers 7 and 0
  def find_rook(trg)
    rooks = board.flatten.find_all { |square| square.is_a?(Rook) && square.color == trg.color }
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
    src.color == 'white' ? enemy_color = 'black' : enemy_color = 'white'
    opponent_player_color_pieces = find_pieces_by(enemy_color)
    traversal = bfs_traversal(src, trg)
    route = route(traversal)
    opponent_player_color_pieces.map do |piece|
      route.map do |square|
        valid_move?(piece, src.class.new(*square, src.color)) &&
          no_obstacles_between?(piece, src.class.new(*square, src.color))
      end
    end.flatten.none?
  end

  def first_move?(piece) # do not like original (maybe INITIAL) and square here
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
    pawns.map { |pawn| correct_rank?(pawn) && adjacent?(pawn) && just_double_moved? }
  end

  def en_passant?(src, trg)
    correct_rank?(src) &&
      adjacent?(src) &&
      just_double_moved? &&
      immediate_capture?(src, trg)
  end

  def correct_rank?(src)
    src.rank == 3 || src.rank == 4
  end

  def adjacent?(src)
    left_adjacent = board[src.rank][src.file - 1]
    right_adjacent = board[src.rank][src.file + 1]
    (left_adjacent.is_a?(Pawn) && left_adjacent.color != src.color) ||
      (right_adjacent.is_a?(Pawn) && right_adjacent.color != src.color)
  end

  def just_double_moved?
    (@history.last.last.rank - @history.last.first.rank).abs == 2
  end

  def immediate_capture?(src, trg)
    pawn_diagonal_move?(src, trg) &&
    (board[trg.rank - 1][trg.file].is_a?(Pawn) || board[trg.rank + 1][trg.file].is_a?(Pawn))
  end

  def clean_adjacent(src, trg)
    left_adjacent = board[src.rank][src.file - 1]
    right_adjacent = board[src.rank][src.file + 1]

    if !left_adjacent.nil? && trg.file == left_adjacent.file
      clean(left_adjacent)
    elsif !right_adjacent.nil? && trg.file == right_adjacent.file
      clean(right_adjacent)
    end
  end

  def promotion?(trg) # eligible_for_promotion?(trg)
    (trg.is_a?(Pawn) && trg.rank == 0 && trg.color == 'white') ||
      (trg.is_a?(Pawn) && trg.rank == 7 && trg.color == 'black')
  end

  def promote(trg)
    puts "You pawn is eligible for promotion, please insert \n'B' for Bishop, 'N' for Knight, 'R' for Rook, 'Q' for Queen"
    input = gets.chomp
    new_piece = work_promotion_input(input, trg)
    place(new_piece)
  end

  def work_promotion_input(input, trg)
    if input.upcase == 'B'
      Bishop.new(trg.file, trg.rank, trg.color)
    elsif input.upcase == 'N'
      Knight.new(trg.file, trg.rank, trg.color)
    elsif input.upcase == 'R'
      Rook.new(trg.file, trg.rank, trg.color)
    elsif input.upcase == 'Q'
      Queen.new(trg.file, trg.rank, trg.color)
    end
  end

  def draw?(color)
    stalemate?(color) || threefold_repetition? || fifty_move? || dead_position?
  end

  def stalemate?(color)
    !in_check?(color) && no_legal_move_to_escape?(color)
  end

  def threefold_repetition?
    positions.group_by(&:itself).transform_values(&:count).any? { |k, v| v > 2 }
  end

  def piece_placement
    board.map { |row| row.map { |square| square.symbol if !square.nil? } }
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
    minor_list = board.flatten.select { |square| !square.nil? && square.class != King }
    minor_list.size == 1 && minor_list.all? { |el| el.is_a?(Bishop) || el.is_a?(Knight) }
  end

  def king_and_bishop_same_color?
    bishops = board.flatten.select { |square| !square.nil? && square.class != King }
    # (bishops.size == 2 && bishops.all? { |el| el.is_a?(Bishop) }) &&
      # (bishops.all? { |bishop| (bishop.rank - bishop.file).abs.even? } ||
      # bishops.all? { |bishop| (bishop.rank - bishop.file).abs.odd? })
      bishops.size == 2 &&
      bishops.all? { |el| el.is_a?(Bishop) &&
                          ((el.rank - el.file).abs.even? || (el.rank - el.file).abs.odd?) }
  end

  def fan(src, trg)
    fan = []
    fan.push(src.symbol) if !src.is_a?(Pawn)
    fan.push(convert_file_from(src.file)) if src.is_a?(Pawn) && (capture?(src, trg) || en_passant?(src, trg))
    fan.push('x') if capture?(src, trg) || en_passant?(src, trg)
    fan.push(convert_file_from(trg.file))
    fan.push(convert_rank_from(trg.rank))
    fan.push('=').push(promote(trg).symbol) if promotion?(trg)
    fan.push('e.p.') if en_passant?(src, trg)
    fan.push('+') if placing_in_check?(src, trg)
    fan.clear.push('O-O') if request_for_castling?(src, trg) && trg.file == 6
    fan.clear.push('O-O-O') if request_for_castling?(src, trg) && trg.file == 2
    fan.join
  end

  def capture?(src, trg) # it's not capture, more target_sq_is_enemy?
    !board[trg.rank][trg.file].nil? && board[trg.rank][trg.file].color != src.color
  end

  def convert_file_from(column)
    (column.to_s.ord + 49).chr
  end

  def convert_rank_from(row)
    board.size - row
  end

  def placing_in_check?(src, trg)
    src.color == 'white' ? enemy_color = 'black' : enemy_color = 'white'
    original_trg = board[trg.rank][trg.file]
    place(trg)
    clean(src)
    result = in_check?(enemy_color)
    place(src)
    board[trg.rank][trg.file] = original_trg
    result
  end

  def white_pieces_taken
    pieces_taken.select  { |piece| piece if piece.color == 'white' }
                .map { |piece| piece.symbol }
  end

  def black_pieces_taken
    pieces_taken.select  { |piece| piece if piece.color == 'black' }
                .map { |piece| piece.symbol }
  end
end