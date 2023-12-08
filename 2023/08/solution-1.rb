class Solution1
  class Normalizer
    def self.do_it(file_name)
      lines = File.readlines(file_name).map(&:chomp)
      instructions = lines.shift
      _ = lines.shift
      lines = lines.map do |line|
        position, choices = *line.split(/\s+=\s+/)
        left, right = *choices.scan(/[A-Z]{3}/)
        [position, [left, right]]
      end
      [instructions, Hash[lines]]
    end
  end

  StuckError = Class.new(StandardError)
  Map = Struct.new(:instructions, :nodes) do
    def initialize(instructions:, nodes:)
      @position = 'AAA'
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

    def done? = position == 'ZZZ'

    def self.from_raw(raw_map) = new(instructions: raw_map[0], nodes: raw_map[1])
  end

  def initialize(map)
    @map = Map.from_raw(map)
  end

  def result
    map.autowalk
    map.step_count
  end

  private

  attr_reader :map

end

if __FILE__ == $0
  puts Solution1.new(Solution1::Normalizer.do_it(ARGV[0])).result
end
