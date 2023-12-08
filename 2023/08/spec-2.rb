require File.join(__dir__, 'solution-2')

RSpec.describe Solution2 do
  let(:raw_ghost_map) { [
    'LR',
    {
      '11A' => ['11B', 'XXX'],
      '11B' => ['XXX', '11Z'],
      '11Z' => ['11B', 'XXX'],
      '22A' => ['22B', 'XXX'],
      '22B' => ['22C', '22C'],
      '22C' => ['22Z', '22Z'],
      '22Z' => ['22B', '22B'],
      'XXX' => ['XXX', 'XXX'],
    }
  ] }

  describe described_class::Normalizer do
    it 'converts a file into an array with a single string, and then a hash of string to 2 string pairs, one per line' do
      expect(described_class.do_it File.join(__dir__,'example-3.txt')).to eq raw_ghost_map
    end
  end

  describe described_class::MultiMap do
    it 'knows the current positions, and tracks it after making moves' do
      map = described_class.from_raw(raw_ghost_map)
      expect(map.positions).to eq ['11A', '22A']
      map.move('L')
      expect(map.positions).to eq ['11B', '22B']
      map.move('R')
      expect(map.positions).to eq ['11Z', '22C']
      map.move('R')
      expect(map.positions).to eq ['XXX', '22Z']
      map.move('L')
      expect(map.positions).to eq ['XXX', '22B']
    end

    it 'knows how many steps it has taken' do
      map = described_class.from_raw(raw_ghost_map)
      expect(map.positions).to eq ['11A', '22A']
      map.move('L')
      map.move('R')
      map.move('R')
      map.move('R')
      map.move('L')
      expect(map.step_count).to eq 5
    end

    it 'knows if it is stuck (e.g. any position is in a place where both L and R lead back to where we are)' do
      map = described_class.from_raw(raw_ghost_map)
      expect(map.positions).to eq ['11A', '22A']
      map.move('L')
      expect(map).not_to be_stuck
      map.move('R')
      expect(map).not_to be_stuck
      map.move('R')
      expect(map).to be_stuck
    end

    it 'knows the choices available at each move' do
      map = described_class.from_raw(raw_ghost_map)
      expect(map.positions).to eq ['11A', '22A']
      expect(map.choices).to eq({ '11A' => ['11B', 'XXX'], '22A' => ['22B', 'XXX'] })
      map.move('L')
      expect(map.choices).to eq({ '11B' => ['XXX', '11Z'], '22B' => ['22C', '22C'] })
      map.move('R')
      expect(map.choices).to eq({ '11Z' => ['11B', 'XXX'], '22C' => ['22Z', '22Z'] })
    end

    it 'can autowalk to the solution' do
      map = described_class.from_raw(raw_ghost_map)
      map.autowalk
      expect(map.positions).to eq ['11Z', '22Z']
      expect(map.step_count).to eq 6
    end

    it 'will raise if autowalking gets stuck' do
      map = described_class.from_raw(raw_ghost_map)
      expect { map.autowalk 'RRRR' }.to raise_error Solution2::StuckError
      expect(map.positions).to eq ['XXX', 'XXX']
      expect(map.step_count).to eq 1

      map = described_class.from_raw(raw_ghost_map)
      expect { map.autowalk 'LRRRR' }.to raise_error Solution2::StuckError
      expect(map.positions).to eq ['XXX', '22Z']
      expect(map.step_count).to eq 3
    end
  end

  describe described_class::Map do
    it 'knows the current position, and tracks it after making moves' do
      map = described_class.from_raw(raw_ghost_map, '11A')
      expect(map.position).to eq '11A'
      map.move('L')
      expect(map.position).to eq '11B'
      map.move('R')
      expect(map.position).to eq '11Z'
      map.move('R')
      expect(map.position).to eq 'XXX'
      map.move('L')
      expect(map.position).to eq 'XXX'

      map = described_class.from_raw(raw_ghost_map, '22A')
      expect(map.position).to eq '22A'
      map.move('L')
      expect(map.position).to eq '22B'
      map.move('R')
      expect(map.position).to eq '22C'
      map.move('R')
      expect(map.position).to eq '22Z'
      map.move('L')
      expect(map.position).to eq '22B'
    end

    it 'knows how many steps it has taken' do
      map = described_class.from_raw(raw_ghost_map, '11A')
      expect(map.position).to eq '11A'
      map.move('L')
      map.move('R')
      map.move('R')
      map.move('R')
      map.move('L')
      expect(map.step_count).to eq 5
    end

    it 'knows if it is stuck' do
      map = described_class.from_raw(raw_ghost_map, '11A')
      expect(map.position).to eq '11A'
      map.move('L')
      expect(map).not_to be_stuck
      map.move('R')
      expect(map).not_to be_stuck
      map.move('R')
      expect(map).to be_stuck
    end

    it 'knows the choices available at each move' do
      map = described_class.from_raw(raw_ghost_map, '11A')
      expect(map.position).to eq '11A'

      expect(map.choices).to eq ['11B', 'XXX']
      map.move('L')
      expect(map.choices).to eq ['XXX', '11Z']
      map.move('R')
      expect(map.choices).to eq ['11B', 'XXX']
    end

    it 'can autowalk to the solution' do
      map = described_class.from_raw(raw_ghost_map, '11A')
      map.autowalk
      expect(map.position).to eq '11Z'
      expect(map.step_count).to eq 2
    end

    it 'will repeat instructions until it hits the end while autowalking' do
      map = described_class.from_raw(raw_ghost_map, '22A')
      map.autowalk
      expect(map.position).to eq '22Z'
      expect(map.step_count).to eq 3
    end

    it 'will raise if autowalking gets stuck' do
      map = described_class.from_raw(raw_ghost_map, '11A')
      expect { map.autowalk 'LLRRLRRRRRRRRR' }.to raise_error Solution2::StuckError
      expect(map.position).to eq 'XXX'
      expect(map.step_count).to eq 2
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_ghost_map).result).to eq 6
  end
end
