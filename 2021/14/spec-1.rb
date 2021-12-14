require File.join(__dir__, 'solution-1')

RSpec.describe Solution do
  let(:example_polymer) { 'NNCB' }
  let(:example_pair_insertions) {
    [
      ['CH', 'B'],
      ['HH', 'N'],
      ['CB', 'H'],
      ['NH', 'C'],
      ['HB', 'C'],
      ['HC', 'B'],
      ['HN', 'C'],
      ['NN', 'C'],
      ['BH', 'H'],
      ['NC', 'B'],
      ['NB', 'B'],
      ['BN', 'B'],
      ['BB', 'N'],
      ['BC', 'B'],
      ['CC', 'N'],
      ['CN', 'C'],
    ]
  }

  describe Solution::Normalizer do
    subject(:normalizer) { described_class.do_it(File.join(__dir__,'example.txt')) }

    it 'extracts the polymer as a string from the first line of the file' do
      expect(normalizer.first).to eq example_polymer
    end

    it 'extracts the pair insertions as an array of pairs of strings, one per line of the file after the blank line' do
      expect(normalizer.last).to eq example_pair_insertions
    end
  end

  it 'generates the correct polymers after the first four steps' do
    polymerisation_machine = described_class.new(example_polymer, example_pair_insertions)

    expect(polymerisation_machine.polymer_after(0)).to eq 'NNCB'
    expect(polymerisation_machine.polymer_after(1)).to eq 'NCNBCHB'
    expect(polymerisation_machine.polymer_after(2)).to eq 'NBCCNBBBCBHCB'
    expect(polymerisation_machine.polymer_after(3)).to eq 'NBBBCNCCNBBNBNBBCHBHHBCHB'
    expect(polymerisation_machine.polymer_after(4)).to eq 'NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB'
  end

  it 'gives the correct solution for the example' do
    polymerisation_machine = described_class.new(example_polymer, example_pair_insertions)

    expect(polymerisation_machine.polymer_after(10).size).to eq(3073)
    expect(polymerisation_machine.min_max_elements).to eq({'B' => 1749, 'H' => 161})
    expect(polymerisation_machine.result).to eq 1588
  end
end
