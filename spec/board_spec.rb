require './lib/board'
require './lib/knight'
require './lib/bishop'
require './lib/rook'
require './lib/pawn'
require './lib/king'
require './lib/queen'

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
    context 'when a board is empty' do
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

    context 'when a board is populated' do
      let(:knight1) { Knight.new(1, 7, 'white') }
      let(:knight2) { Knight.new(6, 7, 'white') }
      let(:knight3) { Knight.new(1, 0, 'black') }
      let(:knight4) { Knight.new(6, 0, 'black') }

      before do
        test.place(knight1)
        test.place(knight2)
        test.place(knight3)
        test.place(knight4)
      end

      it 'outputs a pretty formatted grid with pieces symbols' do
        printed_board = 
          <<~HEREDOC

              a   b   c   d   e   f   g   h  
            +---+---+---+---+---+---+---+---+
          8 |   | ♞ |   |   |   |   | ♞ |   | 8
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
          1 |   | ♘ |   |   |   |   | ♘ |   | 1
            +---+---+---+---+---+---+---+---+
              a   b   c   d   e   f   g   h  
          HEREDOC
        expect { test.show }.to output((printed_board)).to_stdout
      end

      xit 'outputs a pretty formatted grid with piece initials' do
        printed_board = 
          <<~HEREDOC

              a   b   c   d   e   f   g   h  
            +---+---+---+---+---+---+---+---+
          8 |   | N |   |   |   |   | N |   | 8
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
          1 |   | N |   |   |   |   | N |   | 1
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

  describe "#clean(piece)" do
    context 'if a piece was moved' do
      let(:knight) { Knight.new(1, 7, "\u2658") }

      it 'empties an original square' do
        test.instance_variable_set(:@board,
          [[" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", knight, " ", " ", " ", " ", " ", " "]])
        empty_board =
          [[" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "],
           [" ", " ", " ", " ", " ", " ", " ", " "]]
        test.clean(knight)
        expect(test.board).to eq(empty_board)
      end
    end
  end

  # describe "#find_pieces_by(input)" do
  #   let(:knight1) { Knight.new(1, 7, 'white') }
  #   let(:knight2) { Knight.new(6, 7, 'white') }
  #   let(:knight3) { Knight.new(1, 0, 'black') }
  #   let(:knight4) { Knight.new(6, 0, 'black') }

  #   context 'when receiving input' do
  #     it 'finds all pieces by first letter' do
  #       input = 'Na3'
  #       test.place(knight1)
  #       test.place(knight2)
  #       test.place(knight3)
  #       test.place(knight4)
  #       list_of_knights = [knight3, knight4, knight1, knight2]
  #       result = test.find_pieces_by(input)
  #       expect(result).to eq(list_of_knights)
  #     end
  #   end
  # end

  describe "#piece_moves(from, to)" do
    let(:queen) { Queen.new(4, 4, 'white') }

    before do
      test.place(queen)
    end

    context 'when moving a Queen' do
      it 'moves 1 square diagonally' do
        from = [4, 4]
        to = [5, 5]
        allow(test).to receive(:in_check?).and_return(false)
        allow(test).to receive(:show)
        test.piece_moves(from, to)
        result = test.board[to[1]][to[0]].class
        expect(result).to eq(Queen)
      end

      it 'moves 1 square horizontally' do
        from = [4, 4]
        to = [5, 4]
        allow(test).to receive(:in_check?).and_return(false)
        allow(test).to receive(:show)
        test.piece_moves(from, to)
        result = test.board[to[1]][to[0]].class
        expect(result).to eq(Queen)
      end

      it 'moves 1 square vertically' do
        from = [4, 4]
        to = [4, 3]
        allow(test).to receive(:in_check?).and_return(false)
        allow(test).to receive(:show)
        test.piece_moves(from, to)
        result = test.board[to[1]][to[0]].class
        expect(result).to eq(Queen)
      end

      it 'slides diagonally' do
        from = [4, 4]
        to = [0, 0]
        allow(test).to receive(:in_check?).and_return(false)
        allow(test).to receive(:show)
        test.piece_moves(from, to)
        result = test.board[to[1]][to[0]].class
        expect(result).to eq(Queen)
      end

      it 'slides horizontally' do
        from = [4, 4]
        to = [0, 4]
        allow(test).to receive(:in_check?).and_return(false)
        allow(test).to receive(:show)
        test.piece_moves(from, to)
        result = test.board[to[1]][to[0]].class
        expect(result).to eq(Queen)
      end

      it 'slides vertically' do
        from = [4, 4]
        to = [4, 0]
        allow(test).to receive(:in_check?).and_return(false)
        allow(test).to receive(:show)
        test.piece_moves(from, to)
        result = test.board[to[1]][to[0]].class
        expect(result).to eq(Queen)
      end
    end
  end

  describe "#route(node)" do
    let(:bishop) { Bishop.new(2, 7, 'white') }
    let(:rook) { Rook.new(0, 7, 'white') }

    before do
      test.place(bishop)
      test.place(rook)
    end

    context 'when moving a bishop' do
      xit 'shows the legal path of bishop on the board' do
        from = [2, 7]
        to = [6, 3]
        path = [[2, 7], [3, 6], [4, 5], [5, 4], [6, 3]]
        traversal = test.piece_moves(from, to)
        route = test.route(traversal)
        expect(route).to eq(path)
      end
    end

    context 'when moving a rook' do
      xit 'shows the legal path of rook on the board' do
        from = [0, 7]
        to = [0, 1]
        path = [[0, 7], [0, 6], [0, 5], [0, 4], [0, 3], [0, 2], [0, 1]]
        traversal = test.piece_moves(from, to)
        route = test.route(traversal)
        expect(route).to eq(path)
      end
    end
  end

  describe "#path_free?(src, trg)" do
    let(:bishop) { Bishop.new(2, 7, 'white') }

    before do 
      test.place(bishop)
    end

    context 'when there is only one move to target enemy piece' do
      let(:enemy_knight) { Knight.new(3, 6, 'black') }

      it 'is free' do
        test.place(enemy_knight)
        src = bishop
        trg = enemy_knight
        result = test.path_free?(src, trg)
        expect(result).to eq(true)
      end
    end

    context 'when there is only one move to target ally piece' do
      let(:ally_knight) { Knight.new(3, 6, 'white') }

      it 'is not free' do
        test.place(ally_knight)
        src = bishop
        trg = ally_knight
        result = test.path_free?(src, trg)
        expect(result).to eq(false)
      end
    end

    context 'when there are no other pieces on the sliding path to the enemy target' do
      let(:enemy_knight) { Knight.new(7, 2, 'black') }

      it 'is free' do
        test.place(enemy_knight)
        src = bishop
        trg = enemy_knight
        result = test.path_free?(src, trg)
        expect(result).to eq(true)
      end
    end

    context 'when there are no other pieces on the sliding path to the empty square' do
      xit 'is free' do
        src = bishop
        to = [2, 7]
        trg = test.board[to[0]][to[1]]
        result = test.path_free?(src, trg)
        expect(result).to eq(true)
      end
    end

    context 'when there are no other pieces on the sliding path to the ally target' do
      let(:ally_knight) { Knight.new(7, 2, 'white') }

      it 'is not free' do
        test.place(ally_knight)
        src = bishop
        trg = ally_knight
        result = test.path_free?(src, trg)
        expect(result).to eq(false)
      end
    end

    context 'when the path to the enemy is obstructed by ally piece' do
      let(:rook) { Rook.new(0, 4, 'white') }
      let(:enemy_knight) { Knight.new(7, 4, 'black') }
      let(:ally_pawn) { Pawn.new(3, 4, 'white') }

      it 'is not free' do
        test.place(rook)
        test.place(enemy_knight)
        test.place(ally_pawn)
        src = rook
        trg = enemy_knight
        result = test.path_free?(src, trg)
        expect(result).to eq(false)
      end
    end

    context 'when the path to the enemy is obstructed by another enemy piece' do
      let(:rook) { Rook.new(0, 4, 'white') }
      let(:enemy_knight) { Knight.new(7, 4, 'black') }
      let(:enemy_pawn) { Pawn.new(3, 4, 'black') }

      it 'is not free' do
        test.place(rook)
        test.place(enemy_knight)
        test.place(enemy_pawn)
        src = rook
        trg = enemy_knight
        result = test.path_free?(src, trg)
        expect(result).to eq(false)
      end
    end
  end

  describe "#valid_move?(src, trg)" do
    context 'when a Pawn moves' do
      context 'when a Pawn makes its first move' do
        let(:src) { Pawn.new(1, 6, 'white') }
        let(:trg) { Pawn.new(1, 4, 'white') }
        it 'can jump over 1 square' do
          result = test.valid_move?(src, trg)
          expect(result).to eq(true)
        end
      end

      context 'when a Pawn moves 1 square forward' do
        let(:src) { Pawn.new(1, 5, 'white') }
        let(:trg) { Pawn.new(1, 4, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to eq(true)
        end
      end

      context 'when a Pawn moves 1 square backward' do
        let(:src) { Pawn.new(1, 4, 'white') }
        let(:trg) { Pawn.new(1, 5, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to eq(false)
        end
      end

      context 'when a Pawn moves 1 square diagonally' do
        let(:src) { Pawn.new(1, 5, 'white') }
        let(:trg) { Pawn.new(2, 5, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to eq(false)
        end
      end

      context 'when a Pawn moves 1 square diagonally to attack an enemy' do
        let(:src) { Pawn.new(3, 5, 'white') }
        let(:trg) { Pawn.new(2, 4, 'white') }
        let(:enemy) { Pawn.new(2, 4, 'black') }

        it 'is valid' do
          test.place(enemy)
          result = test.valid_move?(src, trg)
          expect(result).to eq(true)
        end
      end

      context 'when a Pawn moves 1 square diagonally to attack an ally' do
        let(:src) { Pawn.new(3, 5, 'white') }
        let(:trg) { Pawn.new(2, 4, 'white') }
        let(:ally) { Pawn.new(2, 4, 'white') }

        it 'is not valid' do
          test.place(ally)
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to eq(false)
        end
      end

      context 'when a Pawn moves 1 square horizontally' do
        let(:src) { Pawn.new(1, 5, 'white') }
        let(:trg) { Pawn.new(2, 5, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to eq(false)
        end
      end
    end

    context 'when a Knight moves' do
      context 'when a Knight makes a legal move' do
        let(:src) { Knight.new(1, 7, 'white') }
        let(:trg) { Knight.new(0, 5, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to eq(true)
        end
      end

      context 'when a Knight makes a non legal move' do
        let(:src) { Knight.new(1, 7, 'white') }
        let(:trg) { Knight.new(1, 3, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to eq(false)
        end
      end
    end

    context 'when a Bishop moves' do
      context 'when a Bishop makes a legal move' do
        let(:src) { Bishop.new(2, 7, 'white') }
        let(:trg) { Bishop.new(6, 3, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to eq(true)
        end
      end

      context 'when a Bishop makes a non legal move' do
        let(:src) { Bishop.new(2, 7, 'white') }
        let(:trg) { Bishop.new(3, 3, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to eq(false)
        end
      end
    end

    context 'when a Rook moves' do
      context 'when a Rook makes a legal vertical move' do
        let(:src) { Rook.new(0, 7, 'white') }
        let(:trg) { Rook.new(0, 4, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to eq(true)
        end
      end

      context 'when a Rook makes a non legal vertical move' do
        let(:src) { Rook.new(0, 7, 'white') }
        let(:trg) { Rook.new(1, 6, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to eq(false)
        end
      end

      context 'when a Rook makes a legal horizontal move' do
        let(:src) { Rook.new(0, 4, 'white') }
        let(:trg) { Rook.new(7, 4, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to eq(true)
        end
      end

      context 'when a Rook makes a non legal horizontal move' do
        let(:src) { Rook.new(0, 4, 'white') }
        let(:trg) { Rook.new(4, 5, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to eq(false)
        end
      end
    end

    context 'when a King moves' do
      context 'when a King moves 1 square vertically' do
        let(:src) { King.new(4, 4, 'white') }
        let(:trg) { King.new(4, 5, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to eq(true)
        end
      end

      context 'when a King moves 1 square horizontally' do
        let(:src) { King.new(4, 4, 'white') }
        let(:trg) { King.new(3, 4, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to eq(true)
        end
      end

      context 'when a King moves 1 square diagonally' do
        let(:src) { King.new(4, 4, 'white') }
        let(:trg) { King.new(5, 5, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to eq(true)
        end
      end

      context 'when a King makes a non legal move' do
        let(:src) { King.new(4, 4, 'white') }
        let(:trg) { King.new(4, 6, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to eq(false)
        end
      end
    end

    context 'when a Queen moves' do
      context 'when a Queen make a legal diagonal move' do
        let(:src) { Queen.new(3, 4, 'white') }
        let(:trg) { Queen.new(0, 7, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to eq(true)
        end
      end

      context 'when a Queen makes a non legal diagonal move' do
        let(:src) { Queen.new(3, 4, 'white') }
        let(:trg) { Queen.new(0, 6, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to eq(false)
        end
      end

      context 'when a Queen makes a legal vertical move' do
        let(:src) { Queen.new(3, 4, 'white') }
        let(:trg) { Queen.new(3, 0, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to eq(true)
        end
      end

      context 'when a Queen makes a non vertical legal move' do
        let(:src) { Queen.new(3, 4, 'white') }
        let(:trg) { Queen.new(2, 7, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to eq(false)
        end
      end

      context 'when a Queen makes a legal horizontal move' do
        let(:src) { Queen.new(3, 4, 'white') }
        let(:trg) { Queen.new(7, 4, 'white') }
        it 'is valid' do
          result = test.valid_move?(src, trg)
          expect(result).to eq(true)
        end
      end

      context 'when a Queen makes a non legal horizontal move' do
        let(:src) { Queen.new(3, 4, 'white') }
        let(:trg) { Queen.new(7, 3, 'white') }
        it 'is not valid' do
          allow(test).to receive(:puts)
          result = test.valid_move?(src, trg)
          expect(result).to eq(false)
        end
      end
    end
  end

  describe "#enemy?(from, to)" do
    context 'when there is an opponent on the way' do

      let(:bishop) { Bishop.new(3, 3, 'white') }
      let(:knight) { Knight.new(6, 6, 'black') }

      before do 
        test.place(bishop)
        test.place(knight)
      end

      it 'detects it' do
        from = [3, 3]
        to = [6, 6]
        result = test.enemy?(from, to)
        expect(result).to eq(true)
      end
    end

    context 'when there is an ally on the way' do

      let(:bishop) { Bishop.new(3, 3, 'white') }
      let(:knight) { Knight.new(6, 6, 'white') }

      before do 
        test.place(bishop)
        test.place(knight)
      end

      it 'detects it' do
        from = [3, 3]
        to = [6, 6]
        result = test.enemy?(from, to)
        expect(result).to eq(false)
      end
    end
  end

  describe "#in_check?" do
    let(:king) { King.new(4, 4, 'white') }
    before do
      test.place(king)
    end
    # context 'when a King is under immediate attack' do
    context 'when a King is under immediate Pawn\'s attack' do
      let(:pawn) { Pawn.new(3, 3, 'black') }
      it 'is in check' do
        test.place(pawn)
        result = test.in_check?(pawn)
        expect(result).to eq(true)
      end
    end

    context 'when a King is under immediate Rook\'s attack' do
      let(:rook) { Rook.new(4, 0, 'black') }
      it 'is in check' do
        test.place(rook)
        result = test.in_check?(rook)
        expect(result).to eq(true)
      end
    end

    context 'when a King is under immediate Bishop\'s attack' do
      let(:bishop) { Bishop.new(1, 1, 'black') }
      it 'is in check' do
        test.place(bishop)
        result = test.in_check?(bishop)
        expect(result).to eq(true)
      end
    end

    context 'when a King is under immediate Knight\'s attack' do
      let(:knight) { Knight.new(2, 3, 'black') }
      it 'is in check' do
        test.place(knight)
        result = test.in_check?(knight)
        expect(result).to eq(true)
      end
    end

    context 'when a King is under immediate Queen\'s attack' do
      let(:queen) { Queen.new(0, 4, 'black') }
      it 'is in check' do
        test.place(queen)
        result = test.in_check?(queen)
        expect(result).to eq(true)
      end
    end

    context 'when a King is under immediate enemy King\'s attack' do
      let(:enemy_king) { King.new(5, 5, 'black') }
      it 'is in check' do
        test.place(enemy_king)
        result = test.in_check?(enemy_king)
        expect(result).to eq(true)
      end
    end

    context 'when none of enemy pieces can attack King' do
      let(:pawn) { Pawn.new(5, 2, 'black') }
      let(:rook) { Rook.new(1, 1, 'black') }
      let(:bishop) { Bishop.new(7, 2, 'black') }
      let(:knight) { Knight.new(0, 3, 'black') }
      let(:queen) { Queen.new(1, 5, 'black') }

      it 'is not in check' do
        test.place(pawn)
        test.place(rook)
        test.place(bishop)
        test.place(knight)
        test.place(queen)
        result = test.in_check?(rook)
        expect(result).to eq(false)
      end
    end

    context 'when an ally piece is defending King' do
      let(:pawn) { Pawn.new(3, 3, 'white') }
      let(:queen) { Queen.new(1, 1, 'black') }

      it 'is not in check' do
        test.place(pawn)
        test.place(queen)
        result = test.in_check?(queen)
        expect(result).to eq(false)
      end
    end

    context 'when King is hiding behind an enemy Pawn' do
      let(:pawn) { Pawn.new(4, 3, 'black') }
      # let(:pawn) { Pawn.new(4, 3, 'white') }

      # let(:queen) { Queen.new(4, 0, 'black') }
      let(:rook) { Rook.new(4, 0, 'black') }


      it 'is not in check' do
        test.place(pawn)
        # test.place(queen)
        test.place(rook)
        # result = test.in_check?(queen)
        result = test.in_check?(rook)
        expect(result).to eq(false)
      end
    end

    context 'when a King is not under attack' do
      it 'is not in check' do
      
      end
    end
  end
end