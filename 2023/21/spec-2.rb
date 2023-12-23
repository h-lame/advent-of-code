require File.join(__dir__, 'solution-2-wip')

RSpec.describe Solution2 do
  let(:raw_garden) { [
    '...........',
    '.....###.#.',
    '.###.##..#.',
    '..#.#...#..',
    '....#.#....',
    '.##..S####.',
    '.##..#...#.',
    '.......##..',
    '.##.#.####.',
    '.##..##.##.',
    '...........',
  ] }
  let(:all_plots ) {
    all_points = []
    raw_garden.each.with_index do |row, y|
      row.size.times do |x|
        all_points << [x,y] if row[x] == '.'
      end
    end
    all_points
  }

  describe described_class::Normalizer do
    it 'converts a file into an array of strings, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_garden
    end
  end

  describe described_class::GardenPlot do
    it 'is odd if the step count is odd' do
      expect(described_class.new(x: 0, y: 0, step_count: 1)).to be_odd
      expect(described_class.new(x: 0, y: 0, step_count: 1)).not_to be_even

      expect(described_class.new(x: 0, y: 0, step_count: 2)).not_to be_odd
      expect(described_class.new(x: 0, y: 0, step_count: 2)).to be_even
    end

    it 'is the same as another garden plot if the x + y co-ords match, even if the step count does not' do
      odd_origin = described_class.new(x: 0, y: 0, step_count: 1)
      even_origin = described_class.new(x: 0, y: 0, step_count: 2)
      other_plot = described_class.new(x: 1, y: 0, step_count: 2)

      expect(odd_origin).to eq(even_origin)
      expect(odd_origin).not_to eq(other_plot)
    end

    it 'is the same as a x,y positional array if the co-ords match' do
      expect(described_class.new(x: 0, y: 0, step_count: 1)).to eq([0,0])
      expect(described_class.new(x: 0, y: 0, step_count: 1)).not_to eq([1,0])
      expect(described_class.new(x: 0, y: 0, step_count: 1)).not_to eq([0,1])
      expect(described_class.new(x: 0, y: 0, step_count: 1)).not_to eq([0,1,0])
    end

    it 'can expose itself as a positional array via #pos' do
      expect(described_class.new(x: 0, y: 0, step_count: 1).pos).to eq([0,0])
      expect(described_class.new(x: 0, y: 0, step_count: 5).pos).to eq([0,0])
      expect(described_class.new(x: 1, y: 0, step_count: 1).pos).to eq([1,0])
      expect(described_class.new(x: 0, y: 1, step_count: 1).pos).to eq([0,1])
    end
  end

  describe described_class::FiniteGarden do
    it 'knows the starting point' do
      garden = described_class.new(garden: raw_garden)

      expect(garden.paths.to_a).to eq [Solution2::GardenPlot.new(x: 5, y: 5, step_count: -1)]
    end

    it 'collects the minimum paths needed to walk to each point, grouping by odd and even' do
      garden = described_class.new(garden: raw_garden)

      garden.step_to_all

      expect(garden.paths.to_a.map &:pos).to match_array(all_plots)

      expect(garden.odd_paths.to_a.map &:pos).to match_array([
        [0, 1], [0, 3], [0, 5], [0, 7], [0, 9],
        [1, 0], [1, 4], [1, 10],
        [2, 1], [2, 7],
        [3, 0], [3, 4], [3, 6], [3, 8], [3, 10],
        [4, 1], [4, 5], [4, 7], [4, 9],
        [5, 0], [5, 4], [5, 8], [5, 10],
        [6, 3], [6, 7],
        [7, 0], [7, 2], [7, 4], [7, 6], [7, 10],
        [8, 1],
        [9, 0], [9, 4], [9, 10],
        [10, 1], [10, 3], [10, 5], [10, 7], [10, 9],
      ])
      expect(garden.even_paths.to_a.map &:pos).to match_array([
        [0, 0], [0, 2], [0, 4], [0, 6], [0, 8], [0, 10],
        [1, 1], [1, 3], [1, 7],
        [2, 0], [2, 4], [2, 10],
        [3, 1], [3, 3], [3, 5], [3, 7], [3, 9],
        [4, 0], [4, 2], [4, 6], [4, 10],
        [5, 3], [5, 5], [5, 7],
        [6, 0], [6, 6], [6, 10],
        [7, 3], [7, 9],
        [8, 0], [8, 2], [8, 4], [8, 6], [8, 10],
        [9, 3], [9, 7],
        [10, 0], [10, 2], [10, 4], [10, 6], [10, 8], [10, 10]
      ])
      expect((garden.odd_paths + garden.even_paths).to_a.map &:pos).to match_array(all_plots)
    end

    it 'renders the steps' do
      garden = described_class.new(garden: raw_garden)

      expect(garden.render).to eq(
        <<~GARDEN.chomp
          ...........
          .....###.#.
          .###.##..#.
          ..#.#...#..
          ....#.#....
          .##..O####.
          .##..#...#.
          .......##..
          .##.#.####.
          .##..##.##.
          ...........
        GARDEN
      )
      expect(garden.plots_reachable).to eq 1
      expect(garden.step_count).to eq 0

      garden.step
      expect(garden.plots_reachable).to eq 2
      expect(garden.step_count).to eq 1
      expect(garden.render).to eq(
        <<~GARDEN.chomp
          ...........
          .....###.#.
          .###.##..#.
          ..#.#...#..
          ....#O#....
          .##.O.####.
          .##..#...#.
          .......##..
          .##.#.####.
          .##..##.##.
          ...........
        GARDEN
      )
      expect(garden.plots_reachable).to eq 2
      expect(garden.step_count).to eq 1

      garden.step
      expect(garden.render).to eq(
        <<~GARDEN.chomp
          ...........
          .....###.#.
          .###.##..#.
          ..#.#O..#..
          ....#.#....
          .##O.O####.
          .##.O#...#.
          .......##..
          .##.#.####.
          .##..##.##.
          ...........
        GARDEN
      )
      expect(garden.plots_reachable).to eq 4
      expect(garden.step_count).to eq 2

      garden.step
      expect(garden.render).to eq(
        <<~GARDEN.chomp
          ...........
          .....###.#.
          .###.##..#.
          ..#.#.O.#..
          ...O#O#....
          .##.O.####.
          .##O.#...#.
          ....O..##..
          .##.#.####.
          .##..##.##.
          ...........
        GARDEN
      )
      expect(garden.plots_reachable).to eq 6
      expect(garden.step_count).to eq 3

      3.times { garden.step }
      expect(garden.render).to eq(
        <<~GARDEN.chomp
          ...........
          .....###.#.
          .###.##.O#.
          .O#O#O.O#..
          O.O.#.#.O..
          .##O.O####.
          .##.O#O..#.
          .O.O.O.##..
          .##.#.####.
          .##O.##.##.
          ...........
        GARDEN
      )
      expect(garden.plots_reachable).to eq 16
      expect(garden.step_count).to eq 6
    end
  end

  describe described_class::InfiniteGarden do
    it 'expands using the finite garden and calculates steps properly' do
      garden = described_class.new(raw_garden)

      expect(garden.plots_reachable_in(6)).to eq(16)
      expect(garden.plots_reachable_in(10)).to eq(50)
      expect(garden.plots_reachable_in(50)).to eq(1594)
      expect(garden.plots_reachable_in(100)).to eq(6536)
      expect(garden.plots_reachable_in(500)).to eq(167004)
      expect(garden.plots_reachable_in(1000)).to eq(668697)
      expect(garden.plots_reachable_in(5000)).to eq(16733044)
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_garden).result(6)).to eq 16
  end
end
