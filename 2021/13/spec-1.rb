require File.join(__dir__, 'solution-1')

RSpec.describe Solution do
  let(:example_marks) {
    [
      [6,10],
      [0,14],
      [9,10],
      [0,3],
      [10,4],
      [4,11],
      [6,0],
      [6,12],
      [4,1],
      [0,13],
      [10,12],
      [3,4],
      [3,0],
      [8,4],
      [1,10],
      [2,14],
      [8,10],
      [9,0],
    ]
  }
  let(:example_folds) {
    [
      [:y, 7],
      [:x, 5],
    ]
  }

  describe Solution::Normalizer do
    subject(:normalizer) { described_class.do_it(File.join(__dir__,'example.txt')) }

    it 'extracts the marks as an array of pairs of numbers one per line of the file until there is a blank line' do
      expect(normalizer.first).to eq example_marks
    end

    it 'extracts the folds as an array of pairs of symbol and numbers, one per line of the file after the is a blank line' do
      expect(normalizer.last).to eq example_folds
    end
  end

  it 'gives the correct solution for the example' do
    folding_instructions = described_class.new(example_marks, example_folds)

    expect(folding_instructions.result).to eq 17
  end
end
