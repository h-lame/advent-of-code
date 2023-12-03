require File.join(__dir__, 'solution-2')

RSpec.describe Solution do
  let(:raw_schematic) { [
    '467..114..',
    '...*......',
    '..35..633.',
    '......#...',
    '617*......',
    '.....+.58.',
    '..592.....',
    '......755.',
    '...$.*....',
    '.664.598..',
  ] }

  describe Solution::Normalizer do
    it 'converts a file into an array of strings, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_schematic
    end
  end

  it 'extracts symbol positions from the schematic' do
    expect(described_class.new(raw_schematic).symbols).to eq [
      ['*', [3, 1]],
      ['#', [6, 3]],
      ['*', [3, 4]],
      ['+', [5, 5]],
      ['$', [3, 8]],
      ['*', [5, 8]],
    ]
  end

  it 'extracts number positions from the schematic' do
    expect(described_class.new(raw_schematic).numbers).to eq [
      ['467', [0, 0], [2, 0]],
      ['114', [5, 0], [7, 0]],
      ['35', [2, 2], [3, 2]],
      ['633', [6, 2], [8, 2]],
      ['617', [0, 4], [2, 4]],
      ['58', [7, 5], [8, 5]],
      ['592', [2, 6], [4, 6]],
      ['755', [6, 7], [8, 7]],
      ['664', [1, 9], [3, 9]],
      ['598', [5, 9], [7, 9]],
    ]
  end

  it 'does not extract a part if there is no symbol' do
    expect(
      described_class.new([
        '...',
        '.1.',
        '...'
      ]).parts
    ).to eq []
  end

  it 'extracts a part if there is a symbol adjecent to it' do
    part = ['1', [1,1], [1,1]]
    expect(
      described_class.new([
        '...',
        '.1.',
        '..*'
      ]).parts
    ).to eq [part]
    expect(
      described_class.new([
        '...',
        '.1.',
        '.*.'
      ]).parts
    ).to eq [part]
    expect(
      described_class.new([
        '...',
        '.1.',
        '*..'
      ]).parts
    ).to eq [part]
    expect(
      described_class.new([
        '...',
        '*1.',
        '...'
      ]).parts
    ).to eq [part]
    expect(
      described_class.new([
        '...',
        '.1*',
        '...'
      ]).parts
    ).to eq [part]
    expect(
      described_class.new([
        '..*',
        '.1.',
        '...'
      ]).parts
    ).to eq [part]
    expect(
      described_class.new([
        '.*.',
        '.1.',
        '...'
      ]).parts
    ).to eq [part]
    expect(
      described_class.new([
        '*..',
        '.1.',
        '...'
      ]).parts
    ).to eq [part]
  end

  it 'extracts a gear if it is a * symbol adjacent to two numbers' do
    expect(
      described_class.new([
        '.....',
        '.3*2.',
        '.....'
      ]).gears
    ).to match_array [match_array(['3', '2'])]
    expect(
      described_class.new([
        '..*..',
        '.3.2.',
        '.....'
      ]).gears
    ).to match_array [match_array(['3', '2'])]
    expect(
      described_class.new([
        '.....',
        '.3.2.',
        '..*..'
      ]).gears
    ).to match_array [match_array(['3', '2'])]
    expect(
      described_class.new([
        '...',
        '.3.',
        '..*',
        '.2.',
        '...',
      ]).gears
    ).to match_array [match_array(['3', '2'])]
    expect(
      described_class.new([
        '...',
        '.3.',
        '.*.',
        '.2.',
        '...',
      ]).gears
    ).to match_array [match_array(['3', '2'])]
    expect(
      described_class.new([
        '...',
        '.3.',
        '*..',
        '.2.',
        '...',
      ]).gears
    ).to match_array [match_array(['3', '2'])]
    expect(
      described_class.new([
        '.....',
        '.3...',
        '..*..',
        '...2.',
        '.....',
      ]).gears
    ).to match_array [match_array(['3', '2'])]
    expect(
      described_class.new([
        '.....',
        '...2.',
        '..*..',
        '.3...',
        '.....',
      ]).gears
    ).to match_array [match_array(['3', '2'])]
  end

  it 'does not extract a gear if it is a * symbol not adjacent to two numbers' do
    expect(
      described_class.new([
        '.....',
        '.3.2.',
        '*....'
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '.....',
        '*3.2.',
        '.....'
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '*....',
        '.3.2.',
        '.....'
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '.*...',
        '.3.2.',
        '.....'
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '...*.',
        '.3.2.',
        '.....'
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '....*',
        '.3.2.',
        '.....'
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '.....',
        '.3.2*',
        '.....'
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '.....',
        '.3.2.',
        '....*'
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '.....',
        '.3.2.',
        '...*.'
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '*..',
        '.3.',
        '...',
        '.2.',
        '...',
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '.*.',
        '.3.',
        '...',
        '.2.',
        '...',
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '..*',
        '.3.',
        '...',
        '.2.',
        '...',
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '...',
        '*3.',
        '...',
        '.2.',
        '...',
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '...',
        '.3*',
        '...',
        '.2.',
        '...',
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '...',
        '.3.',
        '...',
        '*2.',
        '...',
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '...',
        '.3.',
        '...',
        '.2*',
        '...',
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '...',
        '.3.',
        '...',
        '.2.',
        '*..',
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '...',
        '.3.',
        '...',
        '.2.',
        '.*.',
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '...',
        '.3.',
        '...',
        '.2.',
        '..*',
      ]).gears
    ).to eq []
  end

  it 'does not extract a gear if it is any other symbol adjacent to two numbers' do
    expect(
      described_class.new([
        '.....',
        '.3%2.',
        '.....'
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '.....',
        '.3+2.',
        '.....'
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '.....',
        '.3@2.',
        '.....'
      ]).gears
    ).to eq []
    expect(
      described_class.new([
        '.....',
        '.3?2.',
        '.....'
      ]).gears
    ).to eq []
  end

  it 'gives the correct solution for the example' do
    expect(described_class.new(raw_schematic).result).to eq 467835
  end
end
