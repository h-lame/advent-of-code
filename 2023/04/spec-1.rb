require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
  let(:raw_scratchcards) { [
    'Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53',
    'Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19',
    'Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1',
    'Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83',
    'Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36',
    'Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11',
  ] }

  describe Solution1::Normalizer do
    it 'converts a file into an array of strings, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_scratchcards
    end
  end

  describe Solution1::Card do
    it 'extracts an id, a list of winning numbers, and a list of numbers on the card from a string' do
      card = described_class.generate_from raw_scratchcards[0]
      expect(card.id).to eq 1
      expect(card.winning_numbers).to eq [41, 48, 83, 86, 17]
      expect(card.numbers).to eq [83, 86, 6, 31, 17, 9, 48, 53]
    end

    it 'calculates a score based on 2* the number of numbers in the winning set and the card set' do
      expect(described_class.generate_from(raw_scratchcards[0]).score).to eq 8
      expect(described_class.generate_from(raw_scratchcards[1]).score).to eq 2
      expect(described_class.generate_from(raw_scratchcards[2]).score).to eq 2
      expect(described_class.generate_from(raw_scratchcards[3]).score).to eq 1
      expect(described_class.generate_from(raw_scratchcards[4]).score).to eq 0
      expect(described_class.generate_from(raw_scratchcards[5]).score).to eq 0
    end
  end

  it 'gives the correct solution for the example' do
    expect(described_class.new(raw_scratchcards).result).to eq 13
  end
end
