require './lib/modules/draw'
require './lib/board'

describe Draw do
  let(:test) { Board.new }

  describe "#stalemate?" do
    let(:black_king) { King.new(7, 0, 'black') }
    let(:white_king) { King.new(5, 1, 'white') }
    let(:queen) { Queen.new(6, 2, 'white') }

    before do
      test.place(black_king)
      test.place(white_king)
      test.place(queen)
    end

    context 'when player is not in check but has no legal moves' do
      it 'is stalemate' do
        result = test.stalemate?(black_king.color)
        expect(result).to be true
      end
    end

    context 'when player is not in check and there is legal move' do
      it 'is not stalemate' do
        test.clean(queen)
        result = test.stalemate?(black_king.color)
        expect(result).to be false
      end
    end
  end

  describe "#dead_position?" do
    let(:white_king) { King.new(2, 2, 'black') }
    let(:black_king) { King.new(6, 6, 'white') }

    before do 
      test.place(white_king)
      test.place(black_king)
    end

    context 'when both sides have a bare king' do
      it 'is a dead position' do
        result = test.dead_position?
        expect(result).to be true
      end
    end

    context 'when one player has not only the king' do
      let(:pawn) { Pawn.new(4, 4, 'white') }
      it 'is not a dead position' do
        test.place(pawn)
        result = test.dead_position?
        expect(result).to be false
      end
    end

    context 'when a king and a minor (bishop or knight) piece are against a bare king' do
      let(:bishop) { Bishop.new(4, 4, 'white') }
      it 'is a dead position' do
        test.place(bishop)
        result = test.dead_position?
        expect(result).to be true
      end
    end

    context 'when both sides have a king and a minor (bishop or knight) piece' do
      let(:bishop) { Bishop.new(7, 7, 'white') }
      let(:knight) { Knight.new(2, 4, 'black') }
      it 'is not a dead position' do
        test.place(bishop)
        test.place(knight)
        result = test.dead_position?
        expect(result).to be false
      end
    end

    context 'when both sides have a king and a bishop, the bishops being the same color' do
      let(:white_bishop) { Bishop.new(2, 7, 'white') }
      let(:black_bishop) { Bishop.new(5, 0, 'black') }
      it 'is a dead position' do
        test.place(white_bishop)
        test.place(black_bishop)
        result = test.dead_position?
        expect(result).to be true
      end
    end

    context 'when both sides have a king and a bishop, the bishops being different color' do
      let(:white_bishop) { Bishop.new(2, 7, 'white') }
      let(:black_bishop) { Bishop.new(2, 0, 'black') }

      it 'is not a dead position' do
        test.place(white_bishop)
        test.place(black_bishop)
        result = test.dead_position?
        expect(result).to be false
      end
    end
  end

#   describe "#threefold_repetition?" do

#     context 'when the same position occurs three times with the same player to move' do
#       it 'is threefold repetition' do
#       end
#     end

#     context 'when the same position occurs two times with the same player to move' do
#       it 'is not threefold repetition' do
#       end
#     end

#     context 'when the same position occurs three times with different player to move' do
#       it 'is not threefold repetition' do
#       end
#     end
#   end
end