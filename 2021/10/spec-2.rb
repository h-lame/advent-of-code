require File.join(__dir__, 'solution-2')

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

  let(:incomplete_navigation_rules) {
    [
      '[({(<(())[]>[[{[]{<()<>>',
      '[(()[<>])]({[<{<<[]>>(',
      '(((({<>}<{<{<>}{[]{[]{}',
      '{<[[]]>}<{[{[{[]{()[[[]',
      '<{([{{}}[<[[[<>{}]]]>[]]',
    ]
  }

  describe Solution::Normalizer do
    it 'extracts the navigation rules as an array of strings, one per line of the file' do
      expect(described_class.do_it(File.join(__dir__,'example.txt'))).to eq example_navigation_rules
    end
  end

  it 'gives the correct solution for the example' do
    navigation_rules = described_class.new(example_navigation_rules)
    expect(navigation_rules.incomplete).to eq incomplete_navigation_rules
    expect(navigation_rules.result).to eq 288957
  end

  describe Solution::RuleParser do
    it 'suggests the simplest completion for an incomplete rule' do
      expect(described_class.new('[({(<(())[]>[[{[]{<()<>>').completion).to eq '}}]])})]'
      expect(described_class.new('[(()[<>])]({[<{<<[]>>(').completion).to eq ')}>]})'
      expect(described_class.new('(((({<>}<{<{<>}{[]{[]{}').completion).to eq '}}>}>))))'
      expect(described_class.new('{<[[]]>}<{[{[{[]{()[[[]').completion).to eq ']]}}]}]}>'
      expect(described_class.new('<{([{{}}[<[[[<>{}]]]>[]]').completion).to eq '])}>'
    end

    it 'scores the completion according to a formula' do
      expect(described_class.new('[({(<(())[]>[[{[]{<()<>>').completion_score).to eq 288957
      expect(described_class.new('[(()[<>])]({[<{<<[]>>(').completion_score).to eq 5566
      expect(described_class.new('(((({<>}<{<{<>}{[]{[]{}').completion_score).to eq 1480781
      expect(described_class.new('{<[[]]>}<{[{[{[]{()[[[]').completion_score).to eq 995444
      expect(described_class.new('<{([{{}}[<[[[<>{}]]]>[]]').completion_score).to eq 294
    end
  end
end
