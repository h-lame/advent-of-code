class Solution1
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp)
    end
  end

  class MirrorGrid
    def initialize(mirror_grid)
      @mirror_grid = mirror_grid
      @energized_grid = mirror_grid.size.times.map { '.' * mirror_grid.first.size }
      @bounds = [0...mirror_grid.first.size, 0...mirror_grid.size]
      energize_the_grid
    end

    def render_energized
      energized_grid
    end

    def energized_count = energized_grid.map { |row| row.count '#' }.sum

    attr_reader :mirror_grid, :energized_grid, :bounds

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

    def energize_the_grid
      beams = [Beam.new([0,0], :east)]
      seen = {}
      loop do
        break if beams.empty?
        puts "looking at #{beams}"
        beams.map! do |beam|
          seen[beam] = 1
          puts "Energizing #{beam.position}"
          energize(beam.position)
          new_beams = [*interact_with_grid(beam)]
          new_beams.reject { |nb| nb.oob?(bounds) || seen.key?(nb) }
        end.flatten!(1)
      end
    end

    def energize(position)
      energized_grid[position.last][position.first] = '#'
    end

    def interact_with_grid(beam)
      puts "What do we do at #{beam.position} from #{beam.direction}? Via a #{mirror_grid[beam.position.last][beam.position.first]}"
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

  end

  def initialize(raw_mirror_grid)
    @mirror_grid = MirrorGrid.new(raw_mirror_grid)
  end

  attr_reader :mirror_grid

  def result = mirror_grid.energized_count

end

if __FILE__ == $0
  puts Solution1.new(Solution1::Normalizer.do_it(ARGV[0])).result
end
