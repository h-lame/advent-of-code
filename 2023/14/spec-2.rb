require File.join(__dir__, 'solution-2')

RSpec.describe Solution2 do
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
    it 'can tilt the platform in each direction such that all rocks slide in that, unless blocked by a cube or rock' do
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
      platform.tilt(:west)
      expect(platform.render).to eq [
        'OOOO.#O...', #10
        'OO..#....#', # 9
        'OOO..##O..', # 8
        'O..#OO....', # 7
        '........#.', # 6
        '..#....#.#', # 5
        'O....#OO..', # 4
        'O.........', # 3
        '#....###..', # 2
        '#....#....', # 1
      ]
      platform.tilt(:south)
      expect(platform.render).to eq [
        '.....#....', #10
        '....#.O..#', # 9
        'O..O.##...', # 8
        'O.O#......', # 7
        'O.O....O#.', # 6
        'O.#..O.#.#', # 5
        'O....#....', # 4
        'OO....OO..', # 3
        '#O...###..', # 2
        '#O..O#....', # 1
      ]
      platform.tilt(:east)
      expect(platform.render).to eq [
        '.....#....', #10
        '....#...O#', # 9
        '...OO##...', # 8
        '.OO#......', # 7
        '.....OOO#.', # 6
        '.O#...O#.#', # 5
        '....O#....', # 4
        '......OOOO', # 3
        '#...O###..', # 2
        '#..OO#....', # 1
      ]
    end

    it 'can spin the platform so as if you have tilted north, west, south, then east' do
      platform = described_class.new(raw_platform)
      platform.spin
      expect(platform.render).to eq [
        '.....#....', #10
        '....#...O#', # 9
        '...OO##...', # 8
        '.OO#......', # 7
        '.....OOO#.', # 6
        '.O#...O#.#', # 5
        '....O#....', # 4
        '......OOOO', # 3
        '#...O###..', # 2
        '#..OO#....', # 1
      ]
      platform.spin
      expect(platform.render).to eq [
        '.....#....', #10
        '....#...O#', # 9
        '.....##...', # 8
        '..O#......', # 7
        '.....OOO#.', # 6
        '.O#...O#.#', # 5
        '....O#...O', # 4
        '.......OOO', # 3
        '#..OO###..', # 2
        '#.OOO#...O', # 1
      ]
      platform.spin
      expect(platform.render).to eq [
        '.....#....', #10
        '....#...O#', # 9
        '.....##...', # 8
        '..O#......', # 7
        '.....OOO#.', # 6
        '.O#...O#.#', # 5
        '....O#...O', # 4
        '.......OOO', # 3
        '#...O###.O', # 2
        '#.OOO#...O', # 1
      ]
    end

    it 'loops after x spins' do
      loop_platform = described_class.new(raw_platform)
      loop_platform.spin 3

      iter_platform = described_class.new(raw_platform)
      iter_platform.spin 10
      expect(iter_platform.render).to eq loop_platform.render

      iter2_platform = described_class.new(raw_platform)
      iter2_platform.spin 20
      expect(iter_platform.render).to eq loop_platform.render
    end

    it 'can calculate the load for the northern supports' do
      platform = described_class.new(raw_platform)
      expect(platform.load(:north)).to eq ((10*1) + (9*3) + (8*0) + (7*4) + (6*2) + (5*2) + (4*3) + (3*1) + (2*0) + (1*2))
      platform.tilt(:north)
      expect(platform.load(:north)).to eq ((10*5) + (9*2) + (8*4) + (7*3) + (6*0) + (5*0) + (4*3) + (3*1) + (2*0) + (1*0))
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_platform).result).to eq 64
  end
end
