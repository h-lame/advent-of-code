require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
  let(:raw_platform) { [
    'O....#....', #10
    'O.OO#....#', # 9
    '.....##...', # 8
    'OO.#O....O', # 7
    '.O.....O#.', # 6
    'O.#..O.#.#', # 5
    '..O..#O..O', # 4
    '.......O..', # 3
    '#....###..', # 2
    '#OO..#....', # 1
  ] }

  describe described_class::Normalizer do
    it 'converts a file into an array of strings, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_platform
    end
  end

  describe described_class::Platform do
    it 'can tilt the platform north such that all rocks slide north, unless blocked by a cube or rock' do
      platform = described_class.new(raw_platform)
      platform.tilt(:north)
      expect(platform.render).to eq [
        'OOOO.#.O..', #10
        'OO..#....#', # 9
        'OO..O##..O', # 8
        'O..#.OO...', # 7
        '........#.', # 6
        '..#....#.#', # 5
        '..O..#.O.O', # 4
        '..O.......', # 3
        '#....###..', # 2
        '#....#....', # 1
      ]
    end

    it 'can calculate the load for the northern supports' do
      platform = described_class.new(raw_platform)
      expect(platform.load(:north)).to eq ((10*1) + (9*3) + (8*0) + (7*4) + (6*2) + (5*2) + (4*3) + (3*1) + (2*0) + (1*2))
      platform.tilt(:north)
      expect(platform.load(:north)).to eq ((10*5) + (9*2) + (8*4) + (7*3) + (6*0) + (5*0) + (4*3) + (3*1) + (2*0) + (1*0))
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_platform).result).to eq 136
  end
end
