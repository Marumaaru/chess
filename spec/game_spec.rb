require './lib/game'

describe Game do
  subject(:game_test) { described_class.new }

  describe "#convert_lan_to_coords(input)" do
    context 'when receiving a long algebraic notation (LAN) input' do
      
      it 'splits LAN into source and target' do
        input = 'b1a3'
        splitted_input = ['b1', 'a3']
        result = game_test.split_lan(input)
        expect(result).to eq(splitted_input)
      end

      it 'converts rank numbers to board coords' do
        input = 'a3'
        rank_coord = 5
        result = game_test.rank_coord(input)
        expect(result).to eq(rank_coord)
      end

      it 'converts file letters to board coords' do
        input = 'b1'
        file_coord = 1
        result = game_test.file_coord(input)
        expect(result).to eq(file_coord)
      end

      it 'converts LAN input into starting square board coords' do
        input = 'b1a3'
        from_coords = [7, 1]
        result = game_test.starting_coords(input)
        expect(result).to eq(from_coords)
      end

      it 'converts LAN input into ending square board coords' do
        input = 'b1a3'
        to_coords = [5, 0]
        result = game_test.ending_coords(input)
        expect(result).to eq(to_coords)
      end
    end
  end
end

# describe "#make_move(input)" do
#   context 'when making move' do
#     before do
#       input = 'Na3'
#       game_test.populate_board
#       game_test.make_move(input)
#     end

#     xit 'creates a new piece on the target square' do
#       trg_square = game_test.board.board[5][0]
#       expect(trg_square.class).to eq(Knight)
#     end

#     xit 'empties source square of the piece' do
#       src_square = game_test.board.board[7][1]
#       expect(src_square.class).to eq(String)
#     end
#   end
# end

# describe "#activate_piece_by(input)" do
#   context 'when receiving algebraic input' do
#     it 'activates a wanted piece' do
#       input = 'Na3'
#       game_test.populate_board
#       wanted_knight = game_test.board.board[7][1]
#       result = game_test.activate_piece_by(input)
#       expect(result).to eq(wanted_knight)
#     end
#   end
# end

# describe "#convert_move(input)" do
#   context 'when receiving algebraic input' do
#     it 'converts it to board coordinates' do
#       input = 'Na3'
#       coords = [0, 5]
#       result = game_test.convert_move(input)
#       expect(result).to eq(coords)
#     end
#   end
# end

# describe "#convert_file_algebraic_notation(input)" do
#   context 'when receiving input' do
#     it 'converts it to board coordinates' do
#       input = 'a3'
#       file = 0
#       result = game_test.convert_file_algebraic_notation(input)
#       expect(result).to eq(file)
#     end
#   end
# end

# describe "#convert_rank_algebraic_notation(input)" do
#   context 'when receiving input' do
#     it 'converts it to board coordinates' do
#       input = 'Na3'
#       rank = 5
#       result = game_test.convert_rank_algebraic_notation(input)
#       expect(result).to eq(rank)
#     end
#   end
# end

