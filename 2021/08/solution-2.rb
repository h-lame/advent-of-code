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

  def result
    notes.sum &:decoded_as_number
  end

  private

  attr_reader :notes

  class NoteDecoder
    attr_reader :decoded

    def initialize(patterns:, numbers:)
      @patterns = patterns.map &:chars
      @numbers = numbers.map &:chars
      decode_numbers!
    end

    def decoded_as_number
      decoded.reverse.map.with_index { |elem, idx| (elem * 10**(idx)) }.sum
    end

    private

    attr_reader :patterns, :numbers

    def segments
      return @segments if defined? @segments

      @segments = { a: nil, b: nil, c: nil, d: nil, e: nil, f: nil, g: nil }
      patterns_by_size = patterns.group_by { |n| n.size }
      one = patterns_by_size[2].first
      seven = patterns_by_size[3].first
      four = patterns_by_size[4].first
      eight = patterns_by_size[7].first

      # a: the segment from 7 not in 1
      @segments[:a] = (seven - one).first
      # f: the segment in 4 + 1 + 7 and 3 of the 6 chars (0,6,9)
      @segments[:f] = ((four & one & seven) & (patterns_by_size[6].reduce :&)).first
      # c: the segment in 4 + 1 + 7 that's not f
      @segments[:c] = ((four & one & seven) - [segments[:f]]).first
      # g: the segment in all 6 chars (0,6,9) and all 5 chars (2,3,5) but not in 7
      @segments[:g] = (patterns_by_size[6].reduce(:&) & patterns_by_size[5].reduce(:&) - seven).first
      # d: the segment in 4 in all three 5 chars (2,3,5)
      @segments[:d] = (four & patterns_by_size[5].reduce(:&)).first
      # b: the segment in 4 that's not f, c, or d
      @segments[:b] = (four - [@segments[:f], @segments[:c], @segments[:d]]).first
      # e: what's left
      @segments[:e] = (eight - [@segments[:a], @segments[:f], @segments[:c], @segments[:g], @segments[:d], @segments[:b]]).first

      @segments
    end

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
            segments_to_number(segments)
          end
        end
    end

    def coded_numbers
      return @_coded_numbers if defined? @_coded_numbers

      @_coded_numbers = [
        segments.values_at(*%i{a b c e f g}).sort,
        segments.values_at(*%i{c f}).sort,
        segments.values_at(*%i{a c d e g}).sort,
        segments.values_at(*%i{a c d f g}).sort,
        segments.values_at(*%i{b c d f}).sort,
        segments.values_at(*%i{a b d f g}).sort,
        segments.values_at(*%i{a b d e f g}).sort,
        segments.values_at(*%i{a c f}).sort,
        segments.values_at(*%i{a b c d e f g}).sort,
        segments.values_at(*%i{a b c d f g}).sort
      ]
    end

    def segments_to_number(segments_to_translate)
      coded_numbers.index segments_to_translate.sort
    end
  end

end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
