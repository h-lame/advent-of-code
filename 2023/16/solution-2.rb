class Solution2
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp)
    end
  end

  class MirrorGrid
    def initialize(mirror_grid)
      @mirror_grid = mirror_grid
      @energized_grid = {}
      @bounds = [0...mirror_grid.first.size, 0...mirror_grid.size]
      @seen = {}
      @energy_count = {}
    end

    def render_energized(starting_at)
      energize_the_grid(starting_at) unless energized_grid.key? starting_at
      energized_grid[starting_at]
    end

    def render_best_possible
      best_possible
      x = energy_count.max_by { |k, v| v }
      puts "Best possible = #{x}"
      energized_grid[x.first]
    end

    def energized_count = energized_grid.map { |row| row.count '#' }.sum

    attr_reader :mirror_grid, :energized_grid, :bounds, :seen, :energy_count

    Beam = Data.define(:position, :direction) do
      def move(new_direction)
        Beam.new(
          position: case new_direction
                    in :east
                      [position.first+1, position.last]
                    in :west
                      [position.first-1, position.last]
                    in :north
                      [position.first, position.last-1]
                    in :south
                      [position.first, position.last+1]
                    end,
          direction: new_direction
        )
      end

      def oob?(bounds)
        !(bounds.first.cover?(position.first) && bounds.last.cover?(position.last))
      end
    end

    def energize_the_grid(starting_at)
      puts "****** Starting at: #{starting_at}"
      energized_grid[starting_at] = mirror_grid.size.times.map { '.' * mirror_grid.first.size }
      beams = [starting_at]
      seen[starting_at] = {}
      energy_count[starting_at] = 0
      loop do
        break if beams.empty?
        # puts "looking at #{beams}"
        beams.map! do |beam|
          # puts "Energizing #{beam.position}"
          energy_count[starting_at] += 1 if energize(starting_at, beam.position)
          if seen[starting_at].key?(beam)
            nil
          else
              # previously = seen[beam].max_by { |key, value| value }
              # diff = energy_count[starting_at] - previously.last
              # puts "Got to #{beam.position} which we saw before in #{previously}, we're at #{energy_count[starting_at]}, diff is #{diff}, previously finished at #{energy_count[previously.first]}, we'll finish at #{energy_count[previously.first] + diff}"
              # seen[beam][starting_at] = energy_count[starting_at]
              # energy_count[starting_at] = energy_count[previously.first] + diff
              # break
          #   end
          # else
            seen[starting_at][beam] = energy_count[starting_at]
            new_beams = [*interact_with_grid(beam)]
            new_beams.reject { |nb| nb.oob?(bounds) }
          end
        end
        beams.compact!
        beams.flatten!(1)
      end
    end

    def energize(starting_at, position)
      if energized_grid[starting_at][position.last][position.first] == '#'
        false
      else
        energized_grid[starting_at][position.last][position.first] = '#'
        true
      end
    end

    def interact_with_grid(beam)
      # puts "What do we do at #{beam.position} from #{beam.direction}? Via a #{mirror_grid[beam.position.last][beam.position.first]}"
      case mirror_grid[beam.position.last][beam.position.first]
      in '.'
        beam.move(beam.direction)
      in '-'
        case beam.direction
        in :east | :west
          beam.move(beam.direction)
        in :north | :south
          [beam.move(:east), beam.move(:west)]
        end
      in '|'
        case beam.direction
        in :east | :west
          [beam.move(:north), beam.move(:south)]
        in :north | :south
          beam.move(beam.direction)
        end
      in '/'
        case beam.direction
        in :east
          beam.move(:north)
        in :west
          beam.move(:south)
        in :north
          beam.move(:east)
        in :south
          beam.move(:west)
        end
      in '\\'
        case beam.direction
        in :east
          beam.move(:south)
        in :west
          beam.move(:north)
        in :north
          beam.move(:west)
        in :south
          beam.move(:east)
        end
      end
    end

    def best_possible
      [:east, :north, :west, :south].each do |direction|
        case direction
        in :east
          mirror_grid.size.times do |row|
            starting_at = Beam.new([0, row], direction)
            energize_the_grid(starting_at)
          end
        in :south
          mirror_grid.first.size.times do |col|
            starting_at = Beam.new([col, 0], direction)
            energize_the_grid(starting_at)
          end
        in :west
          last_col = mirror_grid.first.size - 1
          mirror_grid.size.times do |row|
            starting_at = Beam.new([last_col, row], direction)
            energize_the_grid(starting_at)
          end
        in :north
          last_row = mirror_grid.size - 1
          mirror_grid.first.size.times do |col|
            starting_at = Beam.new([col, last_row], direction)
            energize_the_grid(starting_at)
          end
        end
      end
      energy_count.values.max
    end
  end

  def initialize(raw_mirror_grid)
    @mirror_grid = MirrorGrid.new(raw_mirror_grid)
  end

  attr_reader :mirror_grid

  def result = mirror_grid.best_possible

end

if __FILE__ == $0
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
