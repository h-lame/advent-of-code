require 'set'

class Solution2
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp)
    end
  end

  class PathSegment
    def initialize(start_point, from, trail_map)
      @start_point = start_point
      @path_head = start_point
      @step_count = from.nil? ? 0 : 1
      @dead_end = false
      @visited = Set.new([ start_point, from ].compact)
      @finish_point = trail_map.finish_point
      walk_to_next_choice(trail_map)
    end

    def walk_to_next_choice(trail_map)
      choices = trail_map.potential_steps(self.path_head)
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
      self.path_head = new_position
      visited.add(new_position)
    end

    def to_s = %|<PathSegment f: #{start_point}, t: #{path_head}, sc: #{step_count}>|

    def eql?(other)
      if other.is_a? PathSegment
        self.start_point == other.start_point
      else
        false
      end
    end
    alias :== :eql?

    def done? = reached_finish? || dead_end?

    def reached_finish? = (finish_point == path_head)

    def dead_end? = @dead_end

    attr_reader :start_point, :path_head, :visited, :step_count, :finish_point
    alias :currently_at :path_head

    private

    attr_writer :dead_end, :step_count, :path_head
  end

  class Path
    def self.walked_path(start_point, finish_point, trail_map)
      Path.new(start_point, finish_point).tap do |p|
        choices = trail_map.junctions[p.currently_at]
        raise "Can't walk this path" if choices.size > 1
        p.add(choices.first)
      end
    end

    def initialize(start_point, finish_point)
      @start_point = start_point
      @finish_point = finish_point
      @currently_at = start_point
      @step_count = 0
      @visited = Set.new([ start_point ])
      @dead_end = false
      @terminated_early = false
      @choices = []
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

    def done? = reached_finish? || dead_end? || terminated_early?

    def reached_finish? = (finish_point == currently_at)

    def dead_end? = @dead_end

    def terminated_early? = @terminated_early

    def clone
      p = Path.new(self.start_point, self.finish_point)
      p.currently_at = self.currently_at
      p.step_count = self.step_count
      p.dead_end = self.dead_end?
      self.visited.each { |v| p.visited.add(v) }
      self.choices.each { |c| p.choices << c }
      p
    end

    def add(other_path)
      if other_path.is_a? PathSegment
        # other_path.visited.each { |v| self.visited.add(v) unless v.nil? }
        self.visited.add other_path.start_point
        self.visited.add other_path.path_head
        self.step_count += other_path.step_count
        self.currently_at = other_path.path_head
        self.dead_end = other_path.dead_end?
        self.choices << other_path
      end
    end

    def to_s = %|<Path f: #{start_point}, t: #{finish_point}, c: #{currently_at}, sc: #{step_count}, d:#{dead_end?}/#{terminated_early?}/#{reached_finish?}>|

    attr_reader :start_point, :finish_point, :currently_at, :step_count, :visited, :choices
    attr_writer :dead_end, :terminated_early

    protected

    attr_writer :step_count, :currently_at
  end

  class TrailMap
    SLOPES = ['^', '>', 'v', '<'].freeze
    WALKABLE = ['.', *SLOPES].freeze

    def initialize(trail_map: )
      @trail_map = trail_map
      @start_point = find_start
      @finish_point = find_finish
      @current_path = Path.new(start_point, finish_point)
      @paths = [current_path]
      @junctions = extract_junctions
      @seen = {}
      @max_path = nil
    end

    def extract_junctions
      junctions = []
      trail_map.each.with_index do |row, y|
        row.chars.each.with_index do |cell, x|
          next unless WALKABLE.include? cell

          point = [x,y]
          choices = potential_steps(point)
          junctions << [point, choices] if choices.size >= 3
        end
      end
      Hash[
        junctions.map { |j, cs|
          [j, cs.map { |c| PathSegment.new(c, j, self) }]
        }.map { |j, pss|
          if pss.any? { |ps| ps.path_head == finish_point }
            [j, pss.reject { |ps| ps.path_head != finish_point }]
          else
            [j, pss]
          end
        }
      ].tap do |j|
        j[start_point] = [PathSegment.new(start_point, nil, self)]
      end
    end

    def step
      self.current_path = paths.shift
      choices = junctions[current_path.currently_at]
          .reject { |c| current_path.visited.include? c.path_head }

      if choices.any?
        if choices.size == 1
          current_path.add(choices[0])
          if current_path.reached_finish?
            self.max = current_path if (max.nil? || (current_path.step_count > max.step_count))
            print "\rFound: #{current_path.step_count} / #{self.max.step_count}     "
          end
          paths << current_path unless current_path.done?
        else
          choices.map do |c|
            new_path = current_path.clone
            new_path.add(c)

            if new_path.reached_finish?
              self.max = new_path if (max.nil? || (new_path.step_count > max.step_count))
              print "\rFound: #{new_path.step_count} / #{self.max.step_count}     "
            else
              self.paths << new_path
            end
          end
        end
      else
        current_path.dead_end = true
      end
    end

    def to_graphviz
      junctions.map do |j|
        pos, choices = *j
        %|"#{pos.first},#{pos.last}" ; "#{pos.first},#{pos.last}" -> { #{choices.map { |c| "\"#{c.path_head.first},#{c.path_head.last}\"" }.join ' '} } |
      end.join("\n")
    end

    def graph(cost = 0, path = Path.new(start_point, finish_point))
      choices = []
      if path.reached_finish?
        choices = :goal
      else
        walk_choices = junctions[path.currently_at]
          .reject { |c| path.visited.include? c.path_head }

        if walk_choices.any?
          walk_choices.map do |c|
            new_path = path.clone
            new_path.add(c)
            choices << graph(new_path.step_count, new_path)
          end
        else
          choices = :dead_end
        end
      end

      [cost, path, choices]
    end

    def longest_hike
      self.max = nil
      until paths.empty?
        step
      end
      debug_render(max)
      max
    end

    def render(path = current_path)
      out = trail_map.map do |row|
        row.dup
      end
      path_segments = junctions.values.flatten(1)
      path.visited.each_cons(2) do |(start_point, end_point)|
        draw = path_segments.detect { |ps| (ps.start_point == start_point) && (ps.path_head == end_point) }
        if draw
          draw.visited.each do |step|
            out[step.last][step.first] = 'O'
          end
        end
      end
      junctions.fetch(path.currently_at, []).each do |potential_step|
        next if out[potential_step.start_point.last][potential_step.start_point.first] == 'O'
        out[potential_step.start_point.last][potential_step.start_point.first] = '?'
      end
      out[start_point.last][start_point.first] = 'S'
      out.join "\n"
    end

    attr_reader :trail_map, :paths, :start_point, :finish_point, :current_path, :junctions, :seen, :max

    def potential_steps(point)
      x, y = *point
      # puts "At #{point} (#{trail_map[y][x]})"
      # if SLOPES.include?(trail_map[y][x])
      #   o = SLOPES.index trail_map[y][x]
      #   m = case o
      #     in 0 | 2
      #       [[x, y-1], [x, y+1]]
      #     in 1 | 3
      #       [[x+1, y], [x-1, y]]
      #     end
      #   # puts " ------ sloping to: #{m}"
      #   m
      # else
        steps = []
        steps << [x, y-1] if y-1 >= 0 && WALKABLE.include?(trail_map[y-1][x])
        steps << [x+1, y] if x+1 < trail_map_width && WALKABLE.include?(trail_map[y][x+1])
        steps << [x, y+1] if y+1 < trail_map_height && WALKABLE.include?(trail_map[y+1][x])
        steps << [x-1, y] if x-1 >= 0 && WALKABLE.include?(trail_map[y][x-1])
        # puts "Options are #{steps}"
        steps
      # end
    end

    private

    attr_writer :step_count, :paths, :current_path, :max

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
    @trail_map = Solution2::TrailMap.new(trail_map: raw_trail_map)
  end

  attr_reader :trail_map

  def to_graphviz
    %|digraph { #{trail_map.to_graphviz} }|
  end

  def result
    trail_map.longest_hike.step_count
  end

  def pointify_graph(g)
    cost, path, choices = *g
    [
      cost,
      path.currently_at,
      if [:goal, :dead_end].include? choices
        choices
      else
        choices.map { |c| pointify_graph(c) }
      end
    ]
  end
end

if __FILE__ == $0
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
