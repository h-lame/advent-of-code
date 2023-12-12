class Solution2
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp)
    end
  end

  InvalidPipe = Class.new(StandardError)

  PipeLoop = Data.define(:pipe_map) do
    def initialize(pipe_map:)
      @s = detect_s(pipe_map)
      super
    end

    def pipe_loop
      pipe_loop = "#{s.first}"
      next_step = step(*s.last, first_step)
      while ((x, y = *next_step[0..1]) != s.last)
        puts "walking to #{next_step}: pipe_map(#{x},#{y}) (#{pipe_map[y][x]})"
        pipe_loop << pipe_map[y][x]
        next_step = step(*next_step)
        puts "now off to #{next_step}"
      end
      pipe_loop
    end

    def size
      pipe_loop.size
    end

    def render_pipe_loop
      ground = pipe_map.map { |_| '.' * pipe_map.first.size }
      ground[s.last.last][s.last.first] = s.first
      next_step = step(*s.last, first_step)
      while ((x, y = *next_step[0..1]) != s.last)
        puts "walking to #{next_step}"
        puts "replacing ground(#{x},#{y}) (#{ground[y][x]}) with pipe_map(#{x},#{y}) (#{pipe_map[y][x]})"
        ground[y][x] = pipe_map[y][x]
        next_step = step(*next_step)
        puts "now off to #{next_step}"
      end
      ground
    end

    def starting_pipe
      s.first
    end

    def inside_spaces
      inside = 0
      crossings = 0
      opening = []
      render_pipe_loop.each.with_index do |pipe_row, y|
        puts "looking at #{pipe_row} (i: #{inside}, c: #{crossings}, o: #{opening})"
        next unless pipe_row.include? '.'
        pipe_row.chars.each.with_index do |pipe, x|
          pipe = s.first if [x,y] == s.last
          puts "looking at #{pipe} (i: #{inside}, c: #{crossings}, o: #{opening})"
          case pipe
          in '-'
            next
          in '|'
            crossings += 1
          in 'F' | 'L'
            opening.push pipe
          in 'J' | '7'
            opener = opening.pop
            case [opener, pipe]
            in ['L', 'J'] | ['F','7']
              next
            else
              crossings += 1
            end
          in '.'
            inside += 1 if crossings.odd?
          end
        end
      end
      inside
    end
    attr_reader :s

    # | is a vertical pipe connecting north and south.
    # - is a horizontal pipe connecting east and west.
    # L is a 90-degree bend connecting north and east.
    # J is a 90-degree bend connecting north and west.
    # 7 is a 90-degree bend connecting south and west.
    # F is a 90-degree bend connecting south and east.
    # . is ground; there is no pipe in this tile.

    def first_step
      case s.first
      in '|' | 'L' | 'J'
        :n
      in '-' | 'F'
        :e
      in '7'
        :w
      end
    end

    def step(x, y, entered_from)
      pipe = [x,y] == s.last ? s.first : pipe_map[y][x]
      case [entered_from, pipe]
      in [_, '.']
        raise InvalidPipe, "Can't walk through ground at [#{x}, #{y}]"

      in [:n, '|']
        [x, y+1, :n]
      in [:n, 'L']
        [x+1, y, :w]
      in [:n, 'J']
        [x-1, y, :e]

      in [:s, '|']
        [x, y-1, :s]
      in [:s, '7']
        [x-1, y, :e]
      in [:s, 'F']
        [x+1, y, :w]

      in [:w, '-']
        [x+1, y, :w]
      in [:w, '7']
        [x, y+1, :n]
      in [:w, 'J']
        [x, y-1, :s]

      in [:e, '-']
        [x-1, y, :e]
      in [:e, 'L']
        [x, y-1, :s]
      in [:e, 'F']
        [x, y+1, :n]

      else
        raise InvalidPipe, "Can't walk through pipe #{pipe} from #{entered_from}"
      end
    end

    def detect_s(pipe_map)
      s_line, s_y = pipe_map.each.with_index.detect { |x, _idx| x.include? 'S' }
      raise InvalidPipe, 'no S' if s_line.nil?

      s_x = s_line.index 'S'
      n = s_y.zero? ? nil : pipe_map[s_y - 1][s_x]
      e = pipe_map[s_y][s_x + 1]
      s = (pipe_map[s_y + 1]||[])[s_x]
      w = s_x.zero? ? nil : pipe_map[s_y][s_x - 1]
      s_pipe = case [n, e, s, w]
      in ['|' | 'F' | '7', _, '|' | 'L' | 'J', _]
        '|'
      in [_, '-' | 'J' | '7', _, '-' | 'L' | 'F']
        '-'
      in ['|' | 'F' | '7', '-' | 'J' | '7', _, _]
        'L'
      in ['|' | 'F' | '7', _, _, '-' | 'L' | 'F']
        'J'
      in [_, _, '|' | 'L' | 'J', '-' | 'L' | 'F']
        '7'
      in [_, '-' | 'J' | '7', '|' | 'L' | 'J', _]
        'F'
      else
        raise InvalidPipe, "cannot work out S from #{[n, e, s, w]}"
      end

      [s_pipe, [s_x, s_y]]
    end
  end

  def initialize(pipe_loop)
    @raw_pipe_loop = pipe_loop
  end

  def result = prepared_pipe_loop.size / 2

  def render = prepared_pipe_loop.render_pipe_loop

  def inside_spaces = prepared_pipe_loop.inside_spaces

  private

  attr_reader :raw_pipe_loop

  def prepared_pipe_loop = PipeLoop.new raw_pipe_loop

end

if __FILE__ == $0
  solution = Solution2.new(Solution2::Normalizer.do_it(ARGV[0]))
  puts solution.render
  puts solution.inside_spaces
end
