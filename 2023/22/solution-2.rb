require 'parallel'

class Solution2
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp).map do |line|
        line.split('~').map do |coords|
          coords.split(',').map &:to_i
        end
      end
    end
  end

  def self.range_overlap?(s, o)
    return false if (s.begin..o.end).size.zero?
    return false if (o.begin..s.end).size.zero?

    return true #s.begin == o.begin)
  end

  BASE39 = %|0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ@$&|

  def self.to_base39(int)
    tens = int / 39
    units = int % 39
    tens_str = if tens > 38
      tens_str = to_base39(tens)
    else
      BASE39[tens]
    end
    "#{tens_str}#{BASE39[units]}"
  end

  def self.from_base39(str)
    str.chars.map { |x| BASE39.index(x) }.reverse.each_with_index.reduce(0) { |acc, (y, idx)| acc += (y * (39**idx)) }
  end

  XYZ = Data.define(:x, :y, :z) do
    def drop(change)
      self.class.new(x:, y:, z: z-change)
    end

    def to_s = %|<X:#{x},Y:#{y},Z:#{z}>|
    alias :inspect :to_s
  end

  Brick = Data.define(:id, :top, :tail) do
    def max_x = [top.x, tail.x].max

    def max_y = [top.y, tail.y].max

    def max_z = [top.z, tail.z].max

    def x_span = (top.x..tail.x)

    def y_span = (top.y..tail.y)

    def z_span = (top.z..tail.z)

    def vertical?
      top.z != tail.z
    end

    def horizontal?
      top.z == tail.z
    end

    def orientation_axis
      if top.x == tail.x
        if top.y == tail.y
          if top.z == tail.z
            :single_cube
          else
            :z
          end
        else
          if top.z == tail.z
            :y
          else
            :diagonal_y_z
          end
        end
      else
        if top.y == tail.y
          if top.z == tail.z
            :x
          else
            :diagonal_x_z
          end
        else
          if top.z == tail.z
            :diagonal_x_y
          else
            :diagonal_x_y_z
          end
        end
      end
    end

    def to_s = %|<B(#{id} - #{top}~#{tail}>|
    alias :inspect :to_s

    # am I above other
    def above?(other) = other.z_span.max < self.z_span.min

    # am I driectly above other
    def directly_above?(other) = other.z_span.max + 1 == self.z_span.min

    # am I below other
    def below?(other) = other.z_span.min > self.z_span.max

    # am I directly below other
    def directly_below?(other) = other.z_span.min == (self.z_span.max + 1)

    # am I a supporter of other
    def supporter_of?(other) = below?(other) && cross_over?(other)
    alias :supports? :supporter_of?

    # am I an immediate supporter of other (e.g. right underneath it)
    def immediate_supporter_of?(other) = directly_below?(other) && cross_over?(other)

    # am I supported by other (e.g. on top of it)
    def supported_by?(other) = directly_above?(other) && cross_over?(other)

    def cross_over?(other) = Solution2.range_overlap?(self.x_span, other.x_span) && Solution2.range_overlap?(self.y_span, other.y_span)

    def fall(other_bricks)
      return self if z_span.min == 1
      supporting = other_bricks.select { |ob| ob.supports? self }.max_by { |ob| ob.z_span.max }

      if supporting.nil?
        drop = z_span.min - 1
        self.class.new(id: id, top: top.drop(drop), tail: tail.drop(drop))
      elsif directly_above? supporting
        self
      else
        drop = z_span.min - supporting.z_span.max - 1
        self.class.new(id: id, top: top.drop(drop), tail: tail.drop(drop))
      end
    end

    def supporting(other_bricks) = other_bricks.select { |ob| immediate_supporter_of?(ob) }

    def supporters(other_bricks) = other_bricks.select { |ob| supported_by?(ob) }
  end

  class Jenga
    def initialize(raw_bricks)
      @bricks = raw_bricks.map.with_index { |(top, tail), idx| Brick.new(id: Solution2.to_base39(idx), top: XYZ.new(*top), tail: XYZ.new(*tail)) }
      diagonals = bricks.reject { |b| [:x, :y, :z, :single_cube].include? b.orientation_axis }
      raise "Problem - diagonal bricks #{diagonals}" if diagonals.any?
    end

    attr_reader :bricks

    def settle!
      settled, fell = *settle(bricks)
      self.bricks = settled
      fell
    end

    def disintegratation_change(brick)
      _, fell = *settle(bricks - [brick])
      fell
    end

    def settle(some_bricks)
      fell = 0
      new_bricks = some_bricks.dup
      some_bricks.sort_by { |b| b.z_span.min }.each do |brick|
        without_brick = new_bricks - [brick]
        new_brick = brick.fall(new_bricks - [brick])
        fell += 1 if new_brick.object_id != brick.object_id
        new_bricks = without_brick + [new_brick]
      end
      [new_bricks, fell]
    end

    def render(axis)
      case axis
      in :x
        render_x_axis
      in :y
        render_y_axis
      end
    end

    def render_x_axis
      width = bricks.max_by { |b| b.max_x }.max_x
      height = bricks.max_by { |b| b.max_z }.max_z

      out = height.downto(1).map do |row|
        row_bricks = bricks.select { |b| b.z_span.cover? row }
        0.upto(width).map do |col|
          col_bricks = row_bricks.select { |b| b.x_span.cover? col }
          if col_bricks.empty?
            '[..]'
          elsif col_bricks.size == 1
            "[#{col_bricks[0].id}]"
          else
            "[??]"
          end
        end.join
      end.join("\n")
      "#{out}\n#{'-'*(4*(width+1))}"
    end

    def render_y_axis
      width = bricks.max_by { |b| b.max_x }.max_x
      height = bricks.max_by { |b| b.max_z }.max_z

      out = height.downto(1).map do |row|
        row_bricks = bricks.select { |b| b.z_span.cover? row }
        0.upto(width).map do |col|
          col_bricks = row_bricks.select { |b| b.y_span.cover? col }
          if col_bricks.empty?
            '[..]'
          elsif col_bricks.size == 1
            "[#{col_bricks[0].id}]"
          else
            "[??]"
          end
        end.join
      end.join("\n")
      "#{out}\n#{'-'*(4*(width+1))}"
    end

    def removable_bricks
      bricks_and_supporters = bricks.map do |b|
        everyone_except_brick = bricks - [b]
        [
          b,
          b.supporters(everyone_except_brick),
          b.supporting(everyone_except_brick),
        ]
      end

      bricks_and_supporters.select do |brick, supporters, supporting|
        if supporting.size == 0
          puts "Brick #{brick} removable - yes supports nothing"
          true
        else
          if supporting.any? { |s| bricks_and_supporters.detect { |sb,ster,sting| sb.id == s.id }[1].size == 1 }
            puts "Brick #{brick} removable - no - at least one thing it supports is only supported by it"
            false
          else
            puts "Brick #{brick} removable - yes - all things it supports have more than one support"
            true
          end
        end
      end
    end

    private

    attr_writer :bricks
  end

  def initialize(raw_bricks)
    @jenga = Jenga.new(raw_bricks)
  end

  attr_reader :jenga

  def result
    jenga.settle!
    Parallel.map_with_index(jenga.bricks, progress: 'x', in_processes: 8) do |b, idx|
      jenga.disintegratation_change(b)
    end.sum
  end
end

if __FILE__ == $0
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
