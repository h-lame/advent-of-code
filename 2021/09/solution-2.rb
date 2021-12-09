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
    @neighbours = {}
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

  def basin_for(x,y)
    basins.detect { |points| points.include? [x,y] }
  end

  def largest_basins(how_many)
    basins.take(how_many)
  end

  def largest_basin_sizes(how_many)
    largest_basins(how_many).map { |basin| basin.size }
  end

  def result
    largest_basin_sizes(3).reduce :*
  end

  private

  attr_reader :heightmap

  def basins
    return @basins if defined? @basins

    @basins = low_points.map do |low_point|
      find_basin(*low_point)
    end.sort_by { |basin| -basin.size }
  end

  def find_basin(x, y)
    expand_basin([[x,y]])
  end

  def expand_basin(basin)
    to_add = []
    basin.each do |point_x, point_y|
      point_height = heightmap[point_y][point_x]
      to_add += neighbours(point_x, point_y).reject { |(x,y)| heightmap[y][x] == 9 }
    end
    if (basin | to_add) == basin
      basin
    else
      expand_basin(basin | to_add)
    end
  end

  def neighbours(x, y)
    return @neighbours[[x,y]] unless @neighbours[[x,y]].nil?

    @neighbours[[x,y]] = [].tap do |point_neighbours|
      point_neighbours << [x, y - 1] if y - 1 >= 0 # up
      point_neighbours << [x, y + 1] if y + 1 < heightmap.size # down
      point_neighbours << [x - 1, y] if x - 1 >= 0 # left
      point_neighbours << [x + 1, y] if x + 1 < heightmap.first.size # right
    end
  end

  def lowest_point?(x,y)
    height = heightmap[y][x]
    neighbours(x,y).all? { |(x,y)| heightmap[y][x] > height }
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
