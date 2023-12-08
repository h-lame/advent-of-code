require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
  let(:raw_map_1) { [
    'RL',
    {
      'AAA' => ['BBB', 'CCC'],
      'BBB' => ['DDD', 'EEE'],
      'CCC' => ['ZZZ', 'GGG'],
      'DDD' => ['DDD', 'DDD'],
      'EEE' => ['EEE', 'EEE'],
      'GGG' => ['GGG', 'GGG'],
      'ZZZ' => ['ZZZ', 'ZZZ'],
    },
  ] }

  let(:raw_map_2) { [
    'LLR',
    {
      'AAA' => ['BBB', 'BBB'],
      'BBB' => ['AAA', 'ZZZ'],
      'ZZZ' => ['ZZZ', 'ZZZ'],
    },
  ] }

  describe described_class::Normalizer do
    it 'converts a file into an array with a single string, and then a hash of string to 2 string pairs, one per line' do
      expect(described_class.do_it File.join(__dir__,'example-1.txt')).to eq raw_map_1
      expect(described_class.do_it File.join(__dir__,'example-2.txt')).to eq raw_map_2
    end
  end

  describe described_class::Map do
    it 'knows the current position, and tracks it after making moves' do
      map = described_class.from_raw(raw_map_1)
      expect(map.position).to eq 'AAA'
      map.move('L')
      expect(map.position).to eq 'BBB'
      map.move('R')
      expect(map.position).to eq 'EEE'
      map.move('R')
      expect(map.position).to eq 'EEE'
      map.move('L')
      expect(map.position).to eq 'EEE'
    end

    it 'knows how many steps it has taken' do
      map = described_class.from_raw(raw_map_1)
      expect(map.position).to eq 'AAA'
      map.move('L')
      map.move('R')
      map.move('R')
      map.move('R')
      map.move('L')
      expect(map.step_count).to eq 5
    end

    it 'knows if it is stuck' do
      map = described_class.from_raw(raw_map_1)
      expect(map.position).to eq 'AAA'
      map.move('L')
      expect(map).not_to be_stuck
      map.move('R')
      expect(map).to be_stuck
    end

    it 'knows the choices available at each move' do
      map = described_class.from_raw(raw_map_1)
      expect(map.position).to eq 'AAA'
      expect(map.choices).to eq ['BBB', 'CCC']
      map.move('L')
      expect(map.choices).to eq ['DDD', 'EEE']
      map.move('R')
      expect(map.choices).to eq ['EEE', 'EEE']
    end

    it 'can autowalk to the solution' do
      map = described_class.from_raw(raw_map_1)
      map.autowalk
      expect(map.position).to eq 'ZZZ'
      expect(map.step_count).to eq 2
    end

    it 'will repeat instructions until it hits the end while autowalking' do
      map = described_class.from_raw(raw_map_2)
      map.autowalk
      expect(map.position).to eq 'ZZZ'
      expect(map.step_count).to eq 6
    end

    it 'will raise if autowalking gets stuck' do
      map = described_class.from_raw(raw_map_1)
      expect { map.autowalk 'LRRLR' }.to raise_error Solution1::StuckError
      expect(map.position).to eq 'EEE'
      expect(map.step_count).to eq 2
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_map_1).result).to eq 2
    expect(described_class.new(raw_map_2).result).to eq 6
  end
end
