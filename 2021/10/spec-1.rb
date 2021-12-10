require File.join(__dir__, 'solution-1')

RSpec.describe Solution do
  let(:example_navigation_rules) {
    [
      '[({(<(())[]>[[{[]{<()<>>',
      '[(()[<>])]({[<{<<[]>>(',
      '{([(<{}[<>[]}>{[]{[(<()>',
      '(((({<>}<{<{<>}{[]{[]{}',
      '[[<[([]))<([[{}[[()]]]',
      '[{[{({}]{}}([{[{{{}}([]',
      '{<[[]]>}<{[{[{[]{()[[[]',
      '[<(<(<(<{}))><([]([]()',
      '<{([([[(<>()){}]>(<<{{',
      '<{([{{}}[<[[[<>{}]]]>[]]'
    ]
  }

  let(:corrupted_navigation_rules) {
    [
      '{([(<{}[<>[]}>{[]{[(<()>',
      '[[<[([]))<([[{}[[()]]]',
      '[{[{({}]{}}([{[{{{}}([]',
      '[<(<(<(<{}))><([]([]()',
      '<{([([[(<>()){}]>(<<{{',
    ]
  }

  describe Solution::Normalizer do
    it 'extracts the navigation rules as an array of strings, one per line of the file' do
      expect(described_class.do_it(File.join(__dir__,'example.txt'))).to eq example_navigation_rules
    end
  end

  it 'gives the correct solution for the example' do
    navigation_rules = described_class.new(example_navigation_rules)
    expect(navigation_rules.corrupted).to eq corrupted_navigation_rules
    expect(navigation_rules.result).to eq 26397
  end

  describe Solution::RuleParser do
    it 'extracts the first corrupt character from a line' do
      expect(described_class.new('{([(<{}[<>[]}>{[]{[(<()>').corrupt_char).to eq '}'
      expect(described_class.new('[[<[([]))<([[{}[[()]]]').corrupt_char).to eq ')'
      expect(described_class.new('[{[{({}]{}}([{[{{{}}([]').corrupt_char).to eq ']'
      expect(described_class.new('[<(<(<(<{}))><([]([]()').corrupt_char).to eq ')'
      expect(described_class.new('<{([([[(<>()){}]>(<<{{').corrupt_char).to eq '>'
    end
  end
end
