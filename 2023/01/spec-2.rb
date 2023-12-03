require File.join(__dir__, 'solution-2')

RSpec.describe Solution2 do
  let(:raw_calibrations) { %w[two1nine eightwothree abcone2threexyz xtwone3four 4nineeightseven2 zoneight234 7pqrstsixteen] }
  let(:prepared_calibrations) { [29, 83, 13, 24, 42, 14, 76] }

  describe Solution2::Normalizer do
    it 'converts a file into an array of strings' do
      expect(described_class.do_it File.join(__dir__,'example-2.txt')).to eq raw_calibrations
    end
  end

  it 'converts calibrations to numbers by taking the first and last digits (including written versions of numbers) to create a 2 digit number' do
    expect(described_class.new(raw_calibrations).prepared_calibrations).to eq prepared_calibrations
  end

  it 'converts overlapping calibrations correctly' do
    expect(described_class.new(['oneight', 'twone', 'sevenine', 'threeight', 'fiveight']).prepared_calibrations).to eq [18, 21, 79, 38, 58]
  end

  it 'gives the correct solution for the example' do
    expect(described_class.new(raw_calibrations).result).to eq 281
  end
end
