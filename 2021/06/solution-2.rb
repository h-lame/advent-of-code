require 'csv'

class Solution
  class Normalizer
    def self.do_it(file_name)
      CSV.parse_line File.open(file_name, &:readline).chomp, converters: [:numeric]
    end
  end

  def initialize(lantern_fishies)
    @initial_state = lantern_fishies
  end

  def result_at(days)
    reset_simulation!
    days.times do |day|
      to_spawn = lantern_fish_catalogue[0]
      (1..8).each do |timer|
        lantern_fish_catalogue[timer -1] = lantern_fish_catalogue[timer]
      end
      lantern_fish_catalogue[6] += to_spawn
      lantern_fish_catalogue[8] = to_spawn
    end
    lantern_fish_catalogue.sum { |_timer, count| count }
  end

  private

  attr_reader :initial_state, :lantern_fish_catalogue

  def reset_simulation!
    @lantern_fish_catalogue = initial_state.reduce(Hash.new(0)) { |catalogue, spawn_timer| catalogue[spawn_timer] += 1; catalogue }
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result_at(Integer(ARGV[1]))
end
