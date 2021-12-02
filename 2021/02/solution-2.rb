class Solution
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map do |l|
        command, distance = l.split
        [command.to_sym, Integer(distance)]
      end
    end
  end

  def initialize(moves)
    @moves = moves
    execute_moves!
  end

  attr_reader :horizontal_position, :depth, :aim

  def result
    horizontal_position * depth
  end

  private

  attr_reader :moves
  attr_writer :horizontal_position, :depth, :aim

  def execute_moves!
    self.horizontal_position = 0
    self.depth = 0
    self.aim = 0
    moves.each { |m| execute_move!(m) }
  end

  def execute_move!(move)
    command, distance = move
    case command
    when :forward
      self.horizontal_position += distance
      self.depth += aim * distance
    when :up
      self.aim -= distance
    when :down
      self.aim += distance
    end
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
