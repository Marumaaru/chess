require './lib/modules/en_passant'
require './lib/board'

describe EnPassant do
  let(:test) { Board.new }
  
  let(:attacking_black_pawn) { Pawn.new(3, 4, 'black') }
  let(:attacking_white_pawn) { Pawn.new(5, 3, 'white') }
  let(:captured_black_pawn) { Pawn.new(4, 3, 'black') }
  let(:trg) { Pawn.new(4, 2, 'white') }
  let(:last_src) { Pawn.new(4, 1, 'black') }
  
  before do 
    test.place(attacking_black_pawn)
    test.place(attacking_white_pawn)
    test.place(captured_black_pawn)
    test.instance_variable_set(:@history, [[last_src, captured_black_pawn]])
  end

  describe "#en_passant?" do
    context 'when the capturing white pawn is on its fifth rank' do
      it 'can be performed' do
        result = test.correct_rank?(attacking_white_pawn)
        expect(result).to be true
      end
    end

    context 'when the capturing black pawn is on its forth rank' do
      it 'can be performed' do
        result = test.correct_rank?(attacking_black_pawn)
        expect(result).to be true
      end
    end

    context 'when the capturing pawn is not on correct rank' do
      let(:pawn) { Pawn.new(5, 5, 'white') }

      before do
        test.place(pawn)
      end

      it 'can not be performed' do
        result = test.correct_rank?(pawn)
        expect(result).to be false
      end
    end

    context 'when the captured pawn is on adjacent file to the attacking pawn' do
      it 'can be performed' do
        result = test.captured_is_adjacent?(attacking_white_pawn)
        expect(result).to be true
      end
    end

    context 'when the captured pawn is not adjacent to the attacking pawn' do
      let(:not_adjacent_captured_black_pawn) { Pawn.new(3, 3, 'black') }

      before do
        test.clean(captured_black_pawn)
        test.place(not_adjacent_captured_black_pawn)
      end

      it 'can not be performed' do
        result = test.captured_is_adjacent?(attacking_white_pawn)
        expect(result).to be false
      end
    end

    context 'when the captured pawn has just performed a double-step move' do
      it 'can be performed' do
        result = test.last_is_double_pawn_push?
        expect(result).to be true
      end
    end

    context 'when the captured pawn has not performed a double-step move' do
      let(:last_src) { Pawn.new(4, 3, 'black') }

      before do
        test.instance_variable_set(:@history, [[last_src, captured_black_pawn]])
      end

      it 'can not be performed' do
        result = test.last_is_double_pawn_push?
        expect(result).to be false
      end
    end

    context 'when capture is an immediate reply to the enemy pawn\'s double-step move' do
      it 'can be performed' do
        result = test.immediate_capture_reply?(attacking_white_pawn, trg)
        expect(result).to be true
      end
    end

    context 'when capture is not an immediate reply to the enemy pawn\'s double-step move' do
      let(:wrong_trg) { Pawn.new(5, 2, 'white') }

      it 'can not be performed' do
        result = test.immediate_capture_reply?(attacking_white_pawn, wrong_trg)
        expect(result).to be false
      end
    end

    context 'when all the conditions are satisfied' do
      it 'can be performed' do
        result = test.en_passant?(attacking_white_pawn, trg)
        expect(result).to be true
      end
    end
  end
end