require File.join(__dir__, 'solution-2')

RSpec.describe Solution2 do
  let(:raw_trail_map) { [
    #00000000001111111111222
    #01234567890123456789012
    '#.#####################', # 00
    '#.......#########...###', # 01
    '#######.#########.#.###', # 02
    '###.....#.>.>.###.#.###', # 03
    '###v#####.#v#.###.#.###', # 04
    '###.>...#.#.#.....#...#', # 05
    '###v###.#.#.#########.#', # 06
    '###...#.#.#.......#...#', # 07
    '#####.#.#.#######.#.###', # 08
    '#.....#.#.#.......#...#', # 09
    '#.#####.#.#.#########v#', # 10
    '#.#...#...#...###...>.#', # 11
    '#.#.#v#######v###.###v#', # 12
    '#...#.>.#...>.>.#.###.#', # 13
    '#####v#.#.###v#.#.###.#', # 14
    '#.....#...#...#.#.#...#', # 15
    '#.#########.###.#.#.###', # 16
    '#...###...#...#...#.###', # 17
    '###.###.#.###v#####v###', # 18
    '#...#...#.#.>.>.#.>.###', # 19
    '#.###.###.#.###.#.#v###', # 20
    '#.....###...###...#...#', # 21
    '#####################.#', # 22
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
          #OOOOOOO#########OOO###
          #######O#########O#O###
          ###OOOOO#.>OOO###O#O###
          ###O#####.#O#O###O#O###
          ###O>...#.#O#OOOOO#OOO#
          ###O###.#.#O#########O#
          ###OOO#.#.#OOOOOOO#OOO#
          #####O#.#.#######O#O###
          #OOOOO#.#.#OOOOOOO#OOO#
          #O#####.#.#O#########O#
          #O#OOO#...#OOO###...>O#
          #O#O#O#######O###.###O#
          #OOO#O>.#...>O>.#.###O#
          #####O#.#.###O#.#.###O#
          #OOOOO#...#OOO#.#.#OOO#
          #O#########O###.#.#O###
          #OOO###OOO#OOO#...#O###
          ###O###O#O###O#####O###
          #OOO#OOO#O#OOO>.#.>O###
          #O###O###O#O###.#.#O###
          #OOOOO###OOO###...#OOO#
          #####################O#
        TRAILMAP
      )
    end

    it 'can extract all the junctions from the trail map, including the start point' do
      trail_map = described_class.new(trail_map: raw_trail_map)

      expect(trail_map.junctions.keys).to match_array([
        [ 1, 0],
        [ 3, 5],
        [ 5,13],
        [11, 3],
        [13,13],
        [13,19],
        [19,19],
        [21,11],
      ])
    end

    it 'knows the possible path segments from each junction in the trail map (although it excludes options other than the goal for the final junction)' do
      trail_map = described_class.new(trail_map: raw_trail_map)

      expect(trail_map.junctions.values.map { |ps| ps.map &:start_point }.flatten(1)).to match_array([
        [1,0],
        [3,4], [3,6], [4,5],
        [5,12], [5,14], [6,13],
        [10,3], [12,3], [11,4],
        [12,13], [14,13], [13,12], [13,14],
        [12,19], [14,19], [13,18],
        [19,20],
        [20,11], [21,10], [21,12],
      ])
      expect(trail_map.junctions.values.map { |ps| ps.map &:path_head }.flatten(1)).to match_array([
        [3,5],
        [1,0], [5,13], [11,3],
        [3,5], [13,19], [13,13],
        [3,5], [21,11], [13,13],
        [5,13], [21,11], [11,3], [13,19],
        [5,13], [19,19], [13,13],
        [21,22],
        [13,13], [11,3], [19,19],
      ])
      expect(trail_map.junctions.values.map { |ps| ps.map &:step_count }.flatten(1)).to match_array([
        15,
        15, 22, 22,
        22, 38, 12,
        22, 30, 24,
        12, 18, 24, 10,
        38, 10, 10,
        5,
        18, 30, 10,
      ])
    end

    it 'can construct a graph of all the path segments' do
      trail_map = described_class.new(trail_map: raw_trail_map)

      expect(pointify_graph(trail_map.graph)).to eq(
        [0, [1,0], [
          [15, [3,5], [
            [15+22, [11,3], [
              [15+22+30, [21,11], [
                [15+22+30+10, [19,19], [
                  [15+22+30+10+5, [21,22], :goal]
                ]],
                [15+22+30+18, [13,13], [
                  [15+22+30+18+10, [13,19], [
                    [15+22+30+18+10+10, [19,19], [
                      [15+22+30+18+10+10+5, [21,22], :goal]
                    ]],
                    [15+22+30+18+10+38, [5,13], :dead_end],
                  ]],
                  [15+22+30+18+12, [5, 13], [
                    [15+22+30+18+12+38, [13,19], [
                      [15+22+30+18+12+38+10, [19,19], [
                        [15+22+30+18+12+38+10+5, [21,22], :goal]
                      ]]
                    ]]
                  ]],
                ]],
              ]],
              [15+22+24,[13,13], [
                [15+22+24+18, [21,11], [
                  [15+22+24+18+10, [19,19], [
                    [15+22+24+18+10+5, [21,22], :goal]
                  ]]
                ]],
                [15+22+24+10, [13,19], [
                  [15+22+24+10+10, [19,19], [
                    [15+22+24+10+10+5, [21,22], :goal]
                  ]],
                  [15+22+24+10+38, [5,13], :dead_end],
                ]],
                [15+22+24+12, [5,13], [
                  [15+22+24+12+38, [13,19], [
                    [15+22+24+12+38+10, [19,19], [
                      [15+22+24+12+38+10+5, [21,22], :goal]
                    ]]
                  ]]
                ]]
              ]]
            ]],
            [15+22, [5,13], [
              [15+22+12, [13,13], [
                [15+22+12+24, [11,3], [
                  [15+22+12+24+30, [21,11], [
                    [15+22+12+24+30+10, [19,19], [
                      [15+22+12+24+30+10+5, [21,22], :goal]
                    ]]
                  ]]
                ]],
                [15+22+12+18, [21,11], [
                  [15+22+12+18+30, [11,3], :dead_end],
                  [15+22+12+18+10, [19,19], [
                    [15+22+12+18+10+5, [21,22], :goal]
                  ]]
                ]],
                [15+22+12+10, [13,19], [
                  [15+22+12+10+10, [19,19], [
                    [15+22+12+10+10+5, [21,22], :goal]
                  ]]
                ]],
              ]],
              [15+22+38, [13,19], [
                [15+22+38+10, [13,13], [
                  [15+22+38+10+24, [11,3], [
                    [15+22+38+10+24+30, [21,11], [
                      [15+22+38+10+24+30+10, [19,19], [
                        [15+22+38+10+24+30+10+5, [21,22], :goal]
                      ]]
                    ]]
                  ]],
                  [15+22+38+10+18, [21,11], [
                    [15+22+38+10+18+30, [11,3], :dead_end],
                    [15+22+38+10+18+10, [19,19], [
                      [15+22+38+10+18+10+5, [21,22], :goal]
                    ]]
                  ]],
                ]],
                [15+22+38+10, [19,19], [
                  [15+22+38+10+5, [21,22], :goal]
                ]],
              ]],
            ]],
          ]]
        ]]
      )
    end
  end

  def pointify_graph(g)
    cost, path, choices = *g
    [
      cost,
      path.currently_at,
      if [:goal, :dead_end].include? choices
        choices
      else
        choices.map { |c| pointify_graph(c) }
      end
    ]
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_trail_map).result).to eq 154
  end
end
