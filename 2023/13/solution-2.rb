class Solution2
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
      reflections = detect_reflection(pattern)
      @reflection = reflections[:reflection]
      @smudge_reflection = reflections[:smudge_reflection]
      super
    end

    attr_reader :pattern, :reflection, :smudge_reflection

    def score
      case smudge_reflection
      in [:horizontal, x]
        100 * x
      in [:vertical, x]
        x
      end
    end

    private
    def detect_reflection(pattern)
      reflection_horizontal, smudge_reflection_horizontal = *find_mirror_in(pattern)
      if reflection_horizontal.nil?
        reflection_vertical, smudge_reflection_vertical = *find_mirror_in(pattern.map { |x| x.chars }.transpose.map { |x| x.reverse.join })
        if reflection_vertical.nil?
          raise "arg - no reflection in #{pattern}"
        else
          raise "no smudge" if (smudge_reflection_horizontal.size + smudge_reflection_vertical.size) == 0
          raise "too many smudges" if (smudge_reflection_horizontal.size + smudge_reflection_vertical.size) > 1
          {
            reflection: [:vertical, reflection_vertical+1],
            smudge_reflection:
              if smudge_reflection_horizontal[0]
                [:horizontal, smudge_reflection_horizontal.first+1]
              else
                [:vertical, smudge_reflection_vertical.first+1]
              end
          }
        end
      else
        reflection_vertical, smudge_reflection_vertical = *find_mirror_in(pattern.map { |x| x.chars }.transpose.map { |x| x.reverse.join })
        raise "found 2nd reflection! in vertical when already detected horizontal" unless reflection_vertical.nil?
        raise "no smudge" if (smudge_reflection_horizontal.size + smudge_reflection_vertical.size) == 0
        raise "too many smudges" if (smudge_reflection_horizontal.size + smudge_reflection_vertical.size) > 1
        {
          reflection: [:horizontal, reflection_horizontal+1],
          smudge_reflection:
            if smudge_reflection_horizontal[0]
              [:horizontal, smudge_reflection_horizontal.first+1]
            else
              [:vertical, smudge_reflection_vertical.first+1]
            end
        }
      end
    end

    def find_mirror_in(pattern)
      reflection = nil
      smudge_reflection = []
      pattern.each_with_index do |row, idx|
        match_row = idx+1
        next if (idx == pattern.size-1)

        matches =
          if idx.zero?
            row.chars.zip(pattern[idx+1].chars).count { |pair| pair.first != pair.last }
          else
            before = 0..idx
            after = match_row..(pattern.size-1)
            comparisons = before.size > after.size ? after.to_a.zip(before.to_a.reverse) : before.to_a.reverse.zip(after.to_a)
            comparisons.map { |(b, a)| pattern[b].chars.zip(pattern[a].chars).count { |pair| pair.first != pair.last } }.sum
          end

        if matches.zero?
          reflection = idx
        elsif matches == 1
          smudge_reflection << idx
        end
        break if reflection && smudge_reflection.size > 1
      end
      [reflection, smudge_reflection]
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
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
