class Solution
  class Normalizer
    def self.do_it(file_name)
      lines = File.readlines(file_name).map(&:chomp).map do |line|
        instruction, ranges = *line.split(' ')
        [
          instruction.to_sym,
          *ranges.split(',').map do |range|
            Range.new *(range.gsub(/\A[xyz]=/,'').split('..').map { |x| Integer(x) })
          end
        ]
      end
    end
  end

  def initialize(reboot_instructions)
    @reboot_instructions = reboot_instructions
    @reactor = Hash.new { false }
  end

  def initialization_process
    allowed_range = (-50..50)
    reboot_instructions.select do |instruction|
      _command, axis_ranges = *instruction
      axis_ranges.all? { |axis_range| allowed_range.cover? axis_range }
    end
  end

  def process_instruction!(instruction)
    command, x_axis_range, y_axis_range, z_axis_range = *instruction
    cube_state = (command == :on)
    x_axis_range.each do |x|
      y_axis_range.each do |y|
        z_axis_range.each do |z|
          reactor[[x,y,z]] = cube_state
        end
      end
    end
  end

  def cubes_on
    reactor.keys.select { |cube| reactor[cube] == true }
  end

  def result
    initialization_process.each do |initialization_instruction|
      process_instruction!(initialization_instruction)
    end
    reactor.values.count { |x| x == true }
  end

  private

  attr_reader :reboot_instructions, :reactor
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
