class Solution1
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name)
        .map(&:chomp)
        .map { |line| hand, bid = *line.split(/\s+/); [hand, bid.to_i] }
    end
  end

  Hand = Data.define(:cards, :bid) do
    const_set('FIVE_OF_A_KIND', 1)
    const_set('FOUR_OF_A_KIND', 2)
    const_set('FULL_HOUSE', 3)
    const_set('THREE_OF_A_KIND', 4)
    const_set('TWO_PAIR', 5)
    const_set('ONE_PAIR', 6)
    const_set('HIGH_CARD', 7)

    def initialize(cards:, bid:)
      @type = calculate_type(cards)
      @card_values = extract_card_values(cards)
      super
    end

    def <=>(other)
      return nil unless other.is_a? Hand

      c = self.type <=> other.type
      c == 0 ? self.card_values <=> other.card_values : c
    end

    attr_reader :type, :card_values

    private

    def calculate_type(cards)
      case cards.chars.sort!.join
      when /(.)\1{4}/
        self.class::FIVE_OF_A_KIND
      when /(.)\1{3}/
        self.class::FOUR_OF_A_KIND
      when /(?:(.)\1{2}(.)\2)|(?:(.)\3(.)\4{2})/
        self.class::FULL_HOUSE
      when /(.)\1{2}/
        self.class::THREE_OF_A_KIND
      when /.?(.)\1.?(.)\2/
        self.class::TWO_PAIR
      when /(.)\1/
        self.class::ONE_PAIR
      else
        self.class::HIGH_CARD
      end
    end

    def extract_card_values(cards)
      card_order = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2']
      cards.chars.map { |x| card_order.index x }
    end
  end

  def initialize(hands)
    @hands = hands
  end

  def result
    ranked_hands_with_winnings.reduce(:+)
  end

  def ranked_hands_with_winnings
    ranked_hands.map.with_index { |h, rank| (prepared_hands.size - rank) * h.bid }
  end

  def ranked_hands
    prepared_hands.sort
  end

  def prepared_hands
    return @prepared_hands if defined? @prepared_hands

    @prepared_hands = hands.map { |hand| Hand.new(cards: hand[0], bid: hand[1]) }
  end

  private

  attr_reader :hands

end

if __FILE__ == $0
  puts Solution1.new(Solution1::Normalizer.do_it(ARGV[0])).result
end
