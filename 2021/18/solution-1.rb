class Solution
  class Normalizer
    def self.do_it(file_name)
      from_array(File.readlines(file_name).map &:chomp)
    end

    def self.from_array(numbers)
      numbers.map { |number| from_string(number) }
    end

    def self.from_string(string)
      string
        .chars
        .map do |c|
          case c
          when /\A\[|\]\Z/
            c
          when /\A[0-9]\Z/
            Integer(c)
          else
            nil
          end
        end
        .compact
    end
  end

  def initialize(homework)
    @homework = homework
  end

  def final_sum
    return @final_sum if defined? @final_sum

    @final_sum = homework.map { |x| SnailfishNumber.new x }.reduce &:+
  end

  def result
    final_sum.magnitude
  end

  private

  attr_reader :homework

  class SnailfishNumber
    def initialize(number_representation)
      @number_representation = number_representation
      reduce!
    end

    attr_reader :number_representation

    def +(other)
      raise "nah" unless other.is_a? self.class

      SnailfishNumber.new(['[', *number_representation, *other.number_representation, ']'])
    end

    def reduce!
      loop do
        @changed = false
        explode!
        next if changed?

        split!
        next if changed?

        break
      end
    end

    def magnitude
      stack = []
      number_representation.each do |char|
        case char
        when /\A\[\Z/
          stack << []
        when /\A\]\Z/
          pair = stack.pop
          (stack.last || stack) << (pair.first * 3) + (pair.last * 2)
        when Numeric
          stack.last << char
        end
      end
      raise stack if stack.size > 1
      stack.pop
    end

    def to_s
      prev = nil
      out = ''
      number_representation.each do |char|
        case char
        when /\A\[\Z/
          out << ',' if prev != nil && prev != '['
        when /\A\]\Z/
          # no-op
        when Numeric
          out << ',' unless prev == '['
        end
        out << char.to_s
        prev = char
      end
      out
    end

    private

    def explode!
      change = nil
      depth = 0
      number_representation.each.with_index do |char, idx|
        case char
        when /\A\[\Z/
          depth += 1
          if depth >= 5
            change = [idx]
          end
        when /\A\]\Z/
          if depth >= 5
            change << idx
            break
          else
            depth -= 1
          end
        when Numeric
          if depth >= 5
            change << char
          end
        end
      end
      if change
        @changed = true
        number_representation.slice!(change.first..change.last)
        number_representation.insert(change.first, 0)

        left, right = *change[1..-2]

        left_idx = number_representation[0..change.first-1].rindex { |x| x.is_a? Numeric }
        number_representation[left_idx] += left if left_idx

        right_idx = number_representation[change.first+1..].index { |x| x.is_a? Numeric }
        number_representation[right_idx + change.first + 1] += right if right_idx
      end
    end

    def split!
      change = nil
      number_representation.each.with_index do |char, idx|
        case char
        when Numeric
          if char >= 10
            change = [idx, ['[', (char / 2.0).floor, (char / 2.0).ceil, ']']]
            break
          end
        end
      end
      if change
        @changed = true
        number_representation.delete_at(change.first)
        number_representation.insert(change.first, *change.last)
      end
    end

    def changed?
      @changed == true
    end
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
