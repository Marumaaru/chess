require './lib/modules/promotion'
require './lib/board'

describe Promotion do
  let(:test) { Board.new }

  let(:trg) { Pawn.new(4, 0, 'white') }

  describe "#promotion?" do
    context 'when a pawn reaches the eighth rank' do
      it 'is eligible for promotion' do 
        result = test.promotion?(trg)
        expect(result).to be true
      end
    end

    context 'when a pawn is not on the eighth rank' do
      let(:wrong_trg) { Pawn.new(4, 1, 'white') }
      it 'is not eligible for promotion' do 
        result = test.promotion?(wrong_trg)
        expect(result).to be false
      end
    end
  end

  describe "#promote(trg)" do
    before do
      allow(test).to receive(:print)
      allow(test).to receive(:gets).and_return('Q')
    end

    context 'when a pawn is eligible for promotion' do
      it 'is replaced by the player\'s choice of a bishop, knight, rook, or queen' do
        result = test.promote(trg).class
        expect(result).to eq(Queen)
      end

      it 'is replaced on the same move' do
        result = test.promote(trg)
        new_piece = test.board[0][4]
        expect(result).to eq(new_piece)
      end
    end
  end
end