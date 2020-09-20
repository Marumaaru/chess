require './lib/board'
require './lib/modules/initial_position'
require './lib/modules/checkmate'
require './lib/modules/draw'
require './lib/modules/in_check'
require './lib/modules/castling'
require './lib/modules/en_passant'
require './lib/modules/promotion'
require './lib/modules/fan_converter'
require './lib/modules/move_validator'
require './lib/modules/errors'
require './lib/modules/colorable'
require './lib/modules/displayable'
require './lib/pieces/bishop'
require './lib/pieces/knight'
require './lib/pieces/rook'
require './lib/pieces/queen'
require './lib/pieces/king'
require './lib/pieces/pawn'

describe Board do
  subject(:test) { described_class.new }

  describe "#piece_moves(src, trg)" do
    let(:white_king) { King.new(4, 7, 'white') }
    let(:black_king) { King.new(4, 0, 'black') }
    let(:src) { Queen.new(5, 5, 'white') }

    before do
      test.place(white_king)
      test.place(black_king)
      test.place(src)
    end

    context 'when making a regular move' do
      let(:trg) { Queen.new(6, 6, 'white') }

      before do
        test.piece_moves(src, trg)
      end

      it 'places a new piece of the same class on the target square' do
        result = test.board[6][6]
        expect(result).to eq(trg)
      end

      it 'empties the original square' do
        result = test.board[5][5]
        expect(result).to be nil
      end

      it 'saves the move in FAN variation' do
        fan_last_move = "\u2655g2"
        result = test.move_record.last
        expect(result).to eq(fan_last_move)
      end

      it 'updates the history of moves' do
        last_move = [src, trg]
        result = test.history.last
        expect(result).to eq(last_move)
      end

      it 'increases halfmove clock' do
        expect(test.halfmove_clock).to eq(1)
      end

      it 'saves chess position' do
        position_example = ["white",
          [[nil, nil, nil, nil, "♚", nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, "♕", nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, "♔", nil, nil, nil]],
          [],
          [false, false]]
        result = test.positions.last
        expect(result).to eq(position_example)
      end
    end
  end

  describe "#path_free?(src, trg)" do
    let(:bishop) { Bishop.new(2, 7, 'white') }

    before do 
      test.place(bishop)
    end

    context 'when adjacent target square is empty' do
      let(:trg) { Bishop.new(3, 6, 'white') }
      it 'is free' do
        result = test.path_free?(bishop, trg)
        expect(result).to be true
      end
    end

    context 'when adjacent target square is occupied by enemy piece' do
      let(:enemy_knight) { Knight.new(3, 6, 'black') }
      it 'is free' do
        test.place(enemy_knight)
        result = test.path_free?(bishop, enemy_knight)
        expect(result).to be true
      end
    end

    context 'when adjacent target square is occupied by ally piece' do
      let(:ally_knight) { Knight.new(3, 6, 'white') }
      it 'is not free' do
        test.place(ally_knight)
        result = test.path_free?(bishop, ally_knight)
        expect(result).to be false
      end
    end

    context 'when there are no pieces on the sliding path to the distant target square' do
      let(:enemy_knight) { Knight.new(7, 2, 'black') }
      it 'is free' do
        test.place(enemy_knight)
        result = test.path_free?(bishop, enemy_knight)
        expect(result).to be true
      end
    end

    context 'when there is an ally piece on the sliding path to the distant target square' do
      let(:trg) { Bishop.new(7, 2, 'white') }
      let(:ally_pawn) { Pawn.new(4, 5, 'white') }
      it 'is not free' do
        test.place(ally_pawn)
        result = test.path_free?(bishop, trg)
        expect(result).to be false
      end
    end

    context 'when the path to the distant target square is obstructed by another enemy piece' do
      let(:enemy_knight) { Knight.new(7, 2, 'black') }
      let(:enemy_pawn) { Pawn.new(4, 5, 'black') }

      it 'is not free' do
        test.place(enemy_knight)
        test.place(enemy_pawn)
        result = test.path_free?(bishop, enemy_knight)
        expect(result).to be false
      end
    end
  end
end