require './lib/modules/checkmate'
require './lib/board'

describe Checkmate do
  let(:test) { Board.new }

  let(:black_king) { King.new(7, 0, 'black') }
  let(:white_king) { King.new(6, 2, 'white') }
  let(:white_bishop) { Bishop.new(5, 2, 'white') }
  let(:white_knight) { Knight.new(7, 2, 'white') }

  let(:color) { 'black' }

  before do
    test.place(black_king)
    test.place(white_king)
    test.place(white_bishop)
    test.place(white_knight)
  end

  describe "#checkmate?(color)" do
    context 'when King has no legal moves to escape check' do
      it 'is checkmate' do
        result = test.no_legal_move_to_escape?(color)
        expect(result).to be true
      end
    end
  
    context 'when King has legal moves to escape check' do
      before do
        test.clean(white_knight)
      end

      it 'is not checkmate' do
        result = test.no_legal_move_to_escape?(color)
        expect(result).to be false
      end
    end

    context 'when no ally can capture a checking piece' do
      it 'is checkmate' do
        result = test.no_ally_can_capture_checking_piece?(color)
        expect(result).to be true
      end
    end

    context 'when an ally can capture a checking piece' do
      let(:black_queen) { Queen.new(2, 5, 'black') }

      before do
        test.place(black_queen)
      end

      it 'is not checkmate' do
        result = test.no_ally_can_capture_checking_piece?(color)
        expect(result).to be false
      end
    end

    context 'when no ally can block a checking piece path' do
      it 'is checkmate' do
        result = test.no_ally_can_block_checking_piece?(color)
        expect(result).to be true
      end
    end
  
    context 'when an ally can block a checking piece path' do
      let(:black_pawn) { Pawn.new(6, 0, 'black') }

      before do
        test.place(black_pawn)
      end

      it 'is not checkmate' do
        result = test.no_ally_can_block_checking_piece?(color)
        expect(result).to be false
      end
    end

    context 'when King is in check and there is no way to avoid the threat' do
      it 'is checkmate' do
        result = test.checkmate?(color)
        expect(result).to be true
      end
    end
    
    context 'when King is in check and is possible to avoid the threat' do
      let(:black_pawn) { Pawn.new(6, 0, 'black') }

      before do
        test.place(black_pawn)
      end

      it 'is not checkmate' do
        result = test.checkmate?(color)
        expect(result).to be false
      end
    end
  end
end
