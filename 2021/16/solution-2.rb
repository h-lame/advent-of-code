class Solution
  class Normalizer
    def self.do_it(file_name)
      File.read(file_name).chomp
    end
  end

  def initialize(hex_string)
    @bits = ("%0*b" % [hex_string.size * 4, Integer(hex_string, 16)]).chars
  end

  def packet
    return @packet if defined? @packet

    @packet = Packet.build(bits)
  end

  def result
    packet.value
  end

  class Packet
    attr_reader :version, :type_id

    def self.build(bits)
      new(
        Integer(bits.slice!(0..2).join, 2),
        Integer(bits.slice!(0..2).join, 2)
      ).tap { |packet|
        packet.populate(bits)
      }
    end

    def initialize(version, type_id)
      @version = version
      @type_id = type_id
    end

    def populate(bits)
      if type == :value
        populate_value(bits)
      else
        populate_operator(bits)
      end
    end

    def type
      @type ||= (type_id == 4 ? :value : :operator)
    end

    def subpackets
      return [] if type == :value

      @subpackets
    end

    def value
      return @value if defined? @value

      case type_id
      when 0
        subpackets.sum &:value
      when 1
        subpackets.map(&:value).reduce :*
      when 2
        subpackets.map(&:value).min
      when 3
        subpackets.map(&:value).max
      when 5
        subpackets[0].value > subpackets[1].value ? 1 : 0
      when 6
        subpackets[0].value < subpackets[1].value ? 1 : 0
      when 7
        subpackets[0].value == subpackets[1].value ? 1 : 0
      end
    end

    def version_sum
      if type == :value
        version
      else
        version + subpackets.sum(&:version_sum)
      end
    end

    def populate_value(bits)
      value_bits = []
      loop do
        more_flag, *value = bits.slice!(0..4)
        value_bits += value
        break if more_flag == '0'
      end
      @value = Integer(value_bits.join, 2)
    end

    def populate_operator(bits)
      length = bits.slice!(0)
      if length == '1'
        populate_subpackets_by_count bits
      else
        populate_subpackets_by_length bits
      end
    end

    def populate_subpackets_by_count(bits)
      count = Integer(bits.slice!(0..10).join, 2)
      @subpackets = count.times.map do
        self.class.build(bits)
      end
    end

    def populate_subpackets_by_length(bits)
      length = Integer(bits.slice!(0..14).join, 2)
      subpacket_bits = bits.slice!(0..(length - 1))
      @subpackets = []
      loop do
        @subpackets << self.class.build(subpacket_bits)
        break if subpacket_bits.size.zero?
      end
    end
  end

  private

  attr_reader :bits

end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
