require './lib/board'
require './lib/knight'

describe Board do
  subject(:test) { described_class.new }

  describe "#initialize" do
    context 'when initializing a board' do
      it 'is a grid of 8 rows and 8 cols' do
        default_board =
          [[" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "]]
        expect(test.board).to eq(default_board)
      end
    end
  end

  describe "#show" do
    context 'when asking to show a board' do
      it 'outputs a pretty formatted grid' do
        printed_board = 
          <<~HEREDOC

              a   b   c   d   e   f   g   h  
            +---+---+---+---+---+---+---+---+
          8 |   |   |   |   |   |   |   |   | 8
            +---+---+---+---+---+---+---+---+
          7 |   |   |   |   |   |   |   |   | 7
            +---+---+---+---+---+---+---+---+
          6 |   |   |   |   |   |   |   |   | 6
            +---+---+---+---+---+---+---+---+
          5 |   |   |   |   |   |   |   |   | 5
            +---+---+---+---+---+---+---+---+
          4 |   |   |   |   |   |   |   |   | 4
            +---+---+---+---+---+---+---+---+
          3 |   |   |   |   |   |   |   |   | 3
            +---+---+---+---+---+---+---+---+
          2 |   |   |   |   |   |   |   |   | 2
            +---+---+---+---+---+---+---+---+
          1 |   |   |   |   |   |   |   |   | 1
            +---+---+---+---+---+---+---+---+
              a   b   c   d   e   f   g   h  
          HEREDOC
        expect { test.show }.to output((printed_board)).to_stdout
      end
    end
  end

  describe "#place(piece)" do
    context 'when given a piece' do
      let(:knight) { Knight.new(1,7) }

      it 'places it on the board' do
        board_with_knight_placed = 
          [[" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", "N", " ", " ", " ", " ", " ", " "]]
        test.place(knight)
        expect(test.board).to eq(board_with_knight_placed)
      end
    end
  end
end