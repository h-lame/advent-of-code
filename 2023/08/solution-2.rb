class Solution2
  class Normalizer
    def self.do_it(file_name)
      lines = File.readlines(file_name).map(&:chomp)
      instructions = lines.shift
      _ = lines.shift
      lines = lines.map do |line|
        position, choices = *line.split(/\s+=\s+/)
        left, right = *choices.scan(/[0-9A-Z]{3}/)
        [position, [left, right]]
      end
      [instructions, Hash[lines]]
    end
  end

  StuckError = Class.new(StandardError)
  MultiMap = Struct.new(:instructions, :nodes) do
    def initialize(instructions:, nodes:)
      @positions = find_starting_points nodes
      @end_state = find_ending_points nodes
      @step_count = 0
      super
    end

    attr_reader :positions, :step_count, :end_state

    def move(step)
      step = (step == 'L' ? 0 : 1)
      @step_count += 1
      @positions = positions.map { |p| nodes[p][step] }
    end

    def autowalk(steps = instructions)
      while !done?
        steps.chars.each do |step|
          move(step)
          break if done?
          raise StuckError if stuck?
        end
      end
    end

    def choices = Hash[positions.map { |p| [p, nodes[p]] }]

    def stuck?
      positions.any? do |p|
        (p == nodes[p][0]) && (p == nodes[p][1])
      end
    end

    def done? = positions.sort == end_state.sort

    def self.from_raw(raw_map) = new(instructions: raw_map[0], nodes: raw_map[1])

    def find_starting_points(nodes)
      nodes.keys.select { |k| k[-1] == 'A' }
    end

    def find_ending_points(nodes)
      nodes.keys.select { |k| k[-1] == 'Z' }
    end
  end

  Map = Struct.new(:instructions, :nodes, :starting) do
    def initialize(instructions:, nodes:, starting:)
      @position = starting
      @step_count = 0
      super
    end

    attr_reader :position, :step_count

    def move(step)
      step = (step == 'L' ? 0 : 1)
      @step_count += 1
      @position = nodes[position][step]
    end

    def autowalk(steps = instructions)
      while !done?
        steps.chars.each do |step|
          move(step)
          break if done?
          raise StuckError if stuck?
        end
      end
    end

    def choices = nodes[position]

    def stuck? = (position == nodes[position][0]) && (position == nodes[position][1])

    def done? = position[-1] == 'Z'

    def self.from_raw(raw_map, starting) = new(instructions: raw_map[0], nodes: raw_map[1], starting:)
  end

  def initialize(map)
    @starters = map[1].keys.select { |k| k[-1] == 'A' }
    @maps = @starters.map { |starter| Map.from_raw(map, starter) }
  end

  def multimap_result
    map = Map.from_raw(map)
    map.autowalk
    map.step_count
  end

  def result
    maps.map { |map| map.autowalk; map.step_count }.reduce :lcm
  end

  private

  attr_reader :maps

end

if __FILE__ == $0
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
