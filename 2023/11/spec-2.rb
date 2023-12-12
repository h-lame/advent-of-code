require File.join(__dir__, 'solution-2')

RSpec.describe Solution2 do
  let(:raw_universe) { [
    '...#......',
    '.......#..',
    '#.........',
    '..........',
    '......#...',
    '.#........',
    '.........#',
    '..........',
    '.......#..',
    '#...#.....',
  ] }

  # '..o#.o..o.',
  # '..o..o.#o.',
  # '#.o..o..o.',
  # 'oooooooooo',
  # '..o..o#.o.',
  # '.#o..o..o.',
  # '..o..o..o#',
  # 'oooooooooo',
  # '..o..o.#o.',
  # '#.o.#o..o.',

  describe described_class::Normalizer do
    it 'converts a file into an array of strings, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_universe
    end
  end

  describe described_class::Universe do
    it 'can expand the universe so that blank rows and columns are twice as big' do
      expect(described_class.new(raw_universe).expanded_size).to eq [3_000_007, 2_000_008]
    end

    it 'extracts the position of each galaxy' do
      expect(described_class.new(raw_universe).galaxies).to match_array [
        [        0,         2],  # [ 0,  2],
        [        0, 2_000_007],  # [ 0, 11],
        [        1, 1_000_004],  # [ 1,  6],
        [1_000_002,         0],  # [ 4,  0],
        [1_000_003, 2_000_007],  # [ 5, 11],
        [2_000_004, 1_000_003],  # [ 8,  5],
        [2_000_005,         1],  # [ 9,  1],
        [2_000_005, 2_000_006],  # [ 9, 10],
        [3_000_006, 1_000_005]   # [12,  7]
      ]
    end

    it 'can extract the shortest path between a pair of galaxies' do
      expect(described_class.new(raw_universe).distance([1_000_002,         0], [2_000_005, 2_000_006])).to eq 3_000_009
      expect(described_class.new(raw_universe).distance([        0,         2], [3_000_006, 1_000_005])).to eq 4_000_009
      expect(described_class.new(raw_universe).distance([        0, 2_000_007], [1_000_002, 2_000_007])).to eq 1_000_002
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_universe).result).to eq 82000210
  end
end
