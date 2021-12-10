require 'csv'

class Solution
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp)
    end
  end

  def initialize(navigation_rules)
    @navigation_rules = navigation_rules
  end

  def corrupted
    navigation_rules.reject { |rule| Solution::CorruptionDetector.new(rule).corrupt_char.nil? }
  end

  def result
    navigation_rules.sum { |rule| Solution::CorruptionDetector.new(rule).error_score }
  end

  private

  attr_reader :navigation_rules

  class RuleParser
    def initialize(rule)
      @rule = rule.chars
    end

    def error_score
      case corrupt_char
      when ')'
        3
      when ']'
        57
      when '}'
        1197
      when '>'
        25137
      else
        0
      end
    end

    def corrupt_char
      return @corrupt_char if defined? @corrupt_char

      @corrupt_char = nil
      stack = []
      rule.each do |char|
        if OPENERS.include? char
          stack << char
        elsif CLOSERS.include? char
          if valid_pair?(stack.last, char)
            stack.pop
          else
            @corrupt_char = char
            break
          end
        end
      end

      @corrupt_char
    end

    def valid_pair?(opener, closer)
      OPENERS.index(opener) == CLOSERS.index(closer)
    end

    private

    attr_reader :rule

    OPENERS = '([{<'
    CLOSERS = ')]}>'
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
