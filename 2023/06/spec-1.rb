require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
  let(:raw_races) { [
    [ 7,   9],
    [15,  40],
    [30, 200],
  ] }
  # The first race lasts 7 milliseconds. The record distance in this race is 9 millimeters.
  # The second race lasts 15 milliseconds. The record distance in this race is 40 millimeters.
  # The third race lasts 30 milliseconds. The record distance in this race is 200 millimeters.

  describe Solution1::Normalizer do
    it 'converts a file into an array of time & distance pairs, one per column' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_races
    end
  end

  describe Solution1::Race do
    it 'extracts the possible combinations of hold + travel times' do
      expect(described_class.new(time: 7, distance: 9).strategies).to eq [
        [0,  0],
        [1,  6],
        [2, 10],
        [3, 12],
        [4, 12],
        [5, 10],
        [6,  6],
        [7,  0]
      ]
    end

    it 'knows how many strategies beat the record' do
      expect(described_class.new(time: 7, distance: 9).record_breakers).to eq 4
      expect(described_class.new(time: 7, distance: 9).record_breaking_strategies).to eq [
        [2, 10],
        [3, 12],
        [4, 12],
        [5, 10],
      ]

      expect(described_class.new(time: 15, distance: 40).record_breakers).to eq 8
      expect(described_class.new(time: 15, distance: 40).record_breaking_strategies.first).to eq [4, 44]
      expect(described_class.new(time: 15, distance: 40).record_breaking_strategies.last).to eq [11, 44]
      expect(described_class.new(time: 30, distance: 200).record_breakers).to eq 9
      expect(described_class.new(time: 30, distance: 200).record_breaking_strategies.first).to eq [11, 209]
      expect(described_class.new(time: 30, distance: 200).record_breaking_strategies.last).to eq [19, 209]
    end
  end

  it 'gives the correct solution for the example' do
    expect(described_class.new(raw_races).result).to eq 288
  end
end
