require File.join(__dir__, 'solution-2')

RSpec.describe Solution2 do
  let(:raw_heatloss_map) { [
    [2, 4, 1, 3, 4, 3, 2, 3, 1, 1, 3, 2, 3],
    [3, 2, 1, 5, 4, 5, 3, 5, 3, 5, 6, 2, 3],
    [3, 2, 5, 5, 2, 4, 5, 6, 5, 4, 2, 5, 4],
    [3, 4, 4, 6, 5, 8, 5, 8, 4, 5, 4, 5, 2],
    [4, 5, 4, 6, 6, 5, 7, 8, 6, 7, 5, 3, 6],
    [1, 4, 3, 8, 5, 9, 8, 7, 9, 8, 4, 5, 4],
    [4, 4, 5, 7, 8, 7, 6, 9, 8, 7, 7, 6, 6],
    [3, 6, 3, 7, 8, 7, 7, 9, 7, 9, 6, 5, 3],
    [4, 6, 5, 4, 9, 6, 7, 9, 8, 6, 8, 8, 7],
    [4, 5, 6, 4, 6, 7, 9, 9, 8, 6, 4, 5, 3],
    [1, 2, 2, 4, 6, 8, 6, 8, 6, 5, 5, 6, 3],
    [2, 5, 4, 6, 5, 4, 8, 8, 8, 7, 7, 3, 5],
    [4, 3, 2, 2, 6, 7, 4, 6, 5, 5, 5, 3, 3],
  ] }

  let(:raw_heatloss_map_2) { [
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 1],
    [9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 1],
    [9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 1],
    [9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 1],
  ] }

  describe described_class::Normalizer do
    it 'converts a file into an array of arrays of numbers, one array per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_heatloss_map
    end
  end

  describe described_class::Path do
    it 'sorts properly against other paths with least heatloss first' do
      paths = [
        described_class.new([0,0], 10, 1, :east, []),
        described_class.new([0,0], 1, 1, :east, []),
        described_class.new([0,0], 4, 1, :east, []),
        described_class.new([0,0], 3, 1, :east, []),
      ]

      expect(paths.sort).to eq([
        described_class.new([0,0], 1, 1, :east, []),
        described_class.new([0,0], 3, 1, :east, []),
        described_class.new([0,0], 4, 1, :east, []),
        described_class.new([0,0], 10, 1, :east, []),
      ])
    end

    it 'sorts properly against other paths with the same heatloss, such that shortest steps are first' do
      paths = [
        described_class.new([0,0], 10, 1, :east, []),
        described_class.new([0,0], 10, 3, :east, []),
        described_class.new([0,0], 10, 2, :east, []),
      ]

      expect(paths.sort).to eq([
        described_class.new([0,0], 10, 1, :east, []),
        described_class.new([0,0], 10, 2, :east, []),
        described_class.new([0,0], 10, 3, :east, []),
      ])
    end

    it 'sorts properly against other paths with the same heatloss + steps, such that shortest route is first' do
      paths = [
        described_class.new([0,0], 10, 1, :east, [[1,1],[1,2],[1,3]]),
        described_class.new([0,0], 10, 1, :east, [[1,1]]),
        described_class.new([0,0], 10, 1, :east, [[1,1],[1,2]]),
      ]

      expect(paths.sort).to eq([
        described_class.new([0,0], 10, 1, :east, [[1,1]]),
        described_class.new([0,0], 10, 1, :east, [[1,1],[1,2]]),
        described_class.new([0,0], 10, 1, :east, [[1,1],[1,2],[1,3]]),
      ])
    end

    it 'exposes the correct potential new moves for multi step movement' do
      map = [
        [1,2,3,4,5,6,7,8,9,0,1,2,3],
        [2,3,4,5,6,7,8,9,0,1,2,3,4],
        [3,4,5,6,7,8,9,0,1,2,3,4,5],
        [4,5,6,7,8,9,0,1,2,3,4,5,6],
        [5,6,7,8,9,0,1,2,3,4,5,6,7],
        [6,7,8,9,0,1,2,3,4,5,6,7,8],
        [7,8,9,0,1,2,3,4,5,6,7,8,9],
        [8,9,0,1,2,3,4,5,6,7,8,9,0],
        [9,0,1,2,3,4,5,6,7,8,9,0,1],
        [0,1,2,3,4,5,6,7,8,9,0,1,2],
        [1,2,3,4,5,6,7,8,9,0,1,2,3],
        [2,3,4,5,6,7,8,9,0,1,2,3,4],
        [3,4,5,6,7,8,9,0,1,2,3,4,5],
      ]

      path = described_class.new([0,0], 0, 0, nil, [])
      expect(path.move_options_multi_step(map)).to match_array([
        described_class.new([ 4, 0], 14,  4, :east,  [[0,0], [1,0], [2,0], [3,0]]),
        described_class.new([ 5, 0], 20,  5, :east,  [[0,0], [1,0], [2,0], [3,0], [4,0]]),
        described_class.new([ 6, 0], 27,  6, :east,  [[0,0], [1,0], [2,0], [3,0], [4,0], [5,0]]),
        described_class.new([ 7, 0], 35,  7, :east,  [[0,0], [1,0], [2,0], [3,0], [4,0], [5,0], [6,0]]),
        described_class.new([ 8, 0], 44,  8, :east,  [[0,0], [1,0], [2,0], [3,0], [4,0], [5,0], [6,0], [7,0]]),
        described_class.new([ 9, 0], 44,  9, :east,  [[0,0], [1,0], [2,0], [3,0], [4,0], [5,0], [6,0], [7,0], [8,0]]),
        described_class.new([10, 0], 45, 10, :east,  [[0,0], [1,0], [2,0], [3,0], [4,0], [5,0], [6,0], [7,0], [8,0], [9,0]]),
        described_class.new([ 0, 4], 14,  4, :south, [[0,0], [0,1], [0,2], [0,3]]),
        described_class.new([ 0, 5], 20,  5, :south, [[0,0], [0,1], [0,2], [0,3], [0,4]]),
        described_class.new([ 0, 6], 27,  6, :south, [[0,0], [0,1], [0,2], [0,3], [0,4], [0,5]]),
        described_class.new([ 0, 7], 35,  7, :south, [[0,0], [0,1], [0,2], [0,3], [0,4], [0,5], [0,6]]),
        described_class.new([ 0, 8], 44,  8, :south, [[0,0], [0,1], [0,2], [0,3], [0,4], [0,5], [0,6], [0,7]]),
        described_class.new([ 0, 9], 44,  9, :south, [[0,0], [0,1], [0,2], [0,3], [0,4], [0,5], [0,6], [0,7], [0,8]]),
        described_class.new([ 0,10], 45, 10, :south, [[0,0], [0,1], [0,2], [0,3], [0,4], [0,5], [0,6], [0,7], [0,8], [0,9]]),
      ])

      path = described_class.new([0,0], 0, 0, :east, [])
      expect(path.move_options_multi_step(map)).to match_array([
        described_class.new([ 0, 4], 14,  4, :south, [[0,0], [0,1], [0,2], [0,3]]),
        described_class.new([ 0, 5], 20,  5, :south, [[0,0], [0,1], [0,2], [0,3], [0,4]]),
        described_class.new([ 0, 6], 27,  6, :south, [[0,0], [0,1], [0,2], [0,3], [0,4], [0,5]]),
        described_class.new([ 0, 7], 35,  7, :south, [[0,0], [0,1], [0,2], [0,3], [0,4], [0,5], [0,6]]),
        described_class.new([ 0, 8], 44,  8, :south, [[0,0], [0,1], [0,2], [0,3], [0,4], [0,5], [0,6], [0,7]]),
        described_class.new([ 0, 9], 44,  9, :south, [[0,0], [0,1], [0,2], [0,3], [0,4], [0,5], [0,6], [0,7], [0,8]]),
        described_class.new([ 0,10], 45, 10, :south, [[0,0], [0,1], [0,2], [0,3], [0,4], [0,5], [0,6], [0,7], [0,8], [0,9]]),
      ])

      path = described_class.new([0,0], 0, 0, :south, [])
      expect(path.move_options_multi_step(map)).to match_array([
        described_class.new([ 4, 0], 14,  4, :east,  [[0,0], [1,0], [2,0], [3,0]]),
        described_class.new([ 5, 0], 20,  5, :east,  [[0,0], [1,0], [2,0], [3,0], [4,0]]),
        described_class.new([ 6, 0], 27,  6, :east,  [[0,0], [1,0], [2,0], [3,0], [4,0], [5,0]]),
        described_class.new([ 7, 0], 35,  7, :east,  [[0,0], [1,0], [2,0], [3,0], [4,0], [5,0], [6,0]]),
        described_class.new([ 8, 0], 44,  8, :east,  [[0,0], [1,0], [2,0], [3,0], [4,0], [5,0], [6,0], [7,0]]),
        described_class.new([ 9, 0], 44,  9, :east,  [[0,0], [1,0], [2,0], [3,0], [4,0], [5,0], [6,0], [7,0], [8,0]]),
        described_class.new([10, 0], 45, 10, :east,  [[0,0], [1,0], [2,0], [3,0], [4,0], [5,0], [6,0], [7,0], [8,0], [9,0]]),
      ])

      path = described_class.new([5,5], 0, 0, nil, [])
      expect(path.move_options_multi_step(map)).to match_array([
        described_class.new([ 9,  5], 14,  4, :east,  [[5,5], [6,5], [7,5], [8,5]]),
        described_class.new([10,  5], 20,  5, :east,  [[5,5], [6,5], [7,5], [8,5], [9,5]]),
        described_class.new([11,  5], 27,  6, :east,  [[5,5], [6,5], [7,5], [8,5], [9,5], [10,5]]),
        described_class.new([12,  5], 35,  7, :east,  [[5,5], [6,5], [7,5], [8,5], [9,5], [10,5], [11,5]]),
        described_class.new([ 5,  9], 14,  4, :south, [[5,5], [5,6], [5,7], [5,8]]),
        described_class.new([ 5, 10], 20,  5, :south, [[5,5], [5,6], [5,7], [5,8], [5,9]]),
        described_class.new([ 5, 11], 27,  6, :south, [[5,5], [5,6], [5,7], [5,8], [5,9], [5,10]]),
        described_class.new([ 5, 12], 35,  7, :south, [[5,5], [5,6], [5,7], [5,8], [5,9], [5,10], [5,11]]),
        described_class.new([ 1,  5], 24,  4, :west,  [[5,5], [4,5], [3,5], [2,5]]),
        described_class.new([ 0,  5], 30,  5, :west,  [[5,5], [4,5], [3,5], [2,5], [1,5]]),
        described_class.new([ 5,  1], 24,  4, :north, [[5,5], [5,4], [5,3], [5,2]]),
        described_class.new([ 5,  0], 30,  5, :north, [[5,5], [5,4], [5,3], [5,2], [5,1]]),
      ])
    end

    it 'can render the route' do
      map = [
        [1,2,3,4,5],
        [2,3,4,5,6],
        [3,4,5,6,7],
        [4,5,6,7,8],
        [5,6,7,8,9],
      ]
      path = described_class.new([1,2], 0, 0, nil, [[0,0], [0,1], [1,1]])
      expect(path.render_route(map)).to eq(
        <<~RENDER.chomp
        x2345
        xx456
        3*567
        45678
        56789
        RENDER
      )
    end
  end

  describe described_class::HeatlossMap do
    it 'can find the route with the minimal heatloss' do
      expect(described_class.new(raw_heatloss_map_2).minimal_heatloss_route).to eq(
        Solution2::Path.new([11,4], 71, 4, :east, [
          [ 0, 0],
          [ 1, 0],
          [ 2, 0],
          [ 3, 0],
          [ 4, 0],
          [ 5, 0],
          [ 6, 0],
          [ 7, 0],
          [ 7, 1],
          [ 7, 2],
          [ 7, 3],
          [ 7, 4],
          [ 8, 4],
          [ 9, 4],
          [10, 4]
        ])
      )
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_heatloss_map).result).to eq 94
    expect(described_class.new(raw_heatloss_map_2).result).to eq 71
  end
end
