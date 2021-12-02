require File.join(__dir__, 'solution-1')

RSpec.describe Solution do
  let(:example_moves) { [[:forward, 5], [:down, 5], [:forward, 8], [:up, 3], [:down, 8], [:forward, 2]] }

  describe Solution::Normalizer do
    it 'converts a file into an array of symbols and numbers, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq example_moves
    end
  end

  it 'gives the correct solution for the example' do
    navicomp = described_class.new(example_moves)
    expect(navicomp.depth).to eq 10
    expect(navicomp.horizontal_position).to eq 15
    expect(navicomp.result).to eq 150
  end
end
