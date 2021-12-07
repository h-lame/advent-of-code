require 'csv'

class Solution
  class Normalizer
    def self.do_it(file_name)
      CSV.parse_line File.open(file_name, &:readline).chomp, converters: [:numeric]
    end
  end

  def initialize(crab_submarine_positions)
    @crab_submarine_positions = crab_submarine_positions
  end

  def result
    range.map { |position| fuel_cost_to_align_at(position) }.min
  end

  def fuel_cost_to_align_at(position)
    crab_submarine_positions.sum { |crab_submarine_position| (position - crab_submarine_position).abs }
  end

  private

  attr_reader :crab_submarine_positions

  def range
    Range.new(*crab_submarine_positions.minmax)
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
