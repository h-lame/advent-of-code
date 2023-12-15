require File.join(__dir__, 'solution-2')

RSpec.describe Solution2 do
  let(:raw_patterns) { [
    [
      '#.##..##.',
      '..#.##.#.',
      '##......#',
      '##......#',
      '..#.##.#.',
      '..##..##.',
      '#.#.##.#.',
    ], [
      '#...##..#',
      '#....#..#',
      '..##..###',
      '#####.##.',
      '#####.##.',
      '..##..###',
      '#....#..#',
    ]
  ] }

  describe described_class::Normalizer do
    it 'converts a file into an array of arrays of strings, one per line, the 2nd-level arrays are formed by blank lines' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_patterns
    end
  end

  describe described_class::Pattern do
    it 'can explain the reflection vertical or horizonal' do
      expect(described_class.from_raw(raw_patterns[0]).reflection).to eq [:vertical, 5]
      expect(described_class.from_raw(raw_patterns[1]).reflection).to eq [:horizontal, 4]
    end

    it 'can detect the reflection after correcting the smudge' do
      expect(described_class.from_raw(raw_patterns[0]).smudge_reflection).to eq [:horizontal, 3]
      expect(described_class.from_raw(raw_patterns[1]).smudge_reflection).to eq [:horizontal, 1]
    end

    it 'can calculate the score for a pattern - lines before a vertial reflection or 100 * lines before a horizontal reflection' do
      expect(described_class.from_raw(raw_patterns[0]).score).to eq 300
      expect(described_class.from_raw(raw_patterns[1]).score).to eq 100
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_patterns).result).to eq 400
  end
end
