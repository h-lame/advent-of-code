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
    gears.sum { |g| g[0].to_i * g[1].to_i }
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
      _, (x, y) = *potential_gear
      gear_parts = numbers.select do |number|
        _n, start, finish = *number
        range = [start[0]-1..finish[0]+1, start[1]-1..finish[1]+1]
        range[0].cover?(x) && range[1].cover?(y)
      end

      @gears << gear_parts.map(&:first) if gear_parts.size == 2
    end
    @gears
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
    numbers.select do |n|
      number, start, finish = *n
      range = [start[0]-1..finish[0]+1, start[1]-1..finish[1]+1]
      symbols.detect do |s|
        _symbol, (x, y) = *s
        range[0].cover?(x) && range[1].cover?(y)
      end
    end.map { |n| n.first }
  end

  private

  attr_reader :schematic

end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
