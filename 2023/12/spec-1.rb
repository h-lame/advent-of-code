require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
  let(:raw_condition_report) { [
    ['???.###', [1,1,3]],
    ['.??..??...?##.', [1,1,3]],
    ['?#?#?#?#?#?#?#?', [1,3,1,6]],
    ['????.#...#...', [4,1,1]],
    ['????.######..#####.', [1,6,5]],
    ['?###????????', [3,2,1]],
  ] }

  describe described_class::Normalizer do
    it 'converts a file into an array of strings + array of number pairs, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_condition_report
    end
  end

  describe described_class::CogReport do
    it 'can calculate the number of arrangements of cogs to match the report + counts' do
      expect(described_class.from_raw(raw_condition_report[0]).arrangements.size).to eq 1

      expect(described_class.from_raw(raw_condition_report[1]).arrangements.size).to eq 4
      expect(described_class.from_raw(raw_condition_report[2]).arrangements.size).to eq 1
      expect(described_class.from_raw(raw_condition_report[3]).arrangements.size).to eq 1
      expect(described_class.from_raw(raw_condition_report[4]).arrangements.size).to eq 4
      expect(described_class.from_raw(raw_condition_report[5]).arrangements.size).to eq 10
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_condition_report).result).to eq 21
  end
end
