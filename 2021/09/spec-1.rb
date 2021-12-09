require File.join(__dir__, 'solution-1')

RSpec.describe Solution do
  let(:example_heightmap) {
    [
      [2, 1, 9, 9, 9, 4, 3, 2, 1, 0],
      [3, 9, 8, 7, 8, 9, 4, 9, 2, 1],
      [9, 8, 5, 6, 7, 8, 9, 8, 9, 2],
      [8, 7, 6, 7, 8, 9, 6, 7, 8, 9],
      [9, 8, 9, 9, 9, 6, 5, 6, 7, 8]
    ]
  }

  describe Solution::Normalizer do
    it 'extracts the heightmap as an array of numbers per line of the file' do
      expect(described_class.do_it(File.join(__dir__,'example.txt'))).to eq example_heightmap
    end
  end

  it 'gives the correct solution for the example' do
    low_point_detector = described_class.new(example_heightmap)
    expect(low_point_detector.low_points).to eq [[1,0], [9,0], [2,2], [6,4]]
    expect(low_point_detector.low_points_heights).to eq [1, 0, 5, 5]
    expect(low_point_detector.result).to eq 15
  end
end
