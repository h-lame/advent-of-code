require 'set'

class Solution1
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp)
    end
  end

  class Path
    def initialize(start_point, finish_point)
      @start_point = start_point
      @finish_point = finish_point
      @currently_at = start_point
      @step_count = 0
      @visited = Set.new([ start_point ])
      @dead_end = false
      @choices = []
    end

    def walk_to_next_choice(trail_map)
      return [] if done?

      self.choices = trail_map.potential_steps(currently_at)
      choices.reject! { |c| visited.include? c }
      if choices.size == 0
        self.dead_end = true
        return []
      elsif choices.size == 1
        step_to(choices.first)
        return walk_to_next_choice(trail_map)
      else
        return choices
      end
    end

    def step_to(new_position)
      self.step_count += 1
      self.currently_at = new_position
      visited.add(new_position)
    end

    def <=>(other)
      if other.is_a? Path
        self.step_count <=> other.step_count
      else
        -1
      end
    end

    def done? = (finish_point == currently_at) || dead_end?

    def dead_end? = @dead_end

    def clone
      p = Path.new(self.start_point, self.finish_point)
      p.currently_at = self.currently_at
      p.step_count = self.step_count
      p.dead_end = self.dead_end?
      self.visited.each { |v| p.visited.add(v) }
      p
    end

    def to_s = %|<Path f: #{start_point}, t: #{finish_point}, c: #{currently_at}, sc: #{step_count}, v: #{visited}>|

    attr_reader :start_point, :finish_point, :currently_at, :step_count, :visited, :choices

    protected

    attr_writer :step_count, :currently_at, :dead_end, :choices


  end

  class TrailMap
    SLOPES = ['^', '>', 'v', '<'].freeze
    WALKABLE = ['.', *SLOPES].freeze

    def initialize(trail_map: )
      @trail_map = trail_map
      @start_point = find_start
      @finish_point = find_finish
      @trail_map[start_point.last][start_point.first] = 'S'
      @current_path = Path.new(start_point, finish_point)
      @paths = Set.new([@current_path])
    end

    def step
      current_path = paths.sort.reverse.detect { |x| !x.done? }
      debug_render(current_path)
      choices = current_path.walk_to_next_choice(self)
      # puts "Choices: #{choices}"
      if choices.size > 1
        paths.delete(current_path)
        choices.each { |c| np = current_path.clone; np.step_to(c); paths.add(np) }
      end
    end

    def longest_hike
      loop do
        step
        break if paths.all?(&:done?)
      end
      debug_render(current_path)
      x = paths.sort.last
      debug_render(x)
      x
    end

    def render(path = current_path)
      out = trail_map.map do |row|
        row.dup
      end
      path.visited.each do |step|
        out[step.last][step.first] = 'O'
      end
      path.choices.each do |potential_step|
        out[potential_step.last][potential_step.first] = '?'
      end
      out[start_point.last][start_point.first] = 'S'
      out.join "\n"
    end

    attr_reader :trail_map, :paths, :start_point, :finish_point, :current_path

    def potential_steps(point)
      x, y = *point
      # puts "At #{point} (#{trail_map[y][x]})"
      if SLOPES.include?(trail_map[y][x])
        o = SLOPES.index trail_map[y][x]
        m = if o == 0
          [x, y-1]
        elsif o ==  1
          [x+1, y]
        elsif o == 2
          [x, y+1]
        elsif o == 3
          [x-1, y]
        end
        # puts " ------ sloping to: #{m}"
        [m]
      else
        steps = []
        steps << [x, y-1] if y-1 >= 0 && WALKABLE.include?(trail_map[y-1][x])
        steps << [x+1, y] if x+1 < trail_map_width && WALKABLE.include?(trail_map[y][x+1])
        steps << [x, y+1] if y+1 < trail_map_height && WALKABLE.include?(trail_map[y+1][x])
        steps << [x-1, y] if x-1 >= 0 && WALKABLE.include?(trail_map[y][x-1])
        # puts "Options are #{steps}"
        steps
      end
    end

    private

    attr_writer :step_count, :paths, :current_path

    def debug_render(path = current_path)
      puts "\e[2J\e[f"
      puts render(path)

      sleep 0.05
    end

    def trail_map_width = trail_map.first.size

    def trail_map_height = trail_map.size

    def find_start
      [trail_map[0].index('.'), 0]
    end

    def find_finish
      [trail_map[-1].index('.'), trail_map_height-1]
    end
  end

  def initialize(raw_trail_map)
    @trail_map = Solution1::TrailMap.new(trail_map: raw_trail_map)
  end

  attr_reader :trail_map

  def result
    trail_map.longest_hike.step_count
  end
end

if __FILE__ == $0
  puts Solution1.new(Solution1::Normalizer.do_it(ARGV[0])).result
end
