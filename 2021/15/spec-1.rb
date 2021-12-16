require File.join(__dir__, 'solution-1')

RSpec.describe Solution do
  let(:example_chiton_density) {
    [
      [1, 1, 6, 3, 7, 5, 1, 7, 4, 2],
      [1, 3, 8, 1, 3, 7, 3, 6, 7, 2],
      [2, 1, 3, 6, 5, 1, 1, 3, 2, 8],
      [3, 6, 9, 4, 9, 3, 1, 5, 6, 9],
      [7, 4, 6, 3, 4, 1, 7, 1, 1, 1],
      [1, 3, 1, 9, 1, 2, 8, 1, 3, 7],
      [1, 3, 5, 9, 9, 1, 2, 4, 2, 1],
      [3, 1, 2, 5, 4, 2, 1, 6, 3, 9],
      [1, 2, 9, 3, 1, 3, 8, 5, 2, 1],
      [2, 3, 1, 1, 9, 4, 4, 5, 8, 1],
    ]
  }

  describe Solution::Normalizer do
    it 'extracts the chiton density as an array of arrays of integers, one per line of the file' do
      expect(described_class.do_it(File.join(__dir__,'example.txt'))).to eq example_chiton_density
    end
  end

  it 'generates the correct shortest path to the bottom right' do
    path_finder = described_class.new(example_chiton_density)

    expect(path_finder.path[:route]).to eq [
      [0,0],
      [0,1],
      [0,2], [1,2], [2,2], [3,2], [4,2], [5,2], [6,2],
                                                [6,3], [7,3],
                                                       [7,4],
                                                       [7,5], [8,5],
                                                              [8,6],
                                                              [8,7],
                                                              [8,8], [9,8],
                                                                     [9,9],
    ]
  end

  it 'generates the correct solution for the example' do
    path_finder = described_class.new(example_chiton_density)

    expect(path_finder.result).to eq 40
  end
end
