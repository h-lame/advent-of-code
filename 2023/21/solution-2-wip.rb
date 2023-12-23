require 'set'

class Solution2
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp)
    end
  end

  GardenPlot = Data.define(:x, :y, :step_count) do
    def eql?(other)
      case other
      in GardenPlot
        pos == other.pos
      in [Integer, Integer]
        pos == other
      else
        false
      end
    end
    alias :== :eql?

    def hash = pos.hash

    def odd? = step_count.odd?

    def even? = step_count.even?

    def pos = [self.x, self.y]
  end

  class FiniteGarden
    def initialize(garden: , start: )
      @garden = garden
      @start = start
      @garden[start.last][start.first] = '.'
      @odd_paths = Set.new []
      @even_paths = Set.new [GardenPlot.new(x: start.first, y: start.last, step_count: 0)]
      @step_count = 0
    end

    def paths = odd_paths + even_paths

    def step_to_all
      edges = paths
      loop do
        edges = step(edges)
        puts "Paths = #{paths.size} / All = #{all_plots_size}"
        break if paths.size == all_plots_size
      end
    end

    def all_plots_size
      garden.map { |row| row.count('.') }.sum
    end

    def step(edges = nil)
      edges = (step_count.odd? ? odd_paths : even_paths) if edges.nil?
      # puts "Step: #{step_count+1}, from: #{edges}\n"
      self.step_count += 1
      new_paths = Set.new
      edges.each do |path|
        new_paths += potential_steps(path)
      end
      step_count.odd? ? self.odd_paths += new_paths : self.even_paths += new_paths
      # debug_render(new_paths)
      new_paths
    end

    def render(edges = nil)
      edges = (step_count.odd? ? odd_paths : even_paths) if edges.nil?
      out = garden.map do |row|
        row.dup
      end
      edges.each do |path|
        out[path.y][path.x] = 'O'
      end
      out.join "\n"
    end

    def plots_reachable = step_count.odd? ? odd_paths.size : even_paths.size

    attr_reader :garden, :odd_paths, :even_paths, :step_count

    private

    attr_writer :step_count, :odd_paths, :even_paths

    def debug_render(edges = paths)
      puts "\e[2J\e[f"
      puts render(edges)

      sleep 0.1
    end

    def garden_width = garden.first.size

    def garden_height = garden.size

    def potential_steps(plot)
      steps = []
      steps << Solution2::GardenPlot.new(x: plot.x, y: plot.y-1, step_count: self.step_count) if plot.y-1 >= 0 && garden[plot.y-1][plot.x] == '.'
      steps << Solution2::GardenPlot.new(x: plot.x+1, y: plot.y, step_count: self.step_count) if plot.x+1 < garden_width && garden[plot.y][plot.x+1] == '.'
      steps << Solution2::GardenPlot.new(x: plot.x, y: plot.y+1, step_count: self.step_count) if plot.y+1 < garden_height && garden[plot.y+1][plot.x] == '.'
      steps << Solution2::GardenPlot.new(x: plot.x-1, y: plot.y, step_count: self.step_count) if plot.x-1 >= 0 && garden[plot.y][plot.x-1] == '.'
      steps
    end
  end

  class InfiniteGarden
    def initialize(garden: )
      start = find_start(garden)
      @c_garden = Solution2::FiniteGarden.new(garden: garden, start: start)

      width = @c_garden.garden_width
      height = @c_garden.garden_height

      @n_garden = Solution2::FiniteGarden.new(garden: garden, start: [start.first, 0])
      @e_garden = Solution2::FiniteGarden.new(garden: garden, start: [width-1, start.last])
      @s_garden = Solution2::FiniteGarden.new(garden: garden, start: [start.first, height-1])
      @w_garden = Solution2::FiniteGarden.new(garden: garden, start: [0, start.last])

      @ne_garden = Solution2::FiniteGarden.new(garden: garden, start: [width-1,0])
      @nw_garden = Solution2::FiniteGarden.new(garden: garden, start: [0,0])
      @se_garden = Solution2::FiniteGarden.new(garden: garden, start: [width-1,height-1])
      @sw_garden = Solution2::FiniteGarden.new(garden: garden, start: [0, height-1])
    end

    def plots_reachable_in(steps)

    end

    private

    def find_start(garden)
      garden.lazy.with_index.map { |row, idx| [row.index('S'), idx] }.detect { |(x, y)| x }
    end
  end

  def initialize(raw_garden)
    @garden = Solution2::InfiniteGarden.new(garden: raw_garden)
  end

  attr_reader :garden

  def result(steps)
    garden.plots_reachable_in(steps)
  end
end

if __FILE__ == $0
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result((ARGV[1] || '64').to_i)
end
