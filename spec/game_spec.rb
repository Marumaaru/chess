require './lib/game'

describe Game do
  subject(:game_test) { described_class.new }

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