require 'set'

class Solution2BF
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp)
    end
  end

  class Garden
    def initialize(garden:, steps:)
      original_start = find_start(garden)
      @original_garden = garden
      raise "not starting in the middle" if (original_start.last != (garden.size / 2)) || (original_start.first != (garden.first.size / 2))
      garden[original_start.last][original_start.first] = '.'
      @garden = scale_garden(garden, steps)
      @paths = Set.new([[garden_width/2, garden_height / 2]])
      @step_count = 0
      @steps = steps
    end

    def step_to_all
      #puts "Step: #{step_count}, paths: #{paths.size}\n"
      # debug_render
      steps.times do
        step
        if step_count <= (original_garden.size / 2)
          puts "Step: #{step_count}, in first copy"
        else
          past_first_copy = step_count - (original_garden.size / 2)
          how_many = (past_first_copy / original_garden.size)
          how_many += 2
          puts "Step: #{step_count}, in copy #{how_many}"
        end
        #debug_render
      end
    end

    def step
      self.step_count += 1
      new_paths = Set.new
      paths.each do |path|
        new_paths += potential_steps(path)
      end
      self.paths = new_paths
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

    attr_reader :garden, :paths, :step_count, :steps, :original_garden

    private

    attr_writer :step_count, :paths

    def debug_render
      puts "\e[2J\e[f"
      puts render

      #sleep 0.1
    end

    def scale_garden(garden, steps)
      gw = garden.first.size
      if steps > (gw/2)
        outside_first_box_steps = steps - (gw/2)
        scale_factor = outside_first_box_steps / gw
        scale_factor += 1 unless (outside_first_box_steps % gw) == 0
        puts "Raw: #{scale_factor}, copies: #{(2*scale_factor) + 1}"
        copies = (2*scale_factor) + 1
        garden = garden.map { |row| row * copies } * copies
      end
      garden
    end

    def garden_width = garden.first.size

    def garden_height = garden.size

    def find_start(garden)
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

  def initialize(raw_garden, steps)
    @garden = Solution2BF::Garden.new(garden: raw_garden, steps: steps)
  end

  attr_reader :garden

  def result
    garden.step_to_all
    garden.plots_reachable
  end
end

if __FILE__ == $0
  puts Solution2BF.new(Solution2BF::Normalizer.do_it(ARGV[0]), (ARGV[1] || '64').to_i).result
end
