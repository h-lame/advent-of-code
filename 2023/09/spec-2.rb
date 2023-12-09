require File.join(__dir__, 'solution-2')

RSpec.describe Solution2 do
  let(:raw_readings) { [
    [0, 3, 6, 9, 12, 15],
    [1, 3, 6, 10, 15, 21],
    [10, 13, 16, 21, 30, 45],
  ] }

  describe described_class::Normalizer do
    it 'converts a file into an array of arrays of numbers, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_readings
    end

    it 'converts a file into an array of arrays of numbers (including negatives), one per line' do
      expect(described_class.do_it File.join(__dir__,'example-with-negatives.txt')).to eq [[-6, -3, 8, 40]]
    end
  end

  describe described_class::History do
    it 'calculates the correct next value' do
      expect(described_class.new(raw_readings[0]).next_reading).to eq -3
      expect(described_class.new(raw_readings[1]).next_reading).to eq 0
      expect(described_class.new(raw_readings[2]).next_reading).to eq 5
    end

    it 'calculates the next rows' do
      expect(described_class.new(raw_readings[0]).extrapolate_rows).to eq [
        [3, 3, 3, 3, 3, 3, 3],
        [0, 0, 0, 0, 0, 0],
      ]
      expect(described_class.new(raw_readings[1]).extrapolate_rows).to eq [
        [1, 2, 3, 4, 5, 6, 7],
        [1, 1, 1, 1, 1, 1],
        [0, 0, 0, 0, 0],
      ]
      expect(described_class.new(raw_readings[2]).extrapolate_rows).to eq [
        [5, 3, 3, 5, 9, 15, 23],
        [-2, 0, 2, 4, 6, 8],
        [2, 2, 2, 2, 2],
        [0, 0, 0, 0],
      ]
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_readings).result).to eq 2
  end
end
