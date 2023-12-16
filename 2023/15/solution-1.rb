class Solution1
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp).join.split(',')
    end
  end

  module Hash
    def self.calc(string)
      # Determine the ASCII code for the current character of the string.
      # Increase the current value by the ASCII code you just determined.
      # Set the current value to itself multiplied by 17.
      # Set the current value to the remainder of dividing itself by 256.
      string.chars.reduce(0) do |acc, char|
        acc += char.ord
        acc = acc * 17
        acc % 256
      end
    end
  end

  def initialize(initialisation_sequence)
    @initialisation_sequence = initialisation_sequence
  end

  attr_reader :initialisation_sequence

  def result = initialisation_sequence.map { |sequence_part| Hash.calc sequence_part }.sum

end

if __FILE__ == $0
  puts Solution1.new(Solution1::Normalizer.do_it(ARGV[0])).result
end
