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
      let(:knight) { Knight.new(1, 7, "\u2658") }

      it 'places it on the board' do
        board_with_knight_placed = 
          [[" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", knight, " ", " ", " ", " ", " ", " "]]
        test.place(knight)
        expect(test.board).to eq(board_with_knight_placed)
      end
    end
  end

  describe "#find_pieces_by(input)" do
    let(:knight1) { Knight.new(1, 7, "\u2658") }
    let(:knight2) { Knight.new(6, 7, "\u2658") }
    let(:knight3) { Knight.new(1, 0, "\u265E") }
    let(:knight4) { Knight.new(6, 0, "\u265E") }

    context 'when receiving input' do
      it 'finds all pieces by first letter' do
        input = 'Na3'
        test.place(knight1)
        test.place(knight2)
        test.place(knight3)
        test.place(knight4)
        list_of_knights = [knight3, knight4, knight1, knight2]
        result = test.find_pieces_by(input)
        expect(result).to eq(list_of_knights)
      end
    end
  end
end