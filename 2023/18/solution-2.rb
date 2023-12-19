require 'set'

class Solution2
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
      @position = [0,0]
    end

    attr_reader :world, :position, :lagoon_size

    def dig_lagoon(digger_instructions)
      first_row = position
      previous_row = position
      sums = 0
      sums_2 = 0
      perimeter = 0
      digger_instructions.each.with_index do |digger_instruction, idx|
        process_instruction(digger_instruction)
        cur_x, cur_y = *position
        prev_x, prev_y = *previous_row
        z = (prev_x*cur_y) - (cur_x*prev_y)
        sums += z
        z_2 = (cur_x - prev_x) * (cur_y + prev_y)
        sums_2 += z_2
        puts "Calc: #{position} x #{previous_row}, z = #{z}, s = #{sums / 2} / z2= #{z_2}, s2 = #{sums_2 / 2}"

        previous_row = position

        _direction, distance = *self.class.convert_instruction(digger_instruction)
        perimeter += distance.abs
      end

      @lagoon_size = (((sums).abs + perimeter) / 2) + 1
    end

    def self.convert_instruction(digger_instruction)
      _direction, _distance, colour = *digger_instruction
      distance_hex = colour[1..5]
      direction_hex = colour[6]
      direction =
        case direction_hex.to_i(16)
        when 0 then 'R'
        when 1 then 'D'
        when 2 then 'L'
        when 3 then 'U'
        else
          raise "arg, got #{direction_hex} but it's not 0-3 (from #{colour})"
        end
      [direction, distance_hex.to_i(16)]
    end

    def process_instruction(digger_instruction)
      direction, distance = *self.class.convert_instruction(digger_instruction)
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
      self.position = new_position
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
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
