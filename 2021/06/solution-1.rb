require 'csv'

class Solution
  class Normalizer
    def self.do_it(file_name)
      CSV.parse_line File.open(file_name, &:readline).chomp, converters: [:numeric]
    end
  end

  module SpawnCounter
    def spawn_count
      spawned.size + spawned.sum { |spawn| spawn.spawn_count }
    end
  end

  include SpawnCounter

  def initialize(lantern_fishies)
    @initial_state = lantern_fishies
  end

  def display_state
    spawned.map(&:display_state).flatten
  end

  def result_at(days)
    reset_simulation!
    days.times do |day|
      lantern_fishies.map &:day_elapsed!
    end
    spawn_count
  end

  private

  attr_reader :initial_state, :lantern_fishies

  def spawned; lantern_fishies; end

  def reset_simulation!
    @lantern_fishies = initial_state.map { |lantern_fish| LanternFish.new(spawns_in: lantern_fish) }
  end

  class LanternFish
    attr_reader :spawn_timer
    attr_reader :children

    def initialize(spawns_in: 8)
      @spawn_timer = spawns_in
      @children = []
    end

    def day_elapsed!
      children.each &:day_elapsed!
      if self.spawn_timer.zero?
        spawn!
        self.spawn_timer = 6
      else
        self.spawn_timer -=1
      end
    end

    include SpawnCounter
    def spawned; children; end

    def display_state
      [spawn_timer, *children.map(&:display_state) ]
    end

    private

    attr_writer :spawn_timer

    def spawn!
      self.children << self.class.new
    end
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result_at(Integer(ARGV[1]))
end
