require './lib/game'

describe Game do
  subject(:test) { described_class.new }

  describe "#play" do
    context 'when playing a game' do
      it 'loops until the game is over' do
        allow(test).to receive(:update_display)
        allow(test).to receive(:announce_results)
        allow(test).to receive(:game_finished?).and_return(false, false, false, true)
        expect(test).to receive(:players_take_turns).exactly(3).times
        test.play
      end
    end

    context 'when game is over' do
      it 'announces results' do
        allow(test).to receive(:update_display)
        allow(test).to receive(:game_finished?).and_return(true)
        expect(test).to receive(:announce_results)
        test.play
      end
    end
  end
end
