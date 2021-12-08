require 'csv'

class Solution
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map do |line|
        patterns, numbers = line.chomp.split(' | ')
        {
          patterns: (patterns.split ' '),
          numbers: (numbers.split ' ')
        }
      end
    end
  end

  def initialize(notes)
    @notes = notes.map { |n| Solution::NoteDecoder.new **n }
  end

  def count(digit)
    notes.sum { |n| n.count(digit) }
  end

  def result
    notes.sum { |n| n.count(1) + n.count(4) + n.count(7) + n.count(8) }
  end

  private

  attr_reader :notes

  class NoteDecoder
    def initialize(patterns:, numbers:)
      @patterns = patterns
      @numbers = numbers
      decode_numbers!
    end

    def count(digit)
      decoded.count { |decoded_digit| decoded_digit == digit }
    end

    private

    attr_reader :patterns, :numbers, :decoded

    def decode_numbers!
      @decoded =
        @numbers.map do |segments|
          case segments.size
          when 2
            1
          when 3
            7
          when 4
            4
          when 7
            8
          else
            '?'
          end
        end
    end
  end


end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
