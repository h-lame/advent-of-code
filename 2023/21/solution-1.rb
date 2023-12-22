require 'set'

class Solution1
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp)
    end
  end

  class Garden
    def initialize(garden: )
      @garden = garden
      start = find_start
      @garden[start.last][start.first] = '.'
      @paths = Set.new([start])
      @step_count = 0
    end

    def step(steps = 1)
      steps.times do
        puts "Step: #{step_count}, paths: #{paths}\n"
        debug_render
        self.step_count += 1
        new_paths = Set.new
        paths.each do |path|
          new_paths += potential_steps(path)
        end
        self.paths = new_paths
      end
      puts "Step: #{step_count}, paths: #{paths}\n"
      debug_render
    end

    def render
      out = garden.map do |row|
        row.dup
      end
      paths.each do |path|
        out[path.last][path.first] = 'O'
      end
      out.join "\n"
    end

    def plots_reachable = paths.size

    attr_reader :garden, :paths, :step_count

    private

    attr_writer :step_count, :paths

    def debug_render
      puts "\e[2J\e[f"
      puts render

      sleep 0.1
    end


    def garden_width = garden.first.size

    def garden_height = garden.size

    def find_start
      garden.lazy.with_index.map { |row, idx| [row.index('S'), idx] }.detect { |(x, y)| x }
    end

    def potential_steps(point)
      x, y = *point
      steps = []
      steps << [x, y-1] if y-1 >= 0 && garden[y-1][x] == '.'
      steps << [x+1, y] if x+1 < garden_width && garden[y][x+1] == '.'
      steps << [x, y+1] if y+1 < garden_height && garden[y+1][x] == '.'
      steps << [x-1, y] if x-1 >= 0 && garden[y][x-1] == '.'
      steps
    end

  end

  def initialize(raw_garden)
    @garden = Solution1::Garden.new(garden: raw_garden)
  end

  attr_reader :garden

  def result(steps)
    garden.step(steps)
    garden.plots_reachable
  end
end

if __FILE__ == $0
  puts Solution1.new(Solution1::Normalizer.do_it(ARGV[0])).result((ARGV[1] || '64').to_i)
end
