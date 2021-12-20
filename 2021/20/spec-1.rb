require File.join(__dir__, 'solution-1')

RSpec.describe Solution do
  let(:example_enhancement_algorithm) { '..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#' }

  let(:example_image) {
    [
      ['#', '.', '.', '#', '.'],
      ['#', '.', '.', '.', '.'],
      ['#', '#', '.', '.', '#'],
      ['.', '.', '#', '.', '.'],
      ['.', '.', '#', '#', '#'],
    ]
  }

  describe Solution::Normalizer do
    it 'extracts the enhancement algorithm as a string from the first line of the file' do
      expect(described_class.do_it(File.join(__dir__,'example.txt')).first).to eq example_enhancement_algorithm
    end

    it 'extracts the input image as an array of arrays of characters from the remaining lines of the file, skipping a blank line after the algorithm line' do
      expect(described_class.do_it(File.join(__dir__,'example.txt')).last).to eq example_image
    end
  end

  it 'generates the correct solution for the example' do
    csi = described_class.new(example_enhancement_algorithm, example_image)

    expect(csi.display(csi.enhance(1))).to eq <<~DISPLAY.chomp
      .##.##.
      #..#.#.
      ##.#..#
      ####..#
      .#..##.
      ..##..#
      ...#.#.
    DISPLAY
    expect(csi.display(csi.enhance(2))).to eq <<~DISPLAY.chomp
      .......#.
      .#..#.#..
      #.#...###
      #...##.#.
      #.....#.#
      .#.#####.
      ..#.#####
      ...##.##.
      ....###..
    DISPLAY
    expect(csi.result).to eq 35
  end
end
