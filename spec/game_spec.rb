require './lib/game'

describe Game do
  subject(:game_test) { described_class.new }

  describe "#initialize" do
    context 'when starting a new game' do
      xit 'creates/activates a board' do
        expect(Board).to receive(:new)
        Game.new
      end

      it 'populates board with pieces' do
        populated_board = 
          [["R", "N", "B", "Q", "K", "B", "N", "R"],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           ["R", "N", "B", "Q", "K", "B", "N", "R"]]

        game_test.populate_board
        expect(game_test.board.board).to eq(populated_board)
      end
    end
  end
end