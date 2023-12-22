require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
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

  describe described_class::Normalizer do
    it 'converts a file into an array of strings, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_garden
    end
  end

  describe described_class::Garden do
    it 'knows the starting point' do
      garden = described_class.new(garden: raw_garden)

      expect(garden.paths.to_a).to eq [[5, 5]]
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

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_garden).result(6)).to eq 16
  end
end
