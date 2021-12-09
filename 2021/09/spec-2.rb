require File.join(__dir__, 'solution-2')

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
    expect(low_point_detector.low_points).to match_array [[1,0], [9,0], [2,2], [6,4]]
    expect(low_point_detector.basin_for(*[1,0])).to match_array [[0,0], [1,0], [0,1]]
    expect(low_point_detector.basin_for(*[9,0])).to match_array [[5,0], [6,0], [7,0], [8,0], [9,0], [6,1], [8,1], [9,1], [9,2]]
    expect(low_point_detector.basin_for(*[2,2])).to match_array [[2,1], [3,1], [4,1], [1,2], [2,2], [3,2], [4,2], [5,2], [0,3], [1,3], [2,3], [3,3], [4,3], [1,4]]
    expect(low_point_detector.basin_for(*[6,4])).to match_array [[7,2], [6,3], [7,3], [8,3], [5,4], [6,4], [7,4], [8,4], [9,4]]
    expect(low_point_detector.largest_basin_sizes(3)).to match_array [14, 9, 9]
    expect(low_point_detector.result).to eq 1134
  end
end
