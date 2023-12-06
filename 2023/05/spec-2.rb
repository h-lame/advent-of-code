require File.join(__dir__, 'solution-2')

RSpec.describe Solution2 do
  let(:raw_almanac) { [
    'seeds: 79 14 55 13',
    'seed-to-soil map:',
    '50 98 2',
    '52 50 48',
    'soil-to-fertilizer map:',
    '0 15 37',
    '37 52 2',
    '39 0 15',
    'fertilizer-to-water map:',
    '49 53 8',
    '0 11 42',
    '42 0 7',
    '57 7 4',
    'water-to-light map:',
    '88 18 7',
    '18 25 70',
    'light-to-temperature map:',
    '45 77 23',
    '81 45 19',
    '68 64 13',
    'temperature-to-humidity map:',
    '0 69 1',
    '1 0 69',
    'humidity-to-location map:',
    '60 56 37',
    '56 93 4'
  ] }

  describe Solution2::Normalizer do
    it 'converts a file into an array of strings, one per line, omitting blank lines' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_almanac
    end
  end

  describe Solution2::Map do
    it 'extracts a list of seeds' do
      expect(described_class.generate_from(raw_almanac).seeds).to eq [(79..92), (55..67)]
    end

    it 'extracts maps for soil, fertilizer, water, light, temperature, humidity, location' do
      expect(described_class.generate_from(raw_almanac).maps.keys).to eq ['soil', 'fertilizer', 'water', 'light', 'temperature', 'humidity', 'location']
    end

    it 'generates the correct paths for each seed' do
      map = described_class.generate_from(raw_almanac)
      expect(map.path_to('location', seed: 79)).to eq(soil: 81, fertilizer: 81, water: 81, light: 74, temperature: 78, humidity: 78, location: 82)
      expect(map.path_to('location', seed: 14)).to eq(soil: 14, fertilizer: 53, water: 49, light: 42, temperature: 42, humidity: 43, location: 43)
      expect(map.path_to('location', seed: 55)).to eq(soil: 57, fertilizer: 57, water: 53, light: 46, temperature: 82, humidity: 82, location: 86)
      expect(map.path_to('location', seed: 13)).to eq(soil: 13, fertilizer: 52, water: 41, light: 34, temperature: 34, humidity: 35, location: 35)
    end

    it 'generates the correct location for each seed' do
      map = described_class.generate_from(raw_almanac)
      expect(map.location_for(79)).to eq 82
      expect(map.location_for(14)).to eq 43
      expect(map.location_for(55)).to eq 86
      expect(map.location_for(13)).to eq 35
    end

    it 'splits_ranges correctly, combining the modifiers' do
      expect(described_class.split_ranges([1..1, 1], [1..1, 2])).to eq [[1..1, 3]]
      expect(described_class.split_ranges([1..4, 1], [1..4, 2])).to eq [[1..4, 3]]

      expect(described_class.split_ranges([1..4, 1], [1..1, 2])).to eq [[1..1, 3], [2..4, 1]]
      expect(described_class.split_ranges([1..4, 1], [1..2, 2])).to eq [[1..2, 3], [3..4, 1]]
      expect(described_class.split_ranges([1..4, 1], [2..2, 2])).to eq [[1..1, 1], [2..2, 3], [3..4, 1]]
      expect(described_class.split_ranges([1..4, 1], [2..3, 2])).to eq [[1..1, 1], [2..3, 3], [4..4, 1]]
      expect(described_class.split_ranges([1..4, 1], [2..4, 2])).to eq [[1..1, 1], [2..4, 3]]
      expect(described_class.split_ranges([1..4, 1], [4..4, 2])).to eq [[1..3, 1], [4..4, 3]]
      expect(described_class.split_ranges([1..4, 1], [2..5, 2])).to eq [[1..1, 1], [2..4, 3], [5..5, 2]]
      expect(described_class.split_ranges([1..4, 1], [2..6, 2])).to eq [[1..1, 1], [2..4, 3], [5..6, 2]]
      expect(described_class.split_ranges([1..4, 1], [3..4, 2])).to eq [[1..2, 1], [3..4, 3]]
      expect(described_class.split_ranges([1..4, 1], [3..5, 2])).to eq [[1..2, 1], [3..4, 3], [5..5, 2]]
      expect(described_class.split_ranges([1..4, 1], [3..6, 2])).to eq [[1..2, 1], [3..4, 3], [5..6, 2]]

      expect(described_class.split_ranges([1..1, 1], [1..4, 2])).to eq [[1..1, 3], [2..4, 2]]
      expect(described_class.split_ranges([1..2, 1], [1..4, 2])).to eq [[1..2, 3], [3..4, 2]]
      expect(described_class.split_ranges([2..2, 1], [1..4, 2])).to eq [[1..1, 2], [2..2, 3], [3..4, 2]]
      expect(described_class.split_ranges([2..3, 1], [1..4, 2])).to eq [[1..1, 2], [2..3, 3], [4..4, 2]]
      expect(described_class.split_ranges([2..4, 1], [1..4, 2])).to eq [[1..1, 2], [2..4, 3]]
      expect(described_class.split_ranges([4..4, 1], [1..4, 2])).to eq [[1..3, 2], [4..4, 3]]
      expect(described_class.split_ranges([2..5, 1], [1..4, 2])).to eq [[1..1, 2], [2..4, 3], [5..5, 1]]
      expect(described_class.split_ranges([2..6, 1], [1..4, 2])).to eq [[1..1, 2], [2..4, 3], [5..6, 1]]
      expect(described_class.split_ranges([3..4, 1], [1..4, 2])).to eq [[1..2, 2], [3..4, 3]]
      expect(described_class.split_ranges([3..5, 1], [1..4, 2])).to eq [[1..2, 2], [3..4, 3], [5..5, 1]]
      expect(described_class.split_ranges([3..6, 1], [1..4, 2])).to eq [[1..2, 2], [3..4, 3], [5..6, 1]]

      expect(described_class.split_ranges([1..1, 1], [2..2, 2])).to eq [[1..1, 1], [2..2, 2]]
    end

    it 'splits ranges and combines maps' do
      almanac = [
        'seeds: 79 14 55 13',
        'seed-to-soil map:',
        '50 98 2',
        '52 50 48',
        'soil-to-fertilizer map:',
        '0 15 37',
        '37 52 2',
        '39 0 15',
      ]

      map = described_class.generate_from(almanac)
      expect(map.ranges).to eq(
        [
          [( 0..14), 39],
          [(15..49), -15],
          [(50..51), -13],
          [(52..53), -13],
          [(54..97), 2],
          [(98..99), -48],
        ]
      )
    end
  end

  it 'gives the correct solution for the example' do
    expect(described_class.new(raw_almanac).result).to eq 46
  end
end
