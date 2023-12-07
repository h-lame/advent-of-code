require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
  let(:raw_hands) { [
    ['32T3K', 765],
    ['T55J5', 684],
    ['KK677', 28],
    ['KTJJT', 220],
    ['QQQJA', 483],
  ] }

  describe described_class::Normalizer do
    it 'converts a file into an array of hand and bid pairs, one per row' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_hands
    end
  end

  describe described_class::Hand do
    it 'understands the type of the hand based on the cards' do
      expect(described_class.new(cards: 'AAAAA', bid: 1).type).to eq described_class::FIVE_OF_A_KIND

      expect(described_class.new(cards: 'AAAA2', bid: 1).type).to eq described_class::FOUR_OF_A_KIND
      expect(described_class.new(cards: 'AAA2A', bid: 1).type).to eq described_class::FOUR_OF_A_KIND
      expect(described_class.new(cards: 'AA2AA', bid: 1).type).to eq described_class::FOUR_OF_A_KIND
      expect(described_class.new(cards: 'A2AAA', bid: 1).type).to eq described_class::FOUR_OF_A_KIND
      expect(described_class.new(cards: '2AAAA', bid: 1).type).to eq described_class::FOUR_OF_A_KIND

      expect(described_class.new(cards: 'AAA22', bid: 1).type).to eq described_class::FULL_HOUSE
      expect(described_class.new(cards: 'AA2A2', bid: 1).type).to eq described_class::FULL_HOUSE
      expect(described_class.new(cards: 'A2AA2', bid: 1).type).to eq described_class::FULL_HOUSE
      expect(described_class.new(cards: '2AAA2', bid: 1).type).to eq described_class::FULL_HOUSE
      expect(described_class.new(cards: 'AA22A', bid: 1).type).to eq described_class::FULL_HOUSE
      expect(described_class.new(cards: 'A2A2A', bid: 1).type).to eq described_class::FULL_HOUSE
      expect(described_class.new(cards: '2AA2A', bid: 1).type).to eq described_class::FULL_HOUSE
      expect(described_class.new(cards: 'A22AA', bid: 1).type).to eq described_class::FULL_HOUSE
      expect(described_class.new(cards: '2A2AA', bid: 1).type).to eq described_class::FULL_HOUSE
      expect(described_class.new(cards: '22AAA', bid: 1).type).to eq described_class::FULL_HOUSE

      expect(described_class.new(cards: 'AAA23', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: 'AAA32', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: 'AA2A3', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: 'AA23A', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: 'AA3A2', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: 'AA32A', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: 'A2AA3', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: 'A2A3A', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: 'A23AA', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: 'A3AA2', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: 'A3A2A', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: 'A32AA', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: '2AAA3', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: '2AA3A', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: '2A3AA', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: '23AAA', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: '3AAA2', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: '3AA2A', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: '3A2AA', bid: 1).type).to eq described_class::THREE_OF_A_KIND
      expect(described_class.new(cards: '32AAA', bid: 1).type).to eq described_class::THREE_OF_A_KIND

      expect(described_class.new(cards: 'AA233', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: 'AA323', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: 'AA332', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: 'A2A33', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: 'A23A3', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: 'A233A', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: 'A3A23', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: 'A3A32', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: 'A32A3', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: 'A323A', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: 'A33A2', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: 'A332A', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '2AA33', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '2A3A3', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '2A33A', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '23AA3', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '23A3A', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '233AA', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '3AA23', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '3AA32', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '3A2A3', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '3A23A', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '3A3A2', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '3A32A', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '32AA3', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '32A3A', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '323AA', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '33AA2', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '33A2A', bid: 1).type).to eq described_class::TWO_PAIR
      expect(described_class.new(cards: '332AA', bid: 1).type).to eq described_class::TWO_PAIR

      expect(described_class.new(cards: 'AA123', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'AA132', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'AA213', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'AA231', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'AA312', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'AA321', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A1A23', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A1A32', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A12A3', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A123A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A13A2', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A132A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A2A13', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A2A31', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A21A3', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A213A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A23A1', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A231A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A3A12', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A3A21', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A31A2', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A312A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A32A1', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: 'A321A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '1AA23', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '1AA32', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '1A2A3', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '1A23A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '1A3A2', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '1A32A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '12AA3', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '12A3A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '123AA', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '13AA2', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '13A2A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '132AA', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '2AA13', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '2AA31', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '2A1A3', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '2A13A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '2A3A1', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '2A31A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '21AA3', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '21A3A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '213AA', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '23AA1', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '23A1A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '231AA', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '3AA12', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '3AA21', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '3A1A2', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '3A12A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '3A2A1', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '3A21A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '31AA2', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '31A2A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '312AA', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '32AA1', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '32A1A', bid: 1).type).to eq described_class::ONE_PAIR
      expect(described_class.new(cards: '321AA', bid: 1).type).to eq described_class::ONE_PAIR

      expect(described_class.new(cards: 'A2345', bid: 1).type).to eq described_class::HIGH_CARD
    end

    it 'sorts based on type 5 -> 4 -> fh -> 3 -> 2p -> 1p -> h' do
      hands = ['A2345', '321AA', '332AA', '32AAA', '22AAA', '2AAAA', 'AAAAA'].map { |x| described_class.new(cards: x, bid: 1) }
      expect(hands.sort.map(&:cards)).to eq ['AAAAA', '2AAAA', '22AAA', '32AAA', '332AA', '321AA', 'A2345']
    end

    it 'sorts based on type value of cards for same type' do
      hands = ['22222', '33333', '44444', '55555', '66666', '77777', '88888', '99999', 'TTTTT', 'JJJJJ', 'QQQQQ', 'KKKKK', 'AAAAA'].map { |x| described_class.new(cards: x, bid: 1) }
      expect(hands.sort.map(&:cards)).to eq ['AAAAA', 'KKKKK', 'QQQQQ', 'JJJJJ', 'TTTTT', '99999', '88888', '77777', '66666', '55555', '44444', '33333', '22222']

      hands = ['23456', '234A5', '34567', 'A2345', 'A2346'].map { |x| described_class.new(cards: x, bid: 1) }
      expect(hands.sort.map(&:cards)).to eq ['A2346', 'A2345', '34567', '234A5', '23456']
    end

    it 'sorts the examples from the example.txt' do
      hands = ['2AAAA', '33332'].map { |x| described_class.new(cards: x, bid: 1) }
      expect(hands.sort.map(&:cards)).to eq ['33332', '2AAAA']

      hands = ['77788', '77888'].map { |x| described_class.new(cards: x, bid: 1) }
      expect(hands.sort.map(&:cards)).to eq ['77888', '77788']
    end
  end

  it 'ranks the hands correctly' do
    expect(
      described_class.new(raw_hands)
        .ranked_hands
        .map(&:cards)
    ).to eq [
      'QQQJA',
      'T55J5',
      'KK677',
      'KTJJT',
      '32T3K'
    ]
  end

  it 'gives the correct solution for the example' do
    expect(described_class.new(raw_hands).result).to eq 6440
  end
end
