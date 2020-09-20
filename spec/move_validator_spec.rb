require './lib/modules/move_validator'
require './lib/board'

describe MoveValidator do
  let(:test) { Board.new }

  describe "#valid_move?(src, trg)" do
    context 'when a Pawn moves' do
      let(:src) { Pawn.new(1, 6, 'white') }

      context 'when a Pawn makes its first move' do
        let(:trg) { Pawn.new(1, 4, 'white') }
        it 'may push two empty squares forward' do
          result = test.valid_move?(src, trg)
          expect(result).to be true
        end
      end

      context 'when a Pawn moves only one square forward' do
        let(:trg) { Pawn.new(1, 5, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to be true
        end
      end

      context 'when a Pawn moves one square backward' do
        let(:trg) { Pawn.new(1, 7, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to be false
        end
      end

      context 'when a Pawn moves one square diagonally' do
        let(:trg) { Pawn.new(2, 5, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to be false
        end
      end

      context 'when a Pawn moves one square diagonally to attack an enemy' do
        let(:trg) { Pawn.new(2, 5, 'white') }
        let(:enemy) { Pawn.new(2, 5, 'black') }

        it 'is valid' do
          test.place(enemy)
          result = test.valid_move?(src, trg)
          expect(result).to be true
        end
      end

      context 'when a Pawn moves 1 square diagonally to attack an ally' do
        let(:trg) { Pawn.new(2, 5, 'white') }
        let(:ally) { Pawn.new(2, 5, 'white') }

        it 'is not valid' do
          test.place(ally)
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to be false
        end
      end

      context 'when a Pawn moves 1 square horizontally' do
        let(:trg) { Pawn.new(2, 6, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to be false
        end
      end
    end

    context 'when a Knight moves' do
      let(:src) { Knight.new(1, 7, 'white') }
      
      context 'when a Knight makes a legal move' do
        let(:trg) { Knight.new(0, 5, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to be true
        end
      end

      context 'when a Knight makes a non legal move' do
        let(:trg) { Knight.new(1, 3, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to be false
        end
      end
    end

    context 'when a Bishop moves' do
      let(:src) { Bishop.new(2, 7, 'white') }
      
      context 'when a Bishop makes a legal move' do
        let(:trg) { Bishop.new(6, 3, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to be true
        end
      end

      context 'when a Bishop makes a non legal move' do
        let(:trg) { Bishop.new(3, 3, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to be false
        end
      end
    end

    context 'when a Rook moves' do
      let(:src) { Rook.new(0, 7, 'white') }

      context 'when a Rook makes a legal vertical move' do
        let(:trg) { Rook.new(0, 4, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to be true
        end
      end

      context 'when a Rook makes a non legal vertical move' do
        let(:trg) { Rook.new(1, 6, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to be false
        end
      end

      context 'when a Rook makes a legal horizontal move' do
        let(:trg) { Rook.new(7, 7, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to be true
        end
      end

      context 'when a Rook makes a non legal horizontal move' do
        let(:trg) { Rook.new(4, 5, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to be false
        end
      end
    end

    context 'when a King moves' do
      let(:src) { King.new(4, 4, 'white') }
      
      context 'when a King moves 1 square vertically' do
        let(:trg) { King.new(4, 5, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to be true
        end
      end

      context 'when a King moves 1 square horizontally' do
        let(:trg) { King.new(3, 4, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to be true
        end
      end

      context 'when a King moves 1 square diagonally' do
        let(:trg) { King.new(5, 5, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to be true
        end
      end

      context 'when a King makes a non legal move' do
        let(:trg) { King.new(4, 6, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to be false
        end
      end
    end

    context 'when a Queen moves' do
      let(:src) { Queen.new(3, 4, 'white') }
      
      context 'when a Queen make a legal diagonal move' do
        let(:trg) { Queen.new(0, 7, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to be true
        end
      end

      context 'when a Queen makes a non legal diagonal move' do
        let(:trg) { Queen.new(0, 6, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to be false
        end
      end

      context 'when a Queen makes a legal vertical move' do
        let(:trg) { Queen.new(3, 0, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to be true
        end
      end

      context 'when a Queen makes a non vertical legal move' do
        let(:trg) { Queen.new(2, 7, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to be false
        end
      end

      context 'when a Queen makes a legal horizontal move' do
        let(:trg) { Queen.new(7, 4, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to be true
        end
      end

      context 'when a Queen makes a non legal horizontal move' do
        let(:trg) { Queen.new(7, 3, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to be false
        end
      end
    end
  end
end