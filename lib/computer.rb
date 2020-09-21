# frozen_string_literal: true

require './lib/game'
require './lib/board'

# a very basic AI who does a random legal move
class Computer
  include Colorable
  include Displayable

  attr_reader :board, :name, :color

  def initialize(color, board, name = 'Computer')
    @name = name
    @color = color
    @board = board
  end

  def move(src = nil, trg = nil)
    pieces = board.find_pieces_by(color)
    until board.legal_move?(src, trg)
      src = pieces.sample
      trg = src.where_can_jump.sample
    end
    board.piece_moves(src, trg)
  end
end
