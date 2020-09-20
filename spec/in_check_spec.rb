require './lib/modules/in_check'
require './lib/board'

describe InCheck do
  let(:test) { Board.new }

  describe "#in_check?" do
    let(:king) { King.new(4, 4, 'white') }
    
    before do
      test.place(king)
    end

    context 'when a King is under immediate Pawn\'s attack' do
      let(:pawn) { Pawn.new(3, 3, 'black') }

      it 'is in check' do
        test.place(pawn)
        result = test.in_check?(king.color)
        expect(result).to be true
      end
    end

    context 'when a King is under immediate Rook\'s attack' do
      let(:rook) { Rook.new(4, 0, 'black') }

      it 'is in check' do
        test.place(rook)
        result = test.in_check?(king.color)
        expect(result).to be true
      end
    end

    context 'when a King is under immediate Bishop\'s attack' do
      let(:bishop) { Bishop.new(1, 1, 'black') }

      it 'is in check' do
        test.place(bishop)
        result = test.in_check?(king.color)
        expect(result).to be true
      end
    end

    context 'when a King is under immediate Knight\'s attack' do
      let(:knight) { Knight.new(2, 3, 'black') }

      it 'is in check' do
        test.place(knight)
        result = test.in_check?(king.color)
        expect(result).to be true
      end
    end

    context 'when a King is under immediate Queen\'s attack' do
      let(:queen) { Queen.new(0, 4, 'black') }

      it 'is in check' do
        test.place(queen)
        result = test.in_check?(king.color)
        expect(result).to be true
      end
    end

    context 'when a King is under immediate enemy King\'s attack' do
      let(:enemy_king) { King.new(5, 5, 'black') }

      it 'is in check' do
        test.place(enemy_king)
        result = test.in_check?(king.color)
        expect(result).to be true
      end
    end

    context 'when King is not under attack' do
      let(:pawn) { Pawn.new(5, 2, 'black') }
      let(:rook) { Rook.new(1, 1, 'black') }
      let(:bishop) { Bishop.new(7, 2, 'black') }
      let(:knight) { Knight.new(0, 3, 'black') }
      let(:queen) { Queen.new(1, 5, 'black') }

      before do
        test.place(pawn)
        test.place(rook)
        test.place(bishop)
        test.place(knight)
        test.place(queen)
      end

      it 'is not in check' do
        result = test.in_check?(king.color)
        expect(result).to be false
      end
    end

    context 'when interposing an ally piece between the checking piece and the King' do
      let(:pawn) { Pawn.new(3, 3, 'white') }
      let(:queen) { Queen.new(1, 1, 'black') }

      it 'is not in check' do
        test.place(pawn)
        test.place(queen)
        result = test.in_check?(king.color)
        expect(result).to be false
      end
    end

    context 'when interposing an enemy piece between the checking piece and the King' do
      let(:pawn) { Pawn.new(4, 3, 'black') }
      let(:rook) { Rook.new(4, 0, 'black') }

      it 'is not in check' do
        test.place(pawn)
        test.place(rook)
        result = test.in_check?(king.color)
        expect(result).to be false
      end
    end
  end
end