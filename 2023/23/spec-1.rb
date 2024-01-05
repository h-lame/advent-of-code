require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
  let(:raw_trail_map) { [
    '#.#####################',
    '#.......#########...###',
    '#######.#########.#.###',
    '###.....#.>.>.###.#.###',
    '###v#####.#v#.###.#.###',
    '###.>...#.#.#.....#...#',
    '###v###.#.#.#########.#',
    '###...#.#.#.......#...#',
    '#####.#.#.#######.#.###',
    '#.....#.#.#.......#...#',
    '#.#####.#.#.#########v#',
    '#.#...#...#...###...>.#',
    '#.#.#v#######v###.###v#',
    '#...#.>.#...>.>.#.###.#',
    '#####v#.#.###v#.#.###.#',
    '#.....#...#...#.#.#...#',
    '#.#########.###.#.#.###',
    '#...###...#...#...#.###',
    '###.###.#.###v#####v###',
    '#...#...#.#.>.>.#.>.###',
    '#.###.###.#.###.#.#v###',
    '#.....###...###...#...#',
    '#####################.#',
  ] }

  describe described_class::Normalizer do
    it 'converts a file into an array of strings, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_trail_map
    end
  end

  describe described_class::TrailMap do
    it 'knows the start point' do
      trail_map = described_class.new(trail_map: raw_trail_map)

      expect(trail_map.start_point).to eq [1,0]
    end

    it 'knows the finish point' do
      trail_map = described_class.new(trail_map: raw_trail_map)

      expect(trail_map.finish_point).to eq [21,22]
    end

    it 'walks as far as it can in a single step' do
      trail_map = described_class.new(trail_map: raw_trail_map)

      expect(trail_map.render).to eq(
        <<~TRAILMAP.chomp
          #S#####################
          #.......#########...###
          #######.#########.#.###
          ###.....#.>.>.###.#.###
          ###v#####.#v#.###.#.###
          ###.>...#.#.#.....#...#
          ###v###.#.#.#########.#
          ###...#.#.#.......#...#
          #####.#.#.#######.#.###
          #.....#.#.#.......#...#
          #.#####.#.#.#########v#
          #.#...#...#...###...>.#
          #.#.#v#######v###.###v#
          #...#.>.#...>.>.#.###.#
          #####v#.#.###v#.#.###.#
          #.....#...#...#.#.#...#
          #.#########.###.#.#.###
          #...###...#...#...#.###
          ###.###.#.###v#####v###
          #...#...#.#.>.>.#.>.###
          #.###.###.#.###.#.#v###
          #.....###...###...#...#
          #####################.#
        TRAILMAP
      )

      trail_map.step
      expect(trail_map.render).to eq(
        <<~TRAILMAP.chomp
          #S#####################
          #OOOOOOO#########...###
          #######O#########.#.###
          ###OOOOO#.>.>.###.#.###
          ###O#####.#v#.###.#.###
          ###O?...#.#.#.....#...#
          ###?###.#.#.#########.#
          ###...#.#.#.......#...#
          #####.#.#.#######.#.###
          #.....#.#.#.......#...#
          #.#####.#.#.#########v#
          #.#...#...#...###...>.#
          #.#.#v#######v###.###v#
          #...#.>.#...>.>.#.###.#
          #####v#.#.###v#.#.###.#
          #.....#...#...#.#.#...#
          #.#########.###.#.#.###
          #...###...#...#...#.###
          ###.###.#.###v#####v###
          #...#...#.#.>.>.#.>.###
          #.###.###.#.###.#.#v###
          #.....###...###...#...#
          #####################.#
        TRAILMAP
      )
    end

    it 'generates the correct longest hike' do
      trail_map = described_class.new(trail_map: raw_trail_map)

      lh = trail_map.longest_hike
      expect(trail_map.render(lh)).to eq(
        <<~TRAILMAP.chomp
          #S#####################
          #OOOOOOO#########...###
          #######O#########.#.###
          ###OOOOO#OOO>.###.#.###
          ###O#####O#O#.###.#.###
          ###OOOOO#O#O#.....#...#
          ###v###O#O#O#########.#
          ###...#O#O#OOOOOOO#...#
          #####.#O#O#######O#.###
          #.....#O#O#OOOOOOO#...#
          #.#####O#O#O#########v#
          #.#...#OOO#OOO###OOOOO#
          #.#.#v#######O###O###O#
          #...#.>.#...>OOO#O###O#
          #####v#.#.###v#O#O###O#
          #.....#...#...#O#O#OOO#
          #.#########.###O#O#O###
          #...###...#...#OOO#O###
          ###.###.#.###v#####O###
          #...#...#.#.>.>.#.>O###
          #.###.###.#.###.#.#O###
          #.....###...###...#OOO#
          #####################?#
        TRAILMAP
      )
    end

  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_trail_map).result).to eq 94
  end
end
