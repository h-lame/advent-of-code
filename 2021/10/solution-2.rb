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
    navigation_rules.reject { |rule| Solution::RuleParser.new(rule).corrupt_char.nil? }
  end

  def incomplete
    navigation_rules.select { |rule| Solution::RuleParser.new(rule).corrupt_char.nil? }
  end

  def result
    completion_scores = navigation_rules
      .map { |rule| Solution::RuleParser.new(rule).completion_score }
      .reject { |x| x == 0 }
      .sort
    completion_scores[completion_scores.size/2]
  end

  private

  attr_reader :navigation_rules

  class RuleParser
    attr_reader :corrupt_char

    def initialize(rule)
      @rule = rule.chars
      @stack = []
      @corrupt_char = nil
      parse!
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

    def completion
      return nil if corrupt_char

      @_completion ||= stack.reverse.map { |char| CLOSERS[OPENERS.index(char)] }.join
    end

    def completion_score
      return 0 unless completion

      completion.chars.reduce(0) do |score, char|
        (score * 5) + (CLOSERS.index(char) + 1)
      end
    end

    private

    attr_reader :rule, :stack
    attr_writer :corrupt_char

    def parse!
      rule.each do |char|
        if OPENERS.include? char
          stack << char
        elsif CLOSERS.include? char
          if valid_pair?(stack.last, char)
            stack.pop
          else
            self.corrupt_char = char
            break
          end
        end
      end
    end

    def valid_pair?(opener, closer)
      OPENERS.index(opener) == CLOSERS.index(closer)
    end

    OPENERS = '([{<'
    CLOSERS = ')]}>'
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
