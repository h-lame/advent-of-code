require File.join(__dir__, 'solution-2')

RSpec.describe Solution2 do
  let(:raw_condition_report) { [
    ['???.###', [1,1,3]],
    ['.??..??...?##.', [1,1,3]],
    ['?#?#?#?#?#?#?#?', [1,3,1,6]],
    ['????.#...#...', [4,1,1]],
    ['????.######..#####.', [1,6,5]],
    ['?###????????', [3,2,1]],
  ] }
  let(:unfolded_condition_report) { [
    ['???.###????.###????.###????.###????.###', [1,1,3]*5],
    ['.??..??...?##.?.??..??...?##.?.??..??...?##.?.??..??...?##.?.??..??...?##.', [1,1,3]*5],
    ['?#?#?#?#?#?#?#???#?#?#?#?#?#?#???#?#?#?#?#?#?#???#?#?#?#?#?#?#???#?#?#?#?#?#?#?', [1,3,1,6]*5],
    ['????.#...#...?????.#...#...?????.#...#...?????.#...#...?????.#...#...', [4,1,1]*5],
    ['????.######..#####.?????.######..#####.?????.######..#####.?????.######..#####.?????.######..#####.', [1,6,5]*5],
    ['?###??????????###??????????###??????????###??????????###????????', [3,2,1]*5],
  ] }

  describe described_class::Normalizer do
    it 'converts a file into an array of strings + array of number pairs, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_condition_report
    end
  end

  describe described_class::CogReport do
    it 'unfolds the condition reports' do
      expect(described_class.from_raw(raw_condition_report[0]).map).to eq unfolded_condition_report[0].first
      expect(described_class.from_raw(raw_condition_report[0]).group_counts).to eq unfolded_condition_report[0].last

      expect(described_class.from_raw(raw_condition_report[1]).map).to eq unfolded_condition_report[1].first
      expect(described_class.from_raw(raw_condition_report[1]).group_counts).to eq unfolded_condition_report[1].last

      expect(described_class.from_raw(raw_condition_report[2]).map).to eq unfolded_condition_report[2].first
      expect(described_class.from_raw(raw_condition_report[2]).group_counts).to eq unfolded_condition_report[2].last

      expect(described_class.from_raw(raw_condition_report[3]).map).to eq unfolded_condition_report[3].first
      expect(described_class.from_raw(raw_condition_report[3]).group_counts).to eq unfolded_condition_report[3].last

      expect(described_class.from_raw(raw_condition_report[4]).map).to eq unfolded_condition_report[4].first
      expect(described_class.from_raw(raw_condition_report[4]).group_counts).to eq unfolded_condition_report[4].last

      expect(described_class.from_raw(raw_condition_report[5]).map).to eq unfolded_condition_report[5].first
      expect(described_class.from_raw(raw_condition_report[5]).group_counts).to eq unfolded_condition_report[5].last
    end

    it 'can calculate the number of arrangements of cogs to match the report + counts' do
      expect(described_class.from_raw(raw_condition_report[0]).arrangements).to eq 1

      expect(described_class.from_raw(raw_condition_report[1]).arrangements).to eq 16384
      expect(described_class.from_raw(raw_condition_report[2]).arrangements).to eq 1
      expect(described_class.from_raw(raw_condition_report[3]).arrangements).to eq 16
      expect(described_class.from_raw(raw_condition_report[4]).arrangements).to eq 2500
      expect(described_class.from_raw(raw_condition_report[5]).arrangements).to eq 506250
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_condition_report).result).to eq 525152
  end
end
