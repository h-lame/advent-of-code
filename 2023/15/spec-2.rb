require File.join(__dir__, 'solution-2')

RSpec.describe Solution2 do
  let(:raw_initialisation_sequence) { [
    'rn=1',
    'cm-',
    'qp=3',
    'cm=2',
    'qp-',
    'pc=4',
    'ot=9',
    'ab=5',
    'pc-',
    'pc=6',
    'ot=7'
  ] }

  describe described_class::Normalizer do
    it 'converts a file into an array of strings, ignoring any newlines and separating by commas' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_initialisation_sequence
    end
  end

  describe described_class::Hash do
    it 'calculates the hash value according to the algorithm' do
      expect(described_class.calc('H')).to eq 200
      expect(described_class.calc('HA')).to eq 153
      expect(described_class.calc('HAS')).to eq 172
      expect(described_class.calc('HASH')).to eq 52

      expect(described_class.calc('rn=1')).to eq 30
      expect(described_class.calc('cm-')).to eq 253
      expect(described_class.calc('qp=3')).to eq 97
      expect(described_class.calc('cm=2')).to eq 47
      expect(described_class.calc('qp-')).to eq 14
      expect(described_class.calc('pc=4')).to eq 180
      expect(described_class.calc('ot=9')).to eq 9
      expect(described_class.calc('ab=5')).to eq 197
      expect(described_class.calc('pc-')).to eq 48
      expect(described_class.calc('pc=6')).to eq 214
      expect(described_class.calc('ot=7')).to eq 231
    end
  end

  describe described_class::HashMap do
    it 'calculates the focussing power correctly' do
      hash_map = described_class.new

      hash_map.setup_box 0, ['rn', 1], ['cm', 2]
      hash_map.setup_box 3, ['ot', 7], ['ab', 5], ['pc', 6]

      expect(hash_map.focusing_power 0).to eq 5
      expect(hash_map.focusing_power 1).to eq 0
      expect(hash_map.focusing_power 3).to eq 140
    end

    it 'removes a labeled lens from a box correctly - doing nothing if not present, shuffling everything up if it is' do
      hash_map = described_class.new

      hash_map.setup_box 0, ['rn', 1], ['cm', 2]
      hash_map.setup_box 3, ['cm', 7], ['ab', 5], ['pc', 6]

      hash_map.remove_from_box 0, 'ab'
      expect(hash_map.boxes[0]).to eq [['rn', 1], ['cm', 2]]
      expect(hash_map.boxes[3]).to eq [['cm', 7], ['ab', 5], ['pc', 6]]

      hash_map.remove_from_box 1, 'ab'
      expect(hash_map.boxes[0]).to eq [['rn', 1], ['cm', 2]]
      expect(hash_map.boxes[3]).to eq [['cm', 7], ['ab', 5], ['pc', 6]]

      hash_map.remove_from_box 3, 'ab'
      expect(hash_map.boxes[0]).to eq [['rn', 1], ['cm', 2]]
      expect(hash_map.boxes[3]).to eq [['cm', 7], ['pc', 6]]

      hash_map.remove_from_box 0, 'cm'
      expect(hash_map.boxes[0]).to eq [['rn', 1]]
      expect(hash_map.boxes[3]).to eq [['cm', 7], ['pc', 6]]

      hash_map.remove_from_box 3, 'cm'
      expect(hash_map.boxes[0]).to eq [['rn', 1]]
      expect(hash_map.boxes[3]).to eq [['pc', 6]]
    end

    it 'adds a labeled lens to a box correctly - adding to the end if the label is not present, updating the focal length if it is present' do
      hash_map = described_class.new
      hash_map.add_to_box 0, 'cm', 1
      expect(hash_map.boxes[0]).to eq [['cm', 1]]

      hash_map.add_to_box 0, 'cr', 1
      expect(hash_map.boxes[0]).to eq [['cm', 1], ['cr', 1]]

      hash_map.add_to_box 1, 'cr', 1
      expect(hash_map.boxes[0]).to eq [['cm', 1], ['cr', 1]]
      expect(hash_map.boxes[1]).to eq [['cr', 1]]

      hash_map.add_to_box 1, 'cr', 100
      expect(hash_map.boxes[0]).to eq [['cm', 1], ['cr', 1]]
      expect(hash_map.boxes[1]).to eq [['cr', 100]]

      hash_map.add_to_box 0, 'cm', 100
      expect(hash_map.boxes[0]).to eq [['cm', 100], ['cr', 1]]
      expect(hash_map.boxes[1]).to eq [['cr', 100]]
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_initialisation_sequence).result).to eq 145
  end
end
