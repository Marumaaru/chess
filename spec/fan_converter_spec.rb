require './lib/modules/fan_converter'
require './lib/board'

describe FanConverter do
  let(:test) { Board.new }

  describe "#fan" do
    let(:white_king) { King.new(4, 7, 'white') }
    let(:black_king) { King.new(4, 0, 'black') }
    let(:knight) { Knight.new(4, 4, 'white') }
    let(:knight_trg) { Knight.new(6, 5, 'white') }
    let(:white_pawn) { Pawn.new(7, 6, 'white') }
    let(:white_pawn_trg) { Pawn.new(7, 5, 'white') }
    let(:black_pawn) { Pawn.new(6, 5, 'black') }
    let(:black_pawn_trg) { Pawn.new(7, 6, 'black') }

    before do
      test.place(white_king)
      test.place(black_king)
      test.place(white_pawn)
    end

    context 'when recording and describing regular moves' do
      it 'uses miniature piece icons to represent the piece to move' do
        result = test.fan(knight, knight_trg).split('').first
        example = "\u2658"
        expect(result).to eq(example)
      end

      it 'omits pawns figurines' do
        result = test.fan(white_pawn, white_pawn_trg)
        example = "h3"
        expect(result).to eq(example)
      end

      it 'notates the target square by algebraic coordinates' do
        result = test.fan(knight, knight_trg)
        example = "\u2658g3"
        expect(result).to eq(example)
      end
    end

    context 'when a piece makes a capture' do
      before do
        test.place(black_pawn)
      end

      it 'inserts the lower case letter "x" immediately prior to the destination square' do
        result = test.fan(knight, knight_trg)
        example = "\u2658xg3"
        expect(result).to eq(example)
      end
    end

    context 'when a pawn makes a capture' do
      it 'uses the file from which the pawn departed to identify the pawn' do
        result = test.fan(black_pawn, black_pawn_trg)
        example = "gxh2"
        expect(result).to eq(example)
      end
    end

    context 'when a pawn makes an en passant capture' do
      let(:capturing_pawn) { Pawn.new(4, 3, 'white') }
      let(:capturing_pawn_trg) { Pawn.new(5, 2, 'white') }
      let(:captured_pawn) { Pawn.new(5, 3, 'black') }

      before do
        test.place(capturing_pawn)
        test.place(captured_pawn)
        allow(test).to receive(:en_passant?).and_return(true)
      end

      it 'specifies the capturing pawn\'s file of departure' do
        result = test.fan(capturing_pawn, capturing_pawn_trg)
        example = "exf6e.p."
        expect(result).to eq(example)
      end

      it 'inserts the lower case letter "x" immediately prior to the destination square' do
        result = test.fan(capturing_pawn, capturing_pawn_trg)
        example = "exf6e.p."
        expect(result).to eq(example)
      end

      it 'notates the target square (not the square of the captured pawn) by algebraic coordinates' do
        result = test.fan(capturing_pawn, capturing_pawn_trg)
        example = "exf6e.p."
        expect(result).to eq(example)
      end

      it 'adds the suffix "e.p."' do
        result = test.fan(capturing_pawn, capturing_pawn_trg)
        example = "exf6e.p."
        expect(result).to eq(example)
      end
    end

    context 'when a pawn moves to the last rank and promotes' do
      let(:promo_pawn) { Pawn.new(7, 1, 'white') }
      let(:promo_pawn_trg) { Pawn.new(7, 0, 'white') }

      it 'indicates the piece promoted after "=" at the end of the move notation' do
        allow(test).to receive(:promote).and_return(Queen.new(7, 0, 'white'))
        result = test.fan(promo_pawn, promo_pawn_trg)
        example = "h8=\u2655"
        expect(result).to eq(example)
      end
    end

    context 'when kingside castling' do
      let(:kingside_rook) { Rook.new(7, 7, 'white') }

      it 'uses the uppercase letter O for special notation O-O' do 
        src = white_king
        trg = King.new(6, 7, 'white')
        result = test.fan(src, trg)
        example = "O-O"
        expect(result).to eq(example)
      end
    end

    context 'when queenside castling' do
      let(:queenside_rook) { Rook.new(0, 7, 'white') }

      it 'uses the uppercase letter O for special notation O-O-O' do 
        src = white_king
        trg = King.new(2, 7, 'white')
        result = test.fan(src, trg)
        example = "O-O-O"
        expect(result).to eq(example)
      end
    end

    context 'when placing the opponent\'s king in check' do
      let(:queen) { Queen.new(3, 2, 'black') }

      it 'appends the symbol "+"' do
        test.place(queen)
        src = queen
        trg = Queen.new(4, 2, 'black')
        result = test.fan(src, trg)
        example = "\u265Be6+"
        expect(result).to eq(example)
      end
    end

    context 'when a pawn captures and promotes' do
      let(:pawn) { Pawn.new(7, 1, 'white') }
      let(:knight) { Knight.new(6, 0, 'black') }

      it 'inserts the lower case letter "x" and indicates the piece promoted at the end of the move notation' do
        test.place(pawn)
        test.place(knight)
        src = pawn
        trg = Pawn.new(6, 0, 'white')
        allow(test).to receive(:promote).and_return(Queen.new(7, 0, 'white'))
        result = test.fan(src, trg)
        example = "hxg8=\u2655"
        expect(result).to eq(example)
      end
    end

    context 'when a pawn captures and places the opponent\'s kingin check' do
      let(:pawn) { Pawn.new(4, 2, 'white') }
      let(:knight) { Knight.new(3, 1, 'black') }

      it 'inserts the lower case letter "x" and appends the symbol "+"' do
        test.place(pawn)
        test.place(knight)
        src = pawn
        trg = Pawn.new(3, 1, 'white')
        result = test.fan(src, trg)
        example = "exd7+"
        expect(result).to eq(example)
      end
    end

    context 'when a piece captures and places the opponent\'s king in check' do
      let(:pawn) { Pawn.new(4, 6, 'white') }
      let(:queen) { Queen.new(4, 2, 'black') }
      
      it 'inserts the lower case letter "x" and appends the symbol "+"' do
        test.place(pawn)
        test.place(queen)
        src = queen
        trg = Queen.new(4, 6, 'black')
        result = test.fan(src, trg)
        example = "\u265Bxe2+"
        expect(result).to eq(example)
      end
    end
  end
end