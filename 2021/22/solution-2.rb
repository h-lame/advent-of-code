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
    @reactor = []
  end

  def initialization_process
    allowed_range = (-50..50)
    reboot_instructions.select do |instruction|
      _command, axis_ranges = *instruction
      axis_ranges.all? { |axis_range| allowed_range.cover? axis_range }
    end
  end

  def process_instruction!(instruction)
    command, *instruction_cube = *instruction
    cube_state = (command == :on)

    intersecting_cubes = reactor.select { |reactor_cube| overlap?(reactor_cube, instruction_cube) }

    if intersecting_cubes.none?
      self.reactor << instruction_cube if cube_state
    else
      if cube_state
        add_extra(instruction_cube, intersecting_cubes)
      else
        remove_intersection(instruction_cube, intersecting_cubes)
      end
    end
  end

  def add_extra(cube, intersecting_cubes)
    # remove bits of cube that overlap with intersecting_cubes
    # then add what's left to reactor
    left_in_cube = intersecting_cubes.reduce([cube]) do |left_in_cube_loop, i_cube|
      remove_cube_from_cubes(left_in_cube_loop, i_cube)
    end

    self.reactor.each do |c|
     left_in_cube.each do |c2|
       puts "^^^^^^^^^ Existing cube #{c.inspect} overlaps with new cube #{c2.inspect}" if overlap? c, c2
     end
    end

    self.reactor += left_in_cube
  end

  def remove_intersection(cube, intersecting_cubes)
    self.reactor = remove_cube_from_cubes(reactor, cube, hint: intersecting_cubes)
  end

  def remove_cube_from_cubes(cubes, cube_to_remove, hint: cubes)
    to_add = []
    to_remove = []
    hint.each do |cube|
      splits = remove_cube_b_from_cube_a(cube, cube_to_remove)
      next if splits.nil?

      to_remove += [cube]
      to_add += splits
    end
    puts "Looked at #{hint.size} vs. #{cubes.size} - going to reduce to #{cubes.size - to_remove.size + to_add.size}"
    if (to_remove.any? || to_add.any?)
      #merge_cubes((cubes - to_remove) + to_add)
      ((cubes - to_remove) + to_add)
    else
      cubes
    end
  end

  def merge_cubes(cubes)
    i = 0
    loop do
      changed = false
      cubes.each.with_index do |cube_a, x|
        cubes.each.with_index do |cube_b, y|
          next if x == y

          if contiguous_x?(cube_a, cube_b)
            cubes -= [cube_a, cube_b]
            x_range = [cube_a[0].min, cube_b[0].min, cube_a[0].max, cube_b[0].max].sort
            cubes += [[Range.new(x_range[0], x_range[-1]), cube_a[1], cube_a[2]]]
            changed = true
          elsif contiguous_y?(cube_a, cube_b)
            cubes -= [cube_a, cube_b]
            y_range = [cube_a[1].min, cube_b[1].min, cube_a[1].max, cube_b[1].max].sort
            cubes += [[cube_a[0], Range.new(y_range[0], y_range[-1]), cube_a[2]]]
            changed = true
          elsif contiguous_z?(cube_a, cube_b)
            cubes -= [cube_a, cube_b]
            z_range = [cube_a[2].min, cube_b[2].min, cube_a[2].max, cube_b[2].max].sort
            cubes += [[cube_a[0], cube_a[1], Range.new(z_range[0], z_range[-1])]]
            changed = true
          end
          break if changed
        end
        break if changed
      end
      i += 1
      break unless changed
    end
    puts "#{i} passes through to merge cubes"

    cubes
  end

  def contiguous_x?(cube_a, cube_b)
    (((cube_a[0].min == cube_b[0].max - 1) || (cube_a[0].max == cube_b[0].min - 1)) &&
      cube_a[1] == cube_b[1] && cube_a[2] == cube_b[2])
  end

  def contiguous_y?(cube_a, cube_b)
    (((cube_a[1].min == cube_b[1].max - 1) || (cube_a[1].max == cube_b[1].min - 1)) &&
      cube_a[0] == cube_b[0] && cube_a[2] == cube_b[2])
  end

  def contiguous_z?(cube_a, cube_b)
    (((cube_a[2].min == cube_b[2].max - 1) || (cube_a[2].max == cube_b[2].min - 1)) &&
      cube_a[0] == cube_b[0] && cube_a[1] == cube_b[1])
  end

  def overlap?(cube_a, cube_b)
    a_x, a_y, a_z = *cube_a
    b_x, b_y, b_z = *cube_b
    (a_x.cover?(b_x.min) || b_x.cover?(a_x.min)) &&
      (a_y.cover?(b_y.min) || b_y.cover?(a_y.min)) &&
      (a_z.cover?(b_z.min) || b_z.cover?(a_z.min))
  end

  def cubes_on(cubes = reactor)
    reactor.each.with_object([]) do |cube, on|
      x_axis_range, y_axis_range, z_axis_range = *cube
      x_axis_range.each do |x|
        y_axis_range.each do |y|
          z_axis_range.each do |z|
            on << [x,y,z]
          end
        end
      end
    end
  end

  def initialize_reactor!
    initialization_process.each do |initialization_instruction|
      process_instruction!(initialization_instruction)
    end
  end

  def result
    reboot_instructions.each.with_index do |instruction, idx|
      puts "#{idx}/#{reboot_instructions.size}: #{instruction.inspect} - #{reactor.size}"
      process_instruction!(instruction)
    end
    reactor.map do |cube|
      x, y, z = *cube
      x.size * y.size * z.size
    end.sum
  end

  private

  attr_reader :reboot_instructions, :reactor
  attr_writer :reactor

  # find overlap for two ranges
  def overlap_segment(a, b)
    return [] if (a.max < b.min) || (a.min > b.max)

    Range.new *[a.min, a.max, b.min, b.max].sort[1..2]
  end

  # Split cube position, position is in the 2nd cube
  # e.g. [1..3, 1..3, 1..3] split at 2 is [1..1, 1..3, 1..3], [2..3, 1..3, 1..3]
  def split_cube_by_x(cube, split_position)
    x_axis_range, y_axis_range, z_axis_range = *cube
    return [cube] unless x_axis_range.cover? split_position

    cubes = []
    cubes << [Range.new(x_axis_range.min, split_position -1), y_axis_range, z_axis_range] if x_axis_range.min < split_position
    cubes << [Range.new(split_position, x_axis_range.max), y_axis_range, z_axis_range]
    cubes
  end

  def split_cube_by_y(cube, split_position)
    x_axis_range, y_axis_range, z_axis_range = *cube
    return [cube] unless y_axis_range.cover? split_position

    cubes = []
    cubes << [x_axis_range, Range.new(y_axis_range.min, split_position -1), z_axis_range] if y_axis_range.min < split_position
    cubes << [x_axis_range, Range.new(split_position, y_axis_range.max), z_axis_range]
    cubes
  end

  def split_cube_by_z(cube, split_position)
    x_axis_range, y_axis_range, z_axis_range = *cube
    return [cube] unless z_axis_range.cover? split_position

    cubes = []
    cubes << [x_axis_range, y_axis_range, Range.new(z_axis_range.min, split_position -1)] if z_axis_range.min < split_position
    cubes << [x_axis_range, y_axis_range, Range.new(split_position, z_axis_range.max)]
    cubes
  end

  def split_cube_at_point(cube, point)
    x, y, z = *point
    split = []
    split_by_x = split_cube_by_x(cube, x)
    split_by_x.each do |x_cube|
      split_by_y = split_cube_by_y(x_cube, y)
      split_by_y.each do |y_cube|
        split += split_cube_by_z(y_cube, z)
      end
    end
    split.uniq
  end

  def split_cube_by_square(cube, point_a, point_b)
    split_by_point_a = split_cube_at_point(cube, point_a)
    split = []
    split_by_point_a.each do |split_cube|
      split += split_cube_at_point(split_cube, point_b)
    end
    split.uniq
  end

  def intersect(cube_a, cube_b)
    cube_a_x, cube_a_y, cube_a_z = *cube_a
    cube_b_x, cube_b_y, cube_b_z = *cube_b
    x_overlap = overlap_segment(cube_a_x, cube_b_x)
    if x_overlap.any?
      y_overlap = overlap_segment(cube_a_y, cube_b_y)
      if y_overlap.any?
        z_overlap = overlap_segment(cube_a_z, cube_b_z)
        if z_overlap.any?
          point_a = [x_overlap.min, y_overlap.min, z_overlap.min]
          point_b = [x_overlap.max + 1, y_overlap.max + 1, z_overlap.max + 1]

          return [split_cube_by_square(cube_a, point_a, point_b), split_cube_by_square(cube_b, point_a, point_b)]
        end
      end
    end
  end

  def remove_cube_b_from_cube_a(cube_a, cube_b)
    return nil unless overlap?(cube_a, cube_b)

    splits = intersect(cube_a, cube_b)

    if splits
      cube_a_split, cube_b_split = *splits
      cube_a_split - cube_b_split
    end
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
