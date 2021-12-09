require 'csv'

class Solution
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map do |line|
        line.chomp.chars.map { |char| Integer(char) }
      end
    end
  end

  def initialize(heightmap)
    @heightmap = heightmap
  end

  def low_points
    return @low_points if defined? @low_points

    @low_points = []
    heightmap.each.with_index do |row, y|
      row.each.with_index do |height, x|
        @low_points << [x,y] if lowest_point?(x,y)
      end
    end
    @low_points
  end

  def low_points_heights
    low_points.map { |(x,y)| heightmap[y][x] }
  end

  def result
    low_points_heights.sum { |x| x+1 }
  end

  private

  attr_reader :heightmap

  def lowest_point?(x,y)
    height = heightmap[y][x]
    neighbours = []
    neighbours << heightmap[y - 1][x] if y-1 >= 0 # up
    neighbours << heightmap[y + 1][x] if y+1 < heightmap.size # down
    neighbours << heightmap[y][x - 1] if x-1 >= 0 # left
    neighbours << heightmap[y][x + 1] if x+1 < heightmap.first.size # right

    neighbours.all? { |n| n > height }
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
