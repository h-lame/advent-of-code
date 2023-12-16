require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
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

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_initialisation_sequence).result).to eq 1320
  end
end
