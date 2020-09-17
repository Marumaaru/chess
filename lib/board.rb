# frozen_string_literal: true

require './lib/modules/initial_position'
require './lib/modules/checkmate'
require './lib/modules/draw'
require './lib/modules/in_check'
require './lib/modules/castling'
require './lib/modules/en_passant'
require './lib/modules/promotion'
require './lib/modules/fan_converter'
require './lib/move_validator'
require './lib/modules/errors'
require './lib/modules/colorable'
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
  include Errors
  include FanConverter
  include InitialPosition
  include Checkmate
  include InCheck
  include Draw
  include Castling
  include EnPassant
  include Promotion
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
    save_originals_for_castling_check
    place_white_pawns
    place_black_pawns
  end

  def legal_move?(src, trg)
    (valid_move?(src, trg) &&
    path_free?(src, trg) &&
    (!in_check?(src.color) || getting_out_of_check?(src, trg))) ||
      (request_for_castling?(src, trg) && castling_permissible?(trg))
  end

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

  def update_game_record(src, trg)
    update_pieces_taken(src, trg)
    move_record << fan(src, trg)
    history << [src, trg]
    update_halfmove_clock(src, trg)
    positions << [src.color, piece_placement, en_passant_rights, castling_rights]
  end

  def update_pieces_taken(src, trg)
    pieces_taken << board[trg.rank][trg.file]
    pieces_taken << @history[@history.size - 2].last if capture_en_passant_performed?(src, trg)
  end

  def update_halfmove_clock(src, trg)
    if capture?(trg) || src.is_a?(Pawn)
      @halfmove_clock = 0
    else
      @halfmove_clock += 1
    end
  end

  def update_board(src, trg)
    castling(trg) if request_for_castling?(src, trg) && castling_permissible?(trg)
    place(trg) unless promotion?(trg)
    clean(src)
    clean_adjacent(src, trg) if capture_en_passant_performed?(src, trg)
  end

  def place(piece)
    board[piece.rank][piece.file] = piece
  end

  def clean(piece)
    board[piece.rank][piece.file] = nil
  end

  def show
    puts '     a  b  c  d  e  f  g  h'
    checkered_board.size.times do |idx|
      printf("%<rank>3s %<board>-26s %<rank>-3s %<notation_window>-20s\n",
             { rank: (board.size - idx).to_s,
               board: checkered_board[idx].join,
               notation_window: show_move_notation(idx) })
    end
    puts '     a  b  c  d  e  f  g  h'
  end

  def notation_window
    full_move = 2
    line_length = 4
    move_record.each_slice(full_move).to_a.each_with_index
               .map { |move, idx| "\e[94m#{idx + 1}.\e[0m #{move.join(' ')}" }
               .each_slice(line_length).to_a
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

  # def flip(color)
  #   @board = color == 'white' ? @board : @board.reverse
  # end

  def capture?(trg)
    !board[trg.rank][trg.file].nil? && board[trg.rank][trg.file].color != trg.color
  end

  def white_pieces_taken
    pieces_taken.compact.select { |piece| piece if piece.color == 'white' }.map(&:symbol)
  end

  def black_pieces_taken
    pieces_taken.compact.select { |piece| piece if piece.color == 'black' }.map(&:symbol)
  end
end
