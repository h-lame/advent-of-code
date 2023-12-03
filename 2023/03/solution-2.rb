class Solution2
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map &:chomp
    end
  end

  Symbol = Data.define(:symbol, :position) do
    attr_reader :x, :y
    def initialize(symbol:, position:)
      @x = position[0]
      @y = position[1]
      @gear = (symbol == '*')
      super
    end

    def gear?
      @gear
    end

    def adjacent_to_number?(number)
      number.range[0].cover?(x) && number.range[1].cover?(y)
    end

    def ==(other)
      case other
      in Symbol
        super
      in [String => other_symbol, [Integer, Integer] => other_position]
        (symbol == other_symbol) && (position == other_position)
      else
        false
      end
    end
  end

  Number = Data.define(:number, :start_position, :finish_position) do
    attr_reader :start_x, :start_y, :finish_x, :finish_y, :range

    def initialize(number:, start_position:, finish_position:)
      @start_x = start_position[0]
      @start_y = start_position[1]
      @finish_x = finish_position[0]
      @finish_y = finish_position[1]
      @range = [@start_x-1..@finish_x+1, @start_y-1..@finish_y+1]
      super
    end

    def to_i
      number.to_i
    end

    def ==(other)
      case other
      in Number
        super
      in [String => other_number, [Integer, Integer] => other_start_position, [Integer, Integer] => other_finish_position]
        (number == other_number) && (start_position == other_start_position) && (finish_position == other_finish_position)
      else
        false
      end
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
        @symbols << Symbol.new(symbol: cell, position: [x, y]) unless cell.match? /\.|\d/
      end
    end
    @symbols
  end

  def potential_gears
    return @potential_gears if defined? @potential_gears

    @potential_gears = symbols.select(&:gear?)
  end

  def gears
    return @gears if defined? @gears

    @gears = []
    potential_gears.each do |potential_gear|
      gear_parts = numbers.select do |number|
        potential_gear.adjacent_to_number? number
      end

      @gears << gear_parts.map(&:number) if gear_parts.size == 2
    end
    @gears
  end

  def gears2
    return @gears2 if defined? @gears2

    @gears2 = []
    potential_gears.each do |potential_gear|
      gear_parts = potential_gear_parts.select do |number|
        potential_gear.adjacent_to_number? number
      end

      @gears2 << gear_parts.map(&:number) if gear_parts.size == 2
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
    @numbers.map! { |number| n, start, finish = *number; Number.new(number: n, start_position: start, finish_position: finish) }
  end

  def parts
    return @parts if defined? @parts

    @parts = numbers.select do |n|
      symbols.detect do |s|
        s.adjacent_to_number? n
      end
    end
  end

  def potential_gear_parts
    return @potential_gear_parts if defined? @potential_gear_parts

    @potential_gear_parts = numbers.select do |n|
      potential_gears.detect do |pg|
        pg.adjacent_to_number? n
      end
    end
  end

  private

  attr_reader :schematic

end

if __FILE__ == $0
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
  require 'benchmark'

  n = 10
  Benchmark.bmbm do |x|
    x.report("gears-numbers") { n.times { Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).gears } }
    x.report("gears-parts") { n.times { Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).gears2 } }
  end
end
