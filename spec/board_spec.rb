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
      # src = king
    end
    # context 'when a King is under immediate attack' do
    context 'when a King is under immediate Pawn\'s attack' do
      let(:pawn) { Pawn.new(3, 3, 'black') }
      it 'is in check' do
        test.place(pawn)
        color = 'white'
        result = test.in_check?(color)
        expect(result).to eq(true)
      end
    end

    context 'when a King is under immediate Rook\'s attack' do
      let(:rook) { Rook.new(4, 0, 'black') }
      it 'is in check' do
        test.place(rook)
        color = 'white'
        result = test.in_check?(color)
        expect(result).to eq(true)
      end
    end

    context 'when a King is under immediate Bishop\'s attack' do
      let(:bishop) { Bishop.new(1, 1, 'black') }
      it 'is in check' do
        test.place(bishop)
        color = 'white'
        result = test.in_check?(color)
        expect(result).to eq(true)
      end
    end

    context 'when a King is under immediate Knight\'s attack' do
      let(:knight) { Knight.new(2, 3, 'black') }
      it 'is in check' do
        test.place(knight)
        src = king
        color = 'white'
        result = test.in_check?(color)
        expect(result).to eq(true)
      end
    end

    context 'when a King is under immediate Queen\'s attack' do
      let(:queen) { Queen.new(0, 4, 'black') }
      it 'is in check' do
        test.place(queen)
        color = 'white'
        result = test.in_check?(color)
        expect(result).to eq(true)
      end
    end

    context 'when a King is under immediate enemy King\'s attack' do
      let(:enemy_king) { King.new(5, 5, 'black') }
      it 'is in check' do
        test.place(enemy_king)
        color = 'white'
        result = test.in_check?(color)
        expect(result).to eq(true)
      end
    end

    # context 'when none of enemy pieces can attack King' do
    context 'when King is not under attack' do

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
        color = 'white'
        result = test.in_check?(color)
        expect(result).to eq(false)
      end
    end

    # context 'when an ally piece is defending King' do
    context 'when interposing an ally piece between the checking piece and the King' do

      let(:pawn) { Pawn.new(3, 3, 'white') }
      let(:queen) { Queen.new(1, 1, 'black') }

      it 'is not in check' do
        test.place(pawn)
        test.place(queen)
        color = 'white'
        result = test.in_check?(color)
        expect(result).to eq(false)
      end
    end

    # context 'when King is hiding behind an enemy Pawn' do
    context 'when interposing an enemy piece between the checking piece and the King' do
      let(:pawn) { Pawn.new(4, 3, 'black') }
      let(:rook) { Rook.new(4, 0, 'black') }

      it 'is not in check' do
        test.place(pawn)
        test.place(rook)
        color = 'white'
        result = test.in_check?(color)
        expect(result).to eq(false)
      end
    end
  end

  describe "#no_legal_move_to_escape?(src)" do
    context 'when King has no legal moves to escape check' do
      #Blackburne's mate
      let(:black_king) { King.new(6, 0, 'black') }
      let(:rook) { Rook.new(5, 0, 'black') }
      let(:bishop_one) { Bishop.new(7, 1, 'white') }
      let(:bishop_two) { Bishop.new(1, 6, 'white') }
      let(:knight) { Knight.new(6, 3, 'white') }
  
      before do
        test.place(black_king)
        test.place(rook)
        test.place(bishop_one)
        test.place(bishop_two)
        test.place(knight)
      end

      it 'is checkmate' do
        color = 'black'
        result = test.no_legal_move_to_escape?(color)
        expect(result).to eq(true)
      end
    end

    context 'when King has no legal moves to escape check' do
      let(:black_king) { King.new(6, 0, 'black') }
      let(:rook) { Rook.new(5, 0, 'black') }
      let(:bishop_one) { Bishop.new(7, 1, 'white') }
      let(:bishop_two) { Bishop.new(1, 6, 'white') }
      let(:pawn) { Pawn.new(6, 3, 'white') }
  
      before do
        test.place(black_king)
        test.place(rook)
        test.place(bishop_one)
        test.place(bishop_two)
        test.place(pawn)
      end

      it 'is not checkmate' do
        color = 'black'
        result = test.no_legal_move_to_escape?(color)
        expect(result).to eq(false)
      end
    end
  end

  describe "#no_capture_moves?(src)" do
    context 'when King can not capture to escape check' do
      #Anderssen's mate
      let(:black_king) { King.new(6, 0, 'black') }
      let(:rook) { Rook.new(7, 0, 'white') }
      let(:pawn) { Pawn.new(6, 1, 'white') }
      let(:white_king) { King.new(5, 2, 'white') }
  
      before do
        test.place(black_king)
        test.place(rook)
        test.place(pawn)
        test.place(white_king)
      end

      it 'is checkmate' do
        color = 'black'
        result = test.no_capture_moves?(color)
        expect(result).to eq(true)
      end
    end

    context 'when King can capture checking piece to escape check' do
      let(:king) { King.new(6, 0, 'black') }
      let(:rook) { Rook.new(7, 0, 'white') }
      let(:queen) { Queen.new(6, 1, 'white') }
  
      before do
        test.place(king)
        test.place(rook)
        test.place(queen)
      end

      it 'is not checkmate' do
        color = 'black'
        result = test.no_capture_moves?(color)
        expect(result).to eq(false)
      end
    end
  end

  describe "#no_empty_squares_not_under_attack?(src)" do
    context 'when there are no empty squares to escape check' do
      let(:white_king) { King.new(7, 7, 'white') }
      let(:black_king) { King.new(7, 5, 'black') }
      let(:bishop_one) { Bishop.new(4, 5, 'black') }
      let(:bishop_two) { Bishop.new(5, 5, 'black') }
  
      before do
        test.place(white_king)
        test.place(black_king)
        test.place(bishop_one)
        test.place(bishop_two)
      end

      it 'is checkmate' do
        color = 'white'
        result = test.no_empty_squares_not_under_attack?(color)
        expect(result).to eq(true)
      end
    end

    context 'when King can move to empty square to escape check' do
      let(:white_king) { King.new(7, 7, 'white') }
      let(:black_king) { King.new(7, 5, 'black') }
      let(:bishop_two) { Bishop.new(5, 5, 'black') }
  
      before do
        test.place(white_king)
        test.place(black_king)
        test.place(bishop_two)
      end

      it 'is not checkmate' do
        color = 'white'
        result = test.no_empty_squares_not_under_attack?(color)
        expect(result).to eq(false)
      end
    end
  end

  describe "#ally_can_capture_checking_piece?" do
    let(:black_king) { King.new(6, 0, 'black') }
    let(:rook) { Rook.new(3, 0, 'white') }
    let(:pawn_f7) { Pawn.new(5, 1, 'black') }
    let(:pawn_g7) { Pawn.new(6, 1, 'black') }
    let(:pawn_h7) { Pawn.new(7, 1, 'black') }

    before do
      test.place(black_king)
      test.place(rook)
      test.place(pawn_f7)
      test.place(pawn_g7)
      test.place(pawn_h7)
    end

    context 'when no ally can capture a checking piece' do
      it 'is checkmate' do
        color = 'black'
        result = test.no_ally_can_capture_checking_piece?(color)
        expect(result).to eq(true)
      end
    end

    context 'when an ally can capture a checking piece' do
      let(:queen) { Queen.new(3, 5, 'black') }

      it 'is not checkmate' do
        test.place(queen)
        color = 'black'
        result = test.no_ally_can_capture_checking_piece?(color)
        expect(result).to eq(false)
      end
    end
  end

  describe "#no_ally_can_block_checking_piece?" do
    context 'when no ally can block a checking piece path' do
      let(:black_king) { King.new(6, 0, 'black') }
      let(:rook) { Rook.new(3, 0, 'white') }
      let(:pawn_f7) { Pawn.new(5, 1, 'black') }
      let(:pawn_g7) { Pawn.new(6, 1, 'black') }
      let(:pawn_h7) { Pawn.new(7, 1, 'black') }

      before do
        test.place(black_king)
        test.place(rook)
        test.place(pawn_f7)
        test.place(pawn_g7)
        test.place(pawn_h7)
      end

      it 'is checkmate' do
        color = 'black'
        result = test.no_ally_can_block_checking_piece?(color)
        expect(result).to eq(true)
      end
    end

    context 'when an ally can block a checking piece path' do
      let(:black_king) { King.new(7, 0, 'black') }
      let(:bishop) { Bishop.new(7, 1, 'black') }
      let(:rook_one) { Rook.new(6, 7, 'white') }
      let(:rook_two) { Rook.new(1, 0, 'white') }

      before do
        test.place(black_king)
        test.place(bishop)
        test.place(rook_one)
        test.place(rook_two)
      end
      
      it 'is not checkmate' do
        color = 'black'
        result = test.no_ally_can_block_checking_piece?(color)
        expect(result).to eq(false)
      end
    end
  end

  describe "#checkmate?" do
    context 'when there is no legal move to escape check' do
      #Corner mate
      let(:black_king) { King.new(7, 0, 'black') }
      let(:black_pawn) { Pawn.new(7, 1, 'black') }
      let(:knight) { Knight.new(5, 1, 'white') }
      let(:rook) { Rook.new(6, 7, 'white') }  

      before do
        test.place(black_king)
        test.place(black_pawn)
        test.place(knight)
        test.place(rook)
      end

      it 'is checkmate' do
        color = 'black'
        result = test.checkmate?(color)
        expect(result).to eq(true)
      end
    end

    context 'when there is a way to escape check' do
      let(:black_king) { King.new(7, 0, 'black') }
      let(:white_pawn) { Pawn.new(7, 1, 'white') }
      let(:knight) { Knight.new(5, 1, 'white') }
      let(:rook) { Rook.new(6, 7, 'white') }

      before do
        test.place(black_king)
        test.place(white_pawn)
        test.place(knight)
        test.place(rook)
      end

      it 'is not checkmate' do
        color = 'black'
        result = test.checkmate?(color)
        expect(result).to eq(false)
      end
    end
  end

  describe "#short_castling" do
    let(:white_king) { King.new(4, 7, 'white') }
    let(:black_king) { King.new(4, 0, 'black') }
    let(:white_rook_kingside) { Rook.new(7, 7, 'white') }
    let(:white_rook_queenside) { Rook.new(0, 7, 'white') }
    let(:black_rook_kingside) { Rook.new(7, 0, 'black') }
    let(:black_rook_queenside) { Rook.new(0, 0, 'black') }

    before do
      test.place(white_king)
      test.place(black_king)
      test.place(white_rook_kingside)
      test.place(white_rook_queenside)
      test.place(black_rook_kingside)
      test.place(black_rook_queenside)
    end

    context 'when King is short castling' do
      color = 'white'
      input = '00'

      it 'places King two squares towards a rook kingside' do
        test.castling(color, input)
        new_pos = test.board[7][6]
        expect(new_pos.class).to eq(King)
      end

      it 'places Rook on the last square the King just crossed' do
        test.castling(color, input)
        new_pos = test.board[7][5]
        expect(new_pos.class).to eq(Rook)
      end

      it 'removes King from its original position' do
        test.castling(color, input)
        original_pos = test.board[7][4]
        expect(original_pos).to eq(' ')
      end

      it 'removes Rook from its original position' do
        test.castling(color, input)
        original_pos = test.board[7][7]
        expect(original_pos).to eq(' ')
      end
    end
  end
  
  describe "#long_castling" do
    let(:white_king) { King.new(4, 7, 'white') }
    let(:black_king) { King.new(4, 0, 'black') }
    let(:white_rook_kingside) { Rook.new(7, 7, 'white') }
    let(:white_rook_queenside) { Rook.new(0, 7, 'white') }
    let(:black_rook_kingside) { Rook.new(7, 0, 'black') }
    let(:black_rook_queenside) { Rook.new(0, 0, 'black') }
  
    before do
      test.place(white_king)
      test.place(black_king)
      test.place(white_rook_kingside)
      test.place(white_rook_queenside)
      test.place(black_rook_kingside)
      test.place(black_rook_queenside)
    end
    
    context 'when King is long castling' do
      color = 'black'
      input = '000'

      it 'places King two squares towards a rook queenside' do
        test.castling(color, input)
        new_pos = test.board[0][2]
        expect(new_pos.class).to eq(King)
      end

      it 'places Rook on the last square the King just crossed' do
        test.castling(color, input)
        new_pos = test.board[0][3]
        expect(new_pos.class).to eq(Rook)
      end

      it 'removes King from its original position' do
        test.castling(color, input)
        original_pos = test.board[0][4]
        expect(original_pos).to eq(' ')
      end

      it 'removes Rook from its original position' do
        test.castling(color, input)
        original_pos = test.board[0][0]
        expect(original_pos).to eq(' ')
      end
    end
  end

  describe "#castling_permissible?(color)" do

    let(:white_king) { King.new(4, 7, 'white') }
    let(:white_rook_kingside) { Rook.new(7, 7, 'white') }
    let(:white_rook_queenside) { Rook.new(0, 7, 'white') }
  
    before do
      test.place(white_king)
      test.place(white_rook_kingside)
      test.place(white_rook_queenside)
      test.save_originals
    end

    context 'when King has not moved previously during the game' do
      it 'is permissible' do
        input = '00'
        color = 'white'
        result = test.castling_permissible?(color, input)
        expect(result).to eq(true)
      end
    end

    context 'when King has moved previously during the game' do
      let(:new_king) { King.new(4, 7, 'white') }

      it 'is not permissible' do 
        input = '00'
        color = 'white'
        test.place(new_king)
        result = test.castling_permissible?(color, input)
        expect(result).to eq(false)
      end
    end

    context 'when Rook has not moved previously during the game' do
      it 'is permissible' do
        input = '00'
        color = 'white'
        result = test.castling_permissible?(color, input)
        expect(result).to eq(true)
      end
    end

    context 'when Rook has moved previously during the game' do
      let(:new_rook) { Rook.new(7, 7, 'white') }

      it 'is not permissible' do
        input = '00'
        color = 'white'
        test.place(new_rook)
        result = test.castling_permissible?(color, input)
        expect(result).to eq(false)
      end
    end

    context 'when there are no pieces between King and Rook' do
      it 'is permissible' do 
        input = '00'
        color = 'white'
        result = test.castling_permissible?(color, input)
        expect(result).to eq(true)
      end
    end

    context 'when there are pieces between King and Rook' do
      let(:pawn) { Pawn.new(6, 7, 'white') }
      it 'is not permissible' do 
        input = '00'
        color = 'white'
        test.place(pawn)
        result = test.castling_permissible?(color, input)
        expect(result).to eq(false)
      end
    end

    context 'when King is not in check' do
      it 'is permissible' do 
        input = '00'
        color = 'white'
        result = test.castling_permissible?(color, input)
        expect(result).to eq(true)
      end
    end

    context 'when King is in check' do
      let(:queen) { Queen.new(4, 4, 'black') }

      it 'is not permissible' do
        test.place(queen)
        input = '00'
        color = 'white'
        result = test.castling_permissible?(color, input)
        expect(result).to eq(false)
      end
    end

    context 'when King does not pass through a square under attack' do
      it 'is permissible' do 
        input = '00'
        color = 'white'
        result = test.castling_permissible?(color, input)
        expect(result).to eq(true)
      end
    end

    context 'when King passes through a square under attack' do
      let(:queen) { Queen.new(5, 4, 'black') }

      it 'is not permissible' do 
        test.place(queen)
        input = '00'
        color = 'white'
        result = test.castling_permissible?(color, input)
        expect(result).to eq(false)
      end
    end

    context 'when King does not end up in check' do
      it 'is permissible' do 
        input = '00'
        color = 'white'
        result = test.castling_permissible?(color, input)
        expect(result).to eq(true)
      end
    end

    context 'when King ends up in check' do
      let(:queen) { Queen.new(6, 4, 'black') }

      it 'is not permissible' do
        test.place(queen)
        input = '00'
        color = 'white'
        result = test.castling_permissible?(color, input)
        expect(result).to eq(false)
      end
    end
  end

  describe "#en_passant?" do
    let(:attacking_white_pawn) { Pawn.new(5, 3, 'white') }
    let(:trg) { Pawn.new(4, 2, 'white') }

    before do 
      test.place(attacking_white_pawn)
      # test.place(attacking_black_pawn)
    end

    context 'when the capturing pawn is on its fifth rank' do
      it 'is permissible' do
        src = attacking_white_pawn
        allow(test).to receive(:adjacent?).and_return(true)
        allow(test).to receive(:just_double_moved?).and_return(true)
        allow(test).to receive(:capture?).and_return(true)
        result = test.en_passant?(src, trg)
        expect(result).to eq(true)
      end
    end

    context 'when the capturing pawn is on its forth rank' do
      let(:attacking_black_pawn) { Pawn.new(3, 4, 'black') }

      it 'is permissible' do
        test.place(attacking_black_pawn)
        src = attacking_black_pawn
        allow(test).to receive(:adjacent?).and_return(true)
        allow(test).to receive(:just_double_moved?).and_return(true)
        allow(test).to receive(:capture?).and_return(true)
        result = test.en_passant?(src, trg)
        expect(result).to eq(true)
      end
    end

    context 'when the capturing pawn is not on its forth or fifth rank' do
      let(:pawn) { Pawn.new(5, 5, 'white') }

      it 'is not permissible' do
        test.place(pawn)
        src = pawn
        allow(test).to receive(:adjacent?).and_return(true)
        result = test.en_passant?(src, trg)
        expect(result).to eq(false)
      end
    end

    context 'when the captured pawn is on adjacent file to the attacking pawn' do
      let(:captured_black_pawn) { Pawn.new(4, 3, 'black') }

      it 'is permissible' do
        test.place(captured_black_pawn)
        allow(test).to receive(:just_double_moved?).and_return(true)
        src = attacking_white_pawn
        result = test.en_passant?(src, trg)
        expect(result).to eq(true)
      end
    end

    context 'when the captured pawn is not adjacent to the attacking pawn' do
      let(:captured_black_pawn) { Pawn.new(3, 3, 'black') }

      it 'is not permissible' do
        test.place(captured_black_pawn)
        src = attacking_white_pawn
        result = test.en_passant?(src, trg)
        expect(result).to eq(false)
      end
    end

    context 'when the captured pawn has just performed a double-step move' do
      let(:captured_black_pawn) { Pawn.new(4, 3, 'black') }

      it 'is permissible' do
        test.place(captured_black_pawn)
        test.instance_variable_set(:@history, [[[4, 1], [4, 3]]])
        src = attacking_white_pawn
        result = test.en_passant?(src, trg)
        expect(result).to eq(true)
      end
    end

    context 'when the captured pawn has not performed a double-step move' do
      let(:captured_black_pawn) { Pawn.new(4, 3, 'black') }

      it 'is not permissible' do
        test.place(captured_black_pawn)
        test.instance_variable_set(:@history, [[[4, 2], [4, 3]]])
        src = attacking_white_pawn
        result = test.en_passant?(src, trg)
        expect(result).to eq(false)
      end
    end

    context 'when the capture is made on the move immediately after the enemy pawn makes the double-step move' do
      let(:captured_black_pawn) { Pawn.new(4, 3, 'black') }

      it 'is permissible' do
        test.place(captured_black_pawn)
        src = attacking_white_pawn
        allow(test).to receive(:adjacent?).and_return(true)
        allow(test).to receive(:just_double_moved?).and_return(true)
        result = test.en_passant?(src, trg)
        expect(result).to eq(true)
      end
    end

    context 'when the capture is not made on the move immediately after the enemy pawn makes the double-step move' do
      let(:captured_black_pawn) { Pawn.new(4, 3, 'black') }

      it 'is not permissible' do
        test.place(captured_black_pawn)
        src = attacking_white_pawn
        wrong_trg = Pawn.new(5, 2, 'white')
        allow(test).to receive(:adjacent?).and_return(true)
        allow(test).to receive(:just_double_moved?).and_return(true)
        result = test.en_passant?(src, wrong_trg)
        expect(result).to eq(false)
      end
    end
  end

  describe "#promotion?" do
    context 'when a pawn reaches the eighth rank' do
      let(:pawn) { Pawn.new(4, 0, 'white') }

      it 'is eligible for promotion' do 
        trg = pawn
        result = test.promotion?(trg)
        expect(result).to eq(true)
      end
    end
  end

  # describe "#promote(trg)" do
  #   let(:pawn) { Pawn.new(4, 0, 'white') }

  #   context 'when eligible for promotion' do
  #     it 'replaces the pawn with the player\'s choice' do
  #       trg = pawn
  #       input = 'r'

  #       result  = test.promote(trg).is_a?(Rook)
  #       expect(result).to eq(true)
  #     end
  #   end
  # end

  describe "#stalemate?" do
    let(:black_king) { King.new(7, 0, 'black') }
    let(:white_king) { King.new(5, 1, 'white') }
    let(:queen) { Queen.new(6, 2, 'white') }

    before do
      test.place(black_king)
      test.place(white_king)
      test.place(queen)
    end

    context 'when player is not in check and there is no legal move' do
      it 'is stalemate' do
        color = 'black'
        result = test.stalemate?(color)
        expect(result).to eq(true)
      end
    end

    context 'when player is in check and there is no legal move' do
      let(:rook) { Rook.new(2, 0, 'white') }

      it 'is not stalemate' do
        test.place(rook)
        color = 'black'
        result = test.stalemate?(color)
        expect(result).to eq(false)
      end
    end

    context 'when player is not in check and there is legal move' do
      
      it 'is not stalemate' do
        test.clean(queen)
        color = 'black'
        result = test.stalemate?(color)
        expect(result).to eq(false)
      end
    end


  end
end