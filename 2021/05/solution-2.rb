class Solution
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map do |line|
        line.split(' -> ').map do |coordinate|
          coordinate.split(',').map do |distance|
            Integer(distance)
          end
        end
      end
    end
  end

  def initialize(vents)
    @vents = vents.map { |vent| Vent.new(*vent) }
    create_vent_map!
  end

  def relevant_vents_size
    relevant_vents.size
  end

  def result
    vent_map.count { |position, vent_count| vent_count > 1 }
  end

  private

  attr_reader :vents
  attr_accessor :vent_map

  def relevant_vents
    @_relevant_vents ||= vents.select { |vent| vent.horizontal? || vent.vertical? || vent.diagonal? }
  end

  def create_vent_map!
    self.vent_map = Hash.new(0)
    relevant_vents.map do |vent|
      vent.points&.each do |point|
        vent_map[point] += 1
      end
    end
  end

  Vent = Struct.new(:start_position, :end_position) do
    def horizontal?
      start_position.first == end_position.first
    end

    def vertical?
      start_position.last == end_position.last
    end

    def diagonal?
      [45, 135, -45, -135].include? angle
    end

    def angle
      return @_angle if defined? @_angle

      change_in_y = (start_position.last - end_position.last)
      change_in_x = (start_position.first - end_position.first)
      @_angle = ((180 * Math.atan2(change_in_y, change_in_x)) / Math::PI)
    end

    def points
      return @_points if defined? @_points

      @_points =
        if horizontal?
          Range.new(*[start_position.last, end_position.last].sort).to_a.map do |y_coord|
            [start_position.first, y_coord]
          end
        elsif vertical?
          Range.new(*[start_position.first, end_position.first].sort).to_a.map do |x_coord|
            [x_coord, start_position.last]
          end
        elsif diagonal?
          case angle
          when 45
            Range.new(*[end_position.first, start_position.first]).to_a.map.with_index do |x_coord, idx|
              [x_coord, end_position.last + idx]
            end
          when 135
            Range.new(*[start_position.first, end_position.first]).to_a.map.with_index do |x_coord, idx|
              [x_coord, start_position.last - idx]
            end
          when -45
            Range.new(*[end_position.first, start_position.first]).to_a.map.with_index do |x_coord, idx|
              [x_coord, end_position.last - idx]
            end
          when -135
            Range.new(*[start_position.first, end_position.first]).to_a.map.with_index do |x_coord, idx|
              [x_coord, start_position.last + idx]
            end
          end
        end
    end
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
