require File.join(__dir__, 'solution-2')

RSpec.describe Solution2 do
  let(:raw_race) { [ 71530,   940200] }

  describe Solution2::Normalizer do
    it 'converts a file into a time & distance pair, removing all spaces from the strings' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_race
    end
  end

  describe Solution2::Race do
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

      expect(described_class.new(time: 71530, distance: 940200).record_breakers).to eq 71503
    end
  end

  it 'gives the correct solution for the example' do
    expect(described_class.new(raw_race).result).to eq 71503
  end
end
