require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
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

    it 'exposes the correct potential new moves for single step movement' do
      map = [
        [1,2,3,4,5],
        [2,3,4,5,6],
        [3,4,5,6,7],
        [4,5,6,7,8],
        [5,6,7,8,9],
      ]

      path = described_class.new([0,0], 0, 0, nil, [])
      expect(path.move_options_single_step(map)).to match_array([
        described_class.new([1,0], 2, 1, :east, [[0,0]]),
        described_class.new([0,1], 2, 1, :south, [[0,0]]),
      ])

      path = described_class.new([0,0], 0, 1, :east, [])
      expect(path.move_options_single_step(map)).to match_array([
        described_class.new([1,0], 2, 2, :east, [[0,0]]),
        described_class.new([0,1], 2, 1, :south, [[0,0]]),
      ])

      path = described_class.new([0,0], 0, 2, :east, [])
      expect(path.move_options_single_step(map)).to match_array([
        described_class.new([1,0], 2, 3, :east, [[0,0]]),
        described_class.new([0,1], 2, 1, :south, [[0,0]]),
      ])

      path = described_class.new([0,0], 0, 3, :east, [])
      expect(path.move_options_single_step(map)).to match_array([
        described_class.new([0,1], 2, 1, :south, [[0,0]]),
      ])

      path = described_class.new([1,1], 0, 0, nil, [])
      expect(path.move_options_single_step(map)).to match_array([
        described_class.new([2,1], 4, 1, :east, [[1,1]]),
        described_class.new([1,2], 4, 1, :south, [[1,1]]),
        described_class.new([0,1], 2, 1, :west, [[1,1]]),
        described_class.new([1,0], 2, 1, :north, [[1,1]])
      ])
    end

    it 'exposes the correct potential new moves for multistep movement' do
      map = [
        [1,2,3,4,5],
        [2,3,4,5,6],
        [3,4,5,6,7],
        [4,5,6,7,8],
        [5,6,7,8,9],
      ]

      path = described_class.new([0,0], 0, 0, nil, [])
      expect(path.move_options_multi_step(map)).to match_array([
        described_class.new([1,0], 2, 1, :east, [[0,0]]),
        described_class.new([2,0], 5, 2, :east, [[0,0], [1,0]]),
        described_class.new([3,0], 9, 3, :east, [[0,0], [1,0], [2,0]]),
        described_class.new([0,1], 2, 1, :south, [[0,0]]),
        described_class.new([0,2], 5, 2, :south, [[0,0], [0,1]]),
        described_class.new([0,3], 9, 3, :south, [[0,0], [0,1], [0,2]]),
      ])

      path = described_class.new([0,0], 0, 0, :east, [])
      expect(path.move_options_multi_step(map)).to match_array([
        described_class.new([0,1], 2, 1, :south, [[0,0]]),
        described_class.new([0,2], 5, 2, :south, [[0,0], [0,1]]),
        described_class.new([0,3], 9, 3, :south, [[0,0], [0,1], [0,2]]),
      ])

      path = described_class.new([0,0], 0, 0, :south, [])
      expect(path.move_options_multi_step(map)).to match_array([
        described_class.new([1,0], 2, 1, :east, [[0,0]]),
        described_class.new([2,0], 5, 2, :east, [[0,0], [1,0]]),
        described_class.new([3,0], 9, 3, :east, [[0,0], [1,0], [2,0]]),
      ])

      path = described_class.new([1,1], 0, 0, nil, [])
      expect(path.move_options_multi_step(map)).to match_array([
        described_class.new([2,1],  4, 1, :east, [[1,1]]),
        described_class.new([3,1],  9, 2, :east, [[1,1], [2,1]]),
        described_class.new([4,1], 15, 3, :east, [[1,1], [2,1], [3,1]]),
        described_class.new([1,2],  4, 1, :south, [[1,1]]),
        described_class.new([1,3],  9, 2, :south, [[1,1], [1,2]]),
        described_class.new([1,4], 15, 3, :south, [[1,1], [1,2], [1,3]]),
        described_class.new([0,1],  2, 1, :west, [[1,1]]),
        described_class.new([1,0],  2, 1, :north, [[1,1]])
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
      map = [
        [1,2,3,4,5],
        [1,3,4,5,6],
        [1,4,5,6,7],
        [1,1,1,1,1],
        [1,6,7,1,1],
      ]

      expect(described_class.new(map).minimal_heatloss_route).to eq(
        Solution1::Path.new([4,4], 8, 1, :east, [
          [0,0],
          [0,1],
          [0,2],
          [0,3],
          [1,3],
          [2,3],
          [3,3],
          [3,4]
        ])
      )
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_heatloss_map).result).to eq 102
  end
end
