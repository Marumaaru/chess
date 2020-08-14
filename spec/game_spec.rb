require './lib/game'

describe Game do
  subject(:game_test) { described_class.new }

  describe "#make_move(input)" do
    context 'when making move' do
      before do
        input = 'Na3'
        game_test.populate_board
        game_test.make_move(input)
      end

      it 'creates a new piece on the target square' do
        trg_square = game_test.board.board[5][0]
        expect(trg_square.class).to eq(Knight)
      end

      it 'empties source square of the piece' do
        src_square = game_test.board.board[7][1]
        expect(src_square.class).to eq(String)
      end
    end
  end

  describe "#activate_piece_by(input)" do
    context 'when receiving algebraic input' do
      it 'activates a wanted piece' do
        input = 'Na3'
        game_test.populate_board
        wanted_knight = game_test.board.board[7][1]
        result = game_test.activate_piece_by(input)
        expect(result).to eq(wanted_knight)
      end
    end
  end

  describe "#convert_move(input)" do
    context 'when receiving algebraic input' do
      it 'converts it to board coordinates' do
        input = 'Na3'
        coords = [0, 5]
        result = game_test.convert_move(input)
        expect(result).to eq(coords)
      end
    end
  end

  describe "#convert_file_algebraic_notation(input)" do
    context 'when receiving input' do
      it 'converts it to board coordinates' do
        input = 'Na3'
        file = 0
        result = game_test.convert_file_algebraic_notation(input)
        expect(result).to eq(file)
      end
    end
  end

  describe "#convert_rank_algebraic_notation(input)" do
    context 'when receiving input' do
      it 'converts it to board coordinates' do
        input = 'Na3'
        rank = 5
        result = game_test.convert_rank_algebraic_notation(input)
        expect(result).to eq(rank)
      end
    end
  end

#   describe "#initialize" do
#     context 'when starting a new game' do
#       it 'creates/activates a board' do
#         # Game.new
#         expect(Board).to receive(:new)
#       end

#       it 'populates board with pieces' do
#         populated_board = 
#           [["♜", "♞", "♝", "♛", "♚", "♝", "♞", "♜"],
#            ["♟︎", "♟︎", "♟︎", "♟︎", "♟︎", "♟︎", "♟︎", "♟︎"],
#            [" ", " ", " ", " ", " ", " ", " ", " "],
#            [" ", " ", " ", " ", " ", " ", " ", " "],
#            [" ", " ", " ", " ", " ", " ", " ", " "],
#            [" ", " ", " ", " ", " ", " ", " ", " "],
#            ["♙", "♙", "♙", "♙", "♙", "♙", "♙", "♙"],
#            ["♖", "♘", "♗", "♕", "♔", "♗", "♘", "♖"]]
#         expect(game_test.board).to eq(populated_board)
#         # game_test.populate_board
#       end
#     end
#   end
end