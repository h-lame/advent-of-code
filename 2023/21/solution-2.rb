require 'set'

class Solution2
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp).map do |iteration|
        /\Ak=(?<k>\d+) \((?<step_count>\d+) steps\) = (?<plots_reachable>\d+)/ =~ iteration
        [k.to_i, step_count.to_i, plots_reachable.to_i]
      end
    end
  end

  def initialize(raw_notes)
    @raw_notes = raw_notes
    puts "R= #{raw_notes}"
  end

  attr_reader :raw_notes

  def result(steps)
    raise "not enough data" unless raw_notes.size >= 3

    x0, s0, y0 = *raw_notes[0]
    x1, s1, y1 = *raw_notes[1]
    x2, s2, y2 = *raw_notes[2]

    x = (steps - s0) / (s2-s1)

    l0 = ->(x) { ((x - x1) * (x - x2)) / ((x0 - x1) * (x0 - x2)) }
    l1 = ->(x) { ((x - x0) * (x - x2)) / ((x1 - x0) * (x1 - x2)) }
    l2 = ->(x) { ((x - x0) * (x - x1)) / ((x2 - x0) * (x2 - x1)) }

    y0 * l0.(x) + y1 * l1.(x) + y2 * l2.(x)
  end
end

if __FILE__ == $0
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result(ARGV[1].to_i)
end
