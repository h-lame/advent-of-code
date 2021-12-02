require File.join(__dir__, 'solution-2')


RSpec.describe Solution do
  let(:example_scans) { [199, 200, 208, 210, 200, 207, 240, 269, 260, 263] }

  describe Solution::Normalizer do
    it 'converts a file into an array of numbers, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq example_scans
    end
  end

  it 'gives the correct solution for the example' do
    expect(described_class.new(example_scans).result).to eq 5
  end
end
