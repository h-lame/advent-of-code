require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
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

  describe Solution1::Normalizer do
    it 'converts a file into an array of strings, one per line, omitting blank lines' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_almanac
    end
  end

  describe Solution1::Map do
    it 'extracts a list of seeds' do
      expect(described_class.generate_from(raw_almanac).seeds).to eq [79, 14, 55, 13]
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
  end

  it 'gives the correct solution for the example' do
    expect(described_class.new(raw_almanac).result).to eq 35
  end
end
