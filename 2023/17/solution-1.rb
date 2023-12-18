require 'set'

class Solution1
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp).map { |row| row.chars.map &:to_i }
    end
  end

  Path = Data.define(:position, :heatloss, :steps, :direction, :route) do

    def x = position.first

    def y = position.last

    def to_s = "<Path @#{position}, d=#{direction}(#{steps}), hl=#{heatloss}, r=#{route.size}>"

    def inspect = to_s

    def move_options_single_step(map)
      return [] if position == [map.first.size-1][map.size-1]

      options = [].tap do |options|
        e_steps = (direction == :east) ? (steps + 1) : 1
        s_steps = (direction == :south) ? (steps + 1) : 1
        w_steps = (direction == :west) ? (steps + 1) : 1
        n_steps = (direction == :north) ? (steps + 1) : 1

        if (x+1 < map.first.size) && (e_steps <= 3) && (direction != :west)
          options << Path.new(
            [x+1,y],
            heatloss + map[y][x+1],
            e_steps,
            :east,
            route + [position]
          )
        end
        if (y+1 < map.size) && (s_steps <= 3) && (direction != :north)
          options << Path.new(
            [x,y+1],
            heatloss + map[y+1][x],
            s_steps,
            :south,
            route + [position]
          )
        end
        if (x-1 >= 0) && (w_steps <= 3) && (direction != :east)
          options << Path.new(
            [x-1,y],
            heatloss + map[y][x-1],
            w_steps,
            :west,
            route + [position]
          )
        end
        if (y-1 >= 0) && (n_steps <= 3) && (direction != :south)
          options << Path.new(
            [x,y-1],
            heatloss + map[y-1][x],
            n_steps,
            :north,
            route + [position]
          )
        end
      end

      options
    end

    def move_options_multi_step(map)
      return [] if position == [map.first.size-1][map.size-1]

      options = [].tap do |options|
        if [:east, :west, nil].include? direction
          options << Path.new(
            [x, y-1],
            heatloss + map[y-1][x],
            1,
            :north,
            route + [position]
          ) if y-1 >= 0
          options << Path.new(
            [x, y-2],
            heatloss + map[y-1][x] + map[y-2][x],
            2,
            :north,
            route + [position, [x, y-1]]
          ) if y-2 >= 0
          options << Path.new(
            [x, y-3],
            heatloss + map[y-1][x] + map[y-2][x] + map[y-3][x],
            3,
            :north,
            route + [position, [x, y-1], [x, y-2]]
          ) if y-3 >= 0
          options << Path.new(
            [x, y+1],
            heatloss + map[y+1][x],
            1,
            :south,
            route + [position]
          ) if y+1 < map.size
          options << Path.new(
            [x, y+2],
            heatloss + map[y+1][x] + map[y+2][x],
            2,
            :south,
            route + [position, [x, y+1]]
          ) if y+2 < map.size
          options << Path.new(
            [x, y+3],
            heatloss + map[y+1][x] + map[y+2][x] + map[y+3][x],
            3,
            :south,
            route + [position, [x, y+1], [x, y+2]]
          ) if y+3 < map.size
        end
        if [:south, :north, nil].include? direction
          options << Path.new(
            [x+1, y],
            heatloss + map[y][x+1],
            1,
            :east,
            route + [position]
          ) if x+1 < map.first.size
          options << Path.new(
            [x+2, y],
            heatloss + map[y][x+1] + map[y][x+2],
            2,
            :east,
            route + [position, [x+1, y]]
          ) if x+2 < map.first.size
          options << Path.new(
            [x+3, y],
            heatloss + map[y][x+1] + map[y][x+2] + map[y][x+3],
            3,
            :east,
            route + [position, [x+1, y], [x+2, y]]
          ) if x+3 < map.first.size
          options << Path.new(
            [x-1, y],
            heatloss + map[y][x-1],
            1,
            :west,
            route + [position]
          ) if x-1 >= 0
          options << Path.new(
            [x-2, y],
            heatloss + map[y][x-1] + map[y][x-2],
            2,
            :west,
            route + [position, [x-1, y]]
          ) if x-2 >= 0
          options << Path.new(
            [x-3, y],
            heatloss + map[y][x-1] + map[y][x-2] + map[y][x-3],
            3,
            :west,
            route + [position, [x-1, y], [x-2, y]]
          ) if x-3 >= 0
        end
      end

      # puts "What about: #{options}"
      options
    end
    alias :move_options :move_options_multi_step

    def render_route(map)
      tiles = map.map do |row|
        row.map do |cell|
          cell.to_s
        end
      end
      route.each do |visited|
        tiles[visited.last][visited.first] = 'x'
      end
      tiles[y][x] = '*'
      tiles.map { |r| r.join }.join("\n")
    end

    def <=>(other)
      raise ArgumentError unless other.is_a? Path

      [heatloss, steps, route.size] <=> [other.heatloss, other.steps, other.route.size]
    end
  end

  class HeatlossMap
    def initialize(map)
      @map = map
    end

    def minimal_heatloss_route(render: false)
      paths = []
      paths << Path.new([0,0], 0, 0, nil, [])

      seen = Set.new

      end_at = [map.first.size-1, map.size-1]
      total = map.size * map.first.size * 4
      found = nil
      while paths.any?
        puts "\e[2J\e[f" if render
        paths.sort!
        puts "Paths: = #{paths.size}" if render

        path = paths.shift
        # we don't add things if we've seen them, but they could already be in the list and we haven't gotten to them
        while seen.include?([path.position, path.direction]) #, path.steps])
          path = paths.shift
        end
        # binding.irb if path.position == [1,2]
        puts "Path : = #{path}" if render

        print "\rPaths: #{paths.size}, path: #{path}, seen: #{seen.size}/#{total}" if !render
        seen.add [path.position, path.direction] #, path.steps]

        if path.position == end_at
          found = path
          break
        end

        path.move_options(map).each do |new_option|
          unless seen.include?([new_option.position, new_option.direction]) #, new_option.steps])
            paths << new_option
          end
        end

        debug_render(path, paths, seen) if render
      end
      puts "\n\nFound: Heatloss = #{found.heatloss}"

      puts path.render_route(map)
      found
    end

    attr_reader :map
  end

  def debug_render(path, seen)
    tiles = map.map do |row|
      row.map do |cell|
        [cell.to_s, '.']
      end
    end
    seen.map do |entry|
      pos, _dir, _steps = *entry
      tiles[pos.last][pos.first][-1] = 'x'
    end
    paths.map do |p|
      tiles[p.y][p.x][-1] = '?'
    end
    tiles[path.y][path.x][-1] = 'O'
    puts "Looking at #{path.position} - trying to get to #{end_at}"
    puts tiles.map { |r| r.join }.join("\n")

    sleep 0.1
  end

  def initialize(raw_heatloss_map)
    @heatloss_map = HeatlossMap.new(raw_heatloss_map)
  end

  attr_reader :heatloss_map

  def result = heatloss_map.minimal_heatloss_route.heatloss

end

if __FILE__ == $0
  puts Solution1.new(Solution1::Normalizer.do_it(ARGV[0])).result
end
