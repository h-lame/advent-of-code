require 'set'

class Solution1
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name)
        .map(&:chomp)
        .map do |row|
          /(?<direction>R|D|U|L)\s+(?<distance>\d+)\s+\((?<colour>\#[0-9a-f]{6})\)/ =~ row
          [direction, distance.to_i, colour]
        end
    end
  end

  class Digger
    def initialize
      @world = ['.']
      @position = [0,0]
    end

    attr_reader :world, :position

    def dig_lagoon(digger_instructions)
      digger_instructions.each.with_index do |digger_instruction, idx|
        process_instruction(digger_instruction)
        binding.irb if world.map { |row| row.size }.uniq.size != 1
        # binding.irb if digger_instruction[0] == 'U' && digger_instruction[1] == 3
        #debug_render
      end
      puts render_lagoon
      puts '---'
      dig_out
      puts render_lagoon
    end

    def lagoon_size = world.map { |row| row.count('#') }.sum

    def process_instruction(digger_instruction)
      direction, distance, _colour = *digger_instruction
      new_position =
        case direction
        when 'R'
          [position.first + distance, position.last]
        when 'U'
          [position.first, position.last - distance]
        when 'L'
          [position.first - distance, position.last]
        when 'D'
          [position.first, position.last + distance]
        end
      new_position, old_position = *expand_world(new_position)
      dig(old_position, new_position, direction)
      self.position = new_position
    end

    def expand_world(new_position)
      new_x, new_y = *new_position
      old_x, old_y = *position

      # puts "Expanding world to cope with #{new_position}(#{position}): \n#{render_lagoon}"

      width = world.first.size
      height = world.size

      if new_x < 0
        # puts "prepend #{new_x.abs} cols as #{'.' * new_x.abs} at the start of each #{height} row"
        @world = world.map!.with_index { |row, idx| "#{'.' * new_x.abs}#{row}" }
        old_x = (old_x + new_x.abs)
        new_x = 0
      elsif new_x >= width
        # puts "append #{new_x - width + 1} cols as #{'.' * (new_x - width + 1)}  at the end of each #{height} row"
        @world = world.map!.with_index { |row, idx| "#{row}#{'.' * (new_x - width + 1)}" }
      else
        # puts "no need in x"
      end

      if new_y < 0
        # puts "prepend #{new_y.abs} rows of #{'.' * width}"
        new_y.abs.times do
          world.unshift('.' * width)
        end
        old_y = (old_y + new_y.abs)
        new_y = 0
      elsif new_y >= height
        # puts "append #{height - new_y + 1} rows of #{'.' * width}"
        (new_y - world.size + 1).times do
          world << ('.' * width)
        end
      else
        # puts "no need in y"
      end

      # puts "World now: \n#{render_lagoon}"
      [[new_x, new_y], [old_x, old_y]]
    end

    def dig(from, to, direction)
      # puts "Dig from #{from} to #{to} in #{direction}"
      case direction
      when 'R'
        from.first.upto(to.first) { |pox| world[from.last][pox] = '#' }
      when 'L'
        from.first.downto(to.first) { |pox| world[from.last][pox] = '#' }
      when 'U'
        from.last.downto(to.last) { |poy| world[poy][from.first] = '#' }
      when 'D'
        from.last.upto(to.last) { |poy| world[poy][from.first] = '#' }
      end
    end

    def dig_out
      @world =
        self.world.map.with_index do |row, y|
          crossings = 0
          prev = nil
          opening = nil
          row.each_char.with_index.map do |char, x|
            if char == '#'
              crossing = []
              crossing <<
                if y-1 < 0
                  '.'
                else
                  world[y-1][x]
                end
              crossing << char
              crossing <<
                if y + 1 >= world.size
                  '.'
                else
                  world[y+1][x]
                end
            else
              crossing = []
            end
            if crossing == ['#','#','#']
              crossings += 1
            elsif crossing == ['#','#','.'] # L | J
              if opening.nil?
                opening = crossing
              elsif opening == ['.','#','#']
                opening = nil
                crossings += 1
              elsif opening == ['#','#','.']
                opening = nil
              end
            elsif crossing == ['.','#','#'] # F | 7
              if opening.nil?
                opening = crossing
              elsif opening == ['.','#','#']
                opening = nil
              elsif opening == ['#','#','.']
                opening = nil
                crossings += 1
              end
            end

            if char == '.' && crossings.odd?
              '#'
            else
              char
            end
          end.join
        end
    end

    def render_lagoon
      world.join("\n")
    end

    def debug_render
      puts "\e[2J\e[f"
      puts render_lagoon

      sleep 0.1
    end

    private
    attr_writer :position
  end

  def initialize(digger_instructions)
    @digger_instructions = digger_instructions
  end

  attr_reader :digger_instructions

  def result
    digger = Digger.new
    digger.dig_lagoon(digger_instructions)
    digger.lagoon_size
  end
end

if __FILE__ == $0
  puts Solution1.new(Solution1::Normalizer.do_it(ARGV[0])).result
end
