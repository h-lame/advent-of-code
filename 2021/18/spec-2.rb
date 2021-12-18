require File.join(__dir__, 'solution-2')

RSpec.describe Solution do
  let(:example_homework) {
    [
      ['[', '[', '[', 0, '[', 5, 8, ']', ']', '[', '[', 1, 7, ']', '[', 9, 6, ']', ']', ']', '[', '[', 4, '[', 1, 2, ']', ']', '[', '[', 1, 4, ']', 2, ']', ']', ']'],
      ['[', '[', '[', 5, '[', 2, 8, ']', ']', 4, ']', '[', 5, '[', '[', 9, 9, ']' ,0, ']', ']', ']'],
      ['[', 6, '[', '[', '[', 6, 2, ']', '[', 5, 6, ']', ']', '[', '[', 7, 6, ']', '[', 4, 7, ']', ']', ']', ']'],
      ['[', '[', '[', 6, '[', 0, 7, ']', ']', '[', 0, 9, ']', ']', '[', 4, '[', 9, '[', 9, 0, ']', ']', ']', ']'],
      ['[', '[', '[', 7, '[', 6, 4, ']', ']', '[', 3, '[', 1, 3, ']', ']', ']', '[', '[', '[', 5, 5, ']', 1, ']', 9, ']', ']'],
      ['[', '[', 6,'[', '[', 7, 3, ']', '[', 3, 2, ']', ']', ']', '[', '[', '[', 3, 8, ']', '[', 5, 7, ']', ']', 4, ']', ']'],
      ['[', '[', '[', '[', 5, 4, ']', '[', 7, 7, ']', ']', 8, ']', '[', '[', 8, 3, ']', 8, ']', ']'],
      ['[', '[', 9, 3, ']', '[', '[', 9, 9, ']', '[', 6, '[', 4, 9, ']', ']', ']', ']'],
      ['[', '[', 2, '[', '[', 7, 7, ']', 7, ']', ']', '[', '[', 5, 8, ']', '[', '[', 9, 3, ']', '[', 0, 2, ']', ']', ']', ']'],
      ['[', '[', '[', '[', 5, 2, ']', 5, ']', '[', 8, '[', 3, 7, ']', ']', ']', '[', '[', 5, '[', 7, 5, ']', ']', '[', 4, 4, ']', ']', ']'],
    ]
  }

  describe Solution::Normalizer do
    it 'extracts the homework assignment as an array of arrays of characters, with number characters as numbers and commas remove, one array per line' do
      expect(described_class.do_it(File.join(__dir__,'example.txt'))).to eq example_homework
    end
  end

  describe Solution::SnailfishNumber do
    it 'calculates magnitude correctly' do
      expect(described_class.new(Solution::Normalizer.from_string('[9,1]')).magnitude).to eq 29
      expect(described_class.new(Solution::Normalizer.from_string('[[1,2],[[3,4],5]]')).magnitude).to eq 143
      expect(described_class.new(Solution::Normalizer.from_string('[[[[0,7],4],[[7,8],[6,0]]],[8,1]]')).magnitude).to eq 1384
      expect(described_class.new(Solution::Normalizer.from_string('[[[[1,1],[2,2]],[3,3]],[4,4]]')).magnitude).to eq 445
      expect(described_class.new(Solution::Normalizer.from_string('[[[[3,0],[5,3]],[4,4]],[5,5]]')).magnitude).to eq 791
      expect(described_class.new(Solution::Normalizer.from_string('[[[[5,0],[7,4]],[5,5]],[6,6]]')).magnitude).to eq 1137
      expect(described_class.new(Solution::Normalizer.from_string('[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]')).magnitude).to eq 3488
    end

    it 'reduces correctly' do
      expect(described_class.new(Solution::Normalizer.from_string('[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]')).to_s).to eq '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]'
    end

    it 'adds correctly' do
      left = described_class.new(Solution::Normalizer.from_string('[9,1]'))
      right = described_class.new(Solution::Normalizer.from_string('[1,9]'))
      expect((left + right).to_s).to eq '[[9,1],[1,9]]'
    end
  end

  it 'generates the correct solution for the example' do
    snailfish_number_calculator = described_class.new(example_homework)

    require 'pry'; binding.pry

    expect(snailfish_number_calculator.final_equation.map(&:to_s)).to eq ['[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]', '[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]']
    expect(snailfish_number_calculator.final_sum.to_s).to eq '[[[[7,8],[6,6]],[[6,0],[7,7]]],[[[7,8],[8,8]],[[7,9],[0,6]]]]'
    expect(snailfish_number_calculator.result).to eq 3993
  end
end
