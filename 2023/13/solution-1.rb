class Solution1
  class Normalizer
    def self.do_it(file_name)
      patterns = []
      pattern = []
      File.readlines(file_name).map(&:chomp).each do |line|
        if line == ''
          patterns << pattern
          pattern = []
        else
          pattern << line
        end
      end
      patterns + [pattern]
    end
  end

  Pattern = Data.define(:pattern) do
    def self.from_raw(raw_pattern)
      new(pattern: raw_pattern)
    end

    def initialize(pattern:)
      @reflection = detect_reflection(pattern)
      super
    end

    attr_reader :pattern, :reflection

    def score
      case reflection
      in [:horizontal, x]
        100 * x
      in [:vertical, x]
        x
      end
    end

    private
    def detect_reflection(pattern)
      mirror_position = find_mirror_in(pattern)
      if mirror_position.nil?
        mirror_position = find_mirror_in(pattern.map { |x| x.chars }.transpose.map { |x| x.reverse.join })
        if mirror_position.nil?
          raise "arg - no reflection in #{pattern}"
        else
          [:vertical, mirror_position+1]
        end
      else
        [:horizontal, mirror_position+1]
      end
    end

    def find_mirror_in(pattern)
      x = (pattern.each_with_index.detect do |row, idx|
        match_row = idx+1
        if idx.zero?
          row == pattern[idx+1]
        elsif (idx == pattern.size-1)
          false
        else
          before = 0..idx
          after = match_row..(pattern.size-1)
          comparisons = before.size > after.size ? after.to_a.zip(before.to_a.reverse) : before.to_a.reverse.zip(after.to_a)
          comparisons.all? { |(b, a)| pattern[b] == pattern[a] }
        end
      end || []).last
    end
  end

  def initialize(patterns)
    @raw_patterns = patterns
  end

  def result
    prepared_patterns.sum &:score
  end

  private

  attr_reader :raw_patterns

  def prepared_patterns = raw_patterns.map { |raw_pattern| Pattern.from_raw raw_pattern }

end

if __FILE__ == $0
  puts Solution1.new(Solution1::Normalizer.do_it(ARGV[0])).result
end
