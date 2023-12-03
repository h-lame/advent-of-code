require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
  let(:raw_calibrations) { %w[1abc2 pqr3stu8vwx a1b2c3d4e5f treb7uchet] }
  let(:prepared_calibrations) { [12, 38, 15, 77] }

  describe Solution1::Normalizer do
    it 'converts a file into an array of strings' do
      expect(described_class.do_it File.join(__dir__,'example-1.txt')).to eq raw_calibrations
    end
  end

  it 'converts calibrations to numbers by taking the first and last digits to create a 2 digit number' do
    expect(described_class.new(raw_calibrations).prepared_calibrations).to eq prepared_calibrations
  end

  it 'gives the correct solution for the example' do
    expect(described_class.new(raw_calibrations).result).to eq 142
  end
end
