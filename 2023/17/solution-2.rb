require 'set'

class Solution2
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

    def new_path_north(map, steps)
      return nil unless (y - steps) >= 0

      Path.new(
        [x, y - steps],
        1.upto(steps).reduce(heatloss) { |acc, i| map[y - i][x] + acc },
        steps,
        :north,
        route + [position, *(1.upto(steps - 1).map { |i| [x, y - i] })]
      )
    end

    def new_path_south(map, steps)
      return nil unless (y + steps) < map.size

      Path.new(
        [x, y + steps],
        1.upto(steps).reduce(heatloss) { |acc, i| map[y + i][x] + acc },
        steps,
        :south,
        route + [position, *(1.upto(steps - 1).map { |i| [x, y + i] })]
      )
    end

    def new_path_east(map, steps)
      return nil unless (x + steps) < map.first.size

      Path.new(
        [x + steps, y],
        1.upto(steps).reduce(heatloss) { |acc, i| map[y][x + i] + acc },
        steps,
        :east,
        route + [position, *(1.upto(steps - 1).map { |i| [x + i, y] })]
      )
    end

    def new_path_west(map, steps)
      return nil unless (x - steps) >= 0

      Path.new(
        [x - steps, y],
        1.upto(steps).reduce(heatloss) { |acc, i| map[y][x - i] + acc },
        steps,
        :west,
        route + [position, *(1.upto(steps - 1).map { |i| [x - i, y] })]
      )
    end

    def move_options_multi_step(map)
      return [] if position == [map.first.size-1][map.size-1]

      options = []
      if [:east, :west, nil].include? direction
        options += 4.upto(10).map { |i| new_path_north(map, i) }.compact

        options += 4.upto(10).map { |i| new_path_south(map, i) }.compact
      end
      if [:south, :north, nil].include? direction
        options += 4.upto(10).map { |i| new_path_east(map, i) }.compact

        options += 4.upto(10).map { |i| new_path_west(map, i) }.compact
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

        print "\rPaths: #{paths.size}, path: #{path}, seen: #{seen.size}/#{total}      " if !render
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
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
