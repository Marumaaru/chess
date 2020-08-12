require './lib/knight'

describe Knight do
  let(:file) { 1 }
  let(:rank) { 7 }
  subject(:knight_test) { described_class.new(file, rank) }

  describe "#initialize" do
    context 'when initializing a Knight piece' do
    
      it 'should have a name' do
        expect(knight_test.name).to eq('K')
      end

      xit 'should be placed on b8' do
        expect(knight_test.file).to eq(1)
        expect(knight_test.rank).to eq(7)
      end
    end
  end
end
