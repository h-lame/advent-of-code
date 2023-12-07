class Solution2
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
      @type = calculate_jokered_type(cards)
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

    def calculate_jokered_type(cards)
      sorted_cards = cards.chars.sort!
      raw_type = calculate_raw_type(sorted_cards)
      return raw_type unless sorted_cards.include? 'J'

      case raw_type
      when self.class::FIVE_OF_A_KIND
        self.class::FIVE_OF_A_KIND
      when self.class::FOUR_OF_A_KIND
        # four of a kind options:
        # 1 J - five of a kind - becomes the 4
        # 4 J - five of a kind - all become the 1
        self.class::FIVE_OF_A_KIND
      when self.class::FULL_HOUSE
        # full house options
        # - 2 J - five of a kind - match the 3
        # - 3 J - five of a kind - match the pair
        case sorted_cards.count 'J'
        when 3 then self.class::FIVE_OF_A_KIND
        when 2 then self.class::FIVE_OF_A_KIND
        else
          raise "oh no - full house with #{sorted_cards.count 'J'}s - unexpected #{cards}"
        end
      when self.class::THREE_OF_A_KIND
        # three of a kind options
        # - 1 J - four of a kind - add to the 3
        # - 2 J - nt possible - would be full house
        # - 3 J - four of a kind - add one of the other cards
        case sorted_cards.count 'J'
        when 3 then self.class::FOUR_OF_A_KIND
        when 1 then self.class::FOUR_OF_A_KIND
        else
          raise "oh no - three of a kind with #{sorted_cards.count 'J'}s - unexpected #{cards}"
        end
      when self.class::TWO_PAIR
        # two pair options:
        #  - 1 J between the pairs - convert to full house
        #  - 2 Js (it's one of the pairs) - conver to four of a kind
        case sorted_cards.count 'J'
        when 2 then self.class::FOUR_OF_A_KIND
        when 1 then self.class::FULL_HOUSE
        else
          raise "oh no - two pair with #{sorted_cards.count 'J'}s - unexpected #{cards}"
        end
      when self.class::ONE_PAIR
        # one PAIR means I can have 1 or 2 Js (the Js are the pair)
        # all I can do is THREE_OF_A_KIND - add 1 J to a pair or add one card to a pair of Js
        case sorted_cards.count 'J'
        when 2 then self.class::THREE_OF_A_KIND
        when 1 then self.class::THREE_OF_A_KIND
        else
          raise "oh no - one pair with #{sorted_cards.count 'J'}s - unexpected #{cards}"
        end
      else #self.class::HIGH_CARD
        # all cards different, 1 J = becomes ONE_PAIR
        self.class::ONE_PAIR
      end
    end

    def calculate_raw_type(sorted_cards)
      case sorted_cards.join
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
      card_order = ['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J']
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
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
