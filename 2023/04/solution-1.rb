class Solution1
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

      puts "i: #{id}, w: #{winning_numbers}, n: #{numbers}"

      new(id:, winning_numbers:, numbers:)
    end

    def score
      matches = (winning_numbers & numbers).size
      if [0,1,2].include? matches
        matches
      else
        2 ** (matches-1)
      end
    end
  end

  def initialize(cards)
    @cards = cards
  end

  def result
    prepared_cards.sum { |c| c.score }
  end

  def prepared_cards
    return @prepared_cards if defined? @prepared_cards

    @prepared_cards = cards.map { |card| Card.generate_from(card) }
  end

  private

  attr_reader :cards

end

if __FILE__ == $0
  puts Solution1.new(Solution1::Normalizer.do_it(ARGV[0])).result
end
