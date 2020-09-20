require './lib/modules/lan_converter'
require './lib/game'

describe LanConverter do
  let(:test) { Game.new }
  
  describe "#split_lan(input)" do
    context 'when receiving an input in long algebraic notation (LAN) form' do
      it 'splits it into parts: source and target square' do
        input = 'b1a3'
        splitted_input = ['b1', 'a3']
        result = test.split_lan(input)
        expect(result).to eq(splitted_input)
      end
    end
  end

  describe "#rank_coord(input)" do
    context 'when receiving an algebraic notation of a square' do
      it 'converts the rank number to the board row coordinates' do
        square_an = 'a3'
        raw = 5
        result = test.rank_coord(square_an)
        expect(result).to eq(raw)
      end
    end
  end

  describe "#file_coord(input)" do
    context 'when receiving an algebraic notation of a square' do
      it 'converts the file letter to the board column coordinates' do
        square_an = 'a3'
        col = 0
        result = test.file_coord(square_an)
        expect(result).to eq(col)
      end
    end
  end
end
