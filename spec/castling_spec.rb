require './lib/modules/castling'
require './lib/board'

describe Castling do
  let(:test) { Board.new }

  let(:white_king) { King.new(4, 7, 'white') }
  let(:black_king) { King.new(4, 0, 'black') }
  let(:white_rook_kingside) { Rook.new(7, 7, 'white') }
  let(:white_rook_queenside) { Rook.new(0, 7, 'white') }
  let(:black_rook_kingside) { Rook.new(7, 0, 'black') }
  let(:black_rook_queenside) { Rook.new(0, 0, 'black') }

  let(:short) { King.new(6, 7, 'white') }
  let(:long) { King.new(2, 0, 'black') }

  before do
    test.place(white_king)
    test.place(black_king)
    test.place(white_rook_kingside)
    test.place(white_rook_queenside)
    test.place(black_rook_kingside)
    test.place(black_rook_queenside)
    test.save_originals_for_castling_check
  end

  describe "#castling(trg)" do
    context 'when King is short castling' do
      it 'places King two squares towards a rook kingside' do
        test.castling(short)
        new_pos = test.board[7][6]
        expect(new_pos.class).to eq(King)
      end

      it 'places Rook on the last square the King just crossed' do
        test.castling(short)
        new_pos = test.board[7][5]
        expect(new_pos.class).to eq(Rook)
      end

      it 'removes King from its original position' do
        test.castling(short)
        original_pos = test.board[7][4]
        expect(original_pos).to be_nil
      end

      it 'removes Rook from its original position' do
        test.castling(short)
        original_pos = test.board[7][7]
        expect(original_pos).to be_nil
      end
    end

    context 'when King is long castling' do
      it 'places King two squares towards a rook queenside' do
        test.castling(long)
        new_pos = test.board[0][2]
        expect(new_pos.class).to eq(King)
      end

      it 'places Rook on the last square the King just crossed' do
        test.castling(long)
        new_pos = test.board[0][3]
        expect(new_pos.class).to eq(Rook)
      end

      it 'removes King from its original position' do
        test.castling(long)
        original_pos = test.board[0][4]
        expect(original_pos).to be_nil
      end

      it 'removes Rook from its original position' do
        test.castling(long)
        original_pos = test.board[0][0]
        expect(original_pos).to be_nil
      end
    end
  end

  describe "#castling_permissible?(color)" do
    context 'when King has not moved previously during the game' do
      it 'is permissible' do
        result = test.castling_permissible?(short)
        expect(result).to be true
      end
    end

    context 'when King has moved previously during the game' do
      let(:new_king) { King.new(4, 7, 'white') }

      it 'is not permissible' do 
        test.place(new_king)
        result = test.castling_permissible?(short)
        expect(result).to be false
      end
    end

    context 'when Rook has not moved previously during the game' do
      it 'is permissible' do
        result = test.castling_permissible?(short)
        expect(result).to be true
      end
    end

    context 'when Rook has moved previously during the game' do
      let(:new_rook) { Rook.new(7, 7, 'white') }

      it 'is not permissible' do
        test.place(new_rook)
        result = test.castling_permissible?(short)
        expect(result).to be false
      end
    end

    context 'when the path between King and Rook is free' do
      it 'is permissible' do 
        result = test.castling_permissible?(short)
        expect(result).to be true
      end
    end

    context 'when the path between King and Rook is not free' do
      let(:pawn) { Pawn.new(6, 7, 'white') }

      it 'is not permissible' do 
        test.place(pawn)
        result = test.castling_permissible?(short)
        expect(result).to be false
      end
    end

    context 'when King is not in check' do
      it 'is permissible' do 
        result = test.castling_permissible?(short)
        expect(result).to be true
      end
    end

    context 'when King is in check' do
      let(:queen) { Queen.new(4, 4, 'black') }

      it 'is not permissible' do
        test.place(queen)
        result = test.castling_permissible?(short)
        expect(result).to be false
      end
    end

    context 'when castling path is safe' do
      it 'is permissible' do 
        result = test.castling_permissible?(short)
        expect(result).to be true
      end
    end

    context 'when King passes through a square under attack' do
      let(:queen) { Queen.new(5, 4, 'black') }

      it 'is not permissible' do 
        test.place(queen)
        result = test.castling_permissible?(short)
        expect(result).to be false
      end
    end

    context 'when King does not end up in check' do
      it 'is permissible' do 
        result = test.castling_permissible?(short)
        expect(result).to be true
      end
    end

    context 'when King ends up in check' do
      let(:queen) { Queen.new(6, 4, 'black') }

      it 'is not permissible' do
        test.place(queen)
        result = test.castling_permissible?(short)
        expect(result).to be false
      end
    end
  end
end