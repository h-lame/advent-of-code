require File.join(__dir__, 'solution-1')

RSpec.describe Solution do
  let(:example_vents) {
    [
      [[0,9], [5,9]],
      [[8,0], [0,8]],
      [[9,4], [3,4]],
      [[2,2], [2,1]],
      [[7,0], [7,4]],
      [[6,4], [2,0]],
      [[0,9], [2,9]],
      [[3,4], [1,4]],
      [[0,0], [8,8]],
      [[5,5], [8,2]]
    ]
  }

  describe Solution::Normalizer do
    it 'extracts the vents from the file as an array of pairs of numeric co-ordinates, one pair per line' do
      expect(described_class.do_it(File.join(__dir__,'example.txt'))).to eq example_vents
    end
  end

  it 'gives the correct solution for the example' do
    vent_detector = described_class.new(example_vents)
    expect(vent_detector.relevant_vents_size).to eq 6
    expect(vent_detector.result).to eq 5
  end
end
