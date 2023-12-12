require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
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
  let(:expanded_universe) { [
    '....#........',
    '.........#...',
    '#............',
    '.............',
    '.............',
    '........#....',
    '.#...........',
    '............#',
    '.............',
    '.............',
    '.........#...',
    '#....#.......',
  ]}

  describe described_class::Normalizer do
    it 'converts a file into an array of strings, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_universe
    end
  end

  describe described_class::Universe do
    it 'can expand the universe so that blank rows and columns are twice as big' do
      expect(described_class.new(raw_universe).expanded).to eq expanded_universe
    end

    it 'extracts the position of each galaxy' do
      expect(described_class.new(raw_universe).galaxies).to match_array [
        [ 0,  2],
        [ 0, 11],
        [ 1,  6],
        [ 4,  0],
        [ 5, 11],
        [ 8,  5],
        [ 9,  1],
        [ 9, 10],
        [12,  7]
      ]
    end

    it 'can extract the shortest path between a pair of galaxies' do
      expect(described_class.new(raw_universe).distance([4,  0], [ 9, 10])).to eq 15
      expect(described_class.new(raw_universe).distance([0,  2], [12,  7])).to eq 17
      expect(described_class.new(raw_universe).distance([0, 11], [ 5, 11])).to eq 5
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_universe).result).to eq 374
  end
end
