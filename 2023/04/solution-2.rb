class Solution2
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map &:chomp
    end
  end

  Card = Data.define(:id, :winning_numbers, :numbers) do
    def self.generate_from(card_string)
      id_str, numbers_str = *card_string.split(':')
      id = id_str.match(/Card\s+(\d+)/)[1].to_i
      winning_numbers_str, numbers_str = numbers_str.split('|')
      winning_numbers = winning_numbers_str.scan(/\d+/).map(&:to_i)
      numbers = numbers_str.scan(/\d+/).map(&:to_i)
      new(id:, winning_numbers:, numbers:)
    end

    attr_reader :matches

    def initialize(id:, winning_numbers:, numbers:)
      @matches = (winning_numbers & numbers).size
      super
    end

    def score
      if [0,1,2].include? matches
        matches
      else
        2 ** (matches-1)
      end
    end

    def prizes
      (id+1).upto(id+matches).to_a
    end
  end

  def initialize(cards)
    @cards = cards
  end

  def result
    counts = Hash[prepared_cards.map { |x| [x.id, 1] }]
    prepared_cards.each do |card|
      multiplier = counts[card.id]
      card.prizes.each { |p| counts[p] += multiplier }
    end
    counts.values.sum
  end

  def prepared_cards
    return @prepared_cards if defined? @prepared_cards

    @prepared_cards = cards.map { |card| Card.generate_from(card) }
  end

  private

  attr_reader :cards

end

if __FILE__ == $0
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
