require File.join(__dir__, 'solution-2')

RSpec.describe Solution do
  let(:example_positions) { [4,8] }

  describe Solution::Normalizer do
    it 'extracts the player positions as a pair of integers, one extracted from the first two lines of the file' do
      expect(described_class.do_it(File.join(__dir__,'example.txt'))).to eq example_positions
    end
  end

  it 'generates the correct solution for the example' do
    game = described_class.new(example_positions)

    expect(game.result).to eq 444356092776315
  end
end
