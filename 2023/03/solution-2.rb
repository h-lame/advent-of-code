class Solution
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map &:chomp
    end
  end

  def initialize(schematic)
    @schematic = schematic
  end

  def result
    gears2.sum { |g| g[0].to_i * g[1].to_i }
  end

  def symbols
    return @symbols if defined? @symbols

    @symbols = []
    schematic.each.with_index do |rows, y|
      rows.each_char.with_index do |cell, x|
        @symbols << [cell, [x, y]] unless cell.match? /\.|\d/
      end
    end
    @symbols
  end

  def potential_gears
    return @potential_gears if defined? @potential_gears

    @potential_gears = symbols.select { |s| s[0] == '*' }
  end

  def gears
    return @gears if defined? @gears

    @gears = []
    potential_gears.each do |potential_gear|
      gear_parts = numbers.select do |number|
        symbol_adjacent_to_number?(range_for_number(number), potential_gear.last)
      end

      @gears << gear_parts.map(&:first) if gear_parts.size == 2
    end
    @gears
  end

  def gears2
    return @gears2 if defined? @gears2

    @gears2 = []
    potential_gears.each do |potential_gear|
      gear_parts = potential_gear_parts.select do |number|
        symbol_adjacent_to_number?(range_for_number(number), potential_gear.last)
      end

      @gears2 << gear_parts.map(&:first) if gear_parts.size == 2
    end
    @gears2
  end

  def numbers
    return @numbers if defined? @numbers

    @numbers = []
    cur_num = nil
    schematic.each.with_index do |rows, y|
      rows.each_char.with_index do |cell, x|
        if cur_num
          if cell.match? /\d/
            cur_num[0] += cell
            cur_num[-1][0] = x
          else
            cur_num = nil
          end
        else
          if cell.match? /\d/
            cur_num = [cell, [x, y], [x, y]]
            @numbers << cur_num
          end
        end
      end
    end
    @numbers
  end

  def parts
    return @parts if defined? @parts

    @parts = numbers.select do |n|
      range = range_for_number(n)
      symbols.detect do |s|
        symbol_adjacent_to_number?(range, s.last)
      end
    end
  end

  def potential_gear_parts
    return @potential_gear_parts if defined? @potential_gear_parts

    @potential_gear_parts = numbers.select do |n|
      range = range_for_number(n)
      potential_gears.detect do |pg|
        symbol_adjacent_to_number?(range, pg.last)
      end
    end
  end

  private

  def range_for_number(number)
    _, start, finish = *number
    [start[0]-1..finish[0]+1, start[1]-1..finish[1]+1]
  end

  def symbol_adjacent_to_number?(number_range, symbol_position)
    x, y = *symbol_position
    number_range[0].cover?(x) && number_range[1].cover?(y)
  end

  attr_reader :schematic

end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
  require 'benchmark'

  n = 10
  Benchmark.bmbm do |x|
    x.report("gears-numbers") { n.times { Solution.new(Solution::Normalizer.do_it(ARGV[0])).gears } }
    x.report("gears-parts") { n.times { Solution.new(Solution::Normalizer.do_it(ARGV[0])).gears2 } }
  end

end
