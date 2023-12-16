class Solution2
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp).join.split(',')
    end
  end

  module Hash
    def self.calc(string)
      # Determine the ASCII code for the current character of the string.
      # Increase the current value by the ASCII code you just determined.
      # Set the current value to itself multiplied by 17.
      # Set the current value to the remainder of dividing itself by 256.
      string.chars.reduce(0) do |acc, char|
        acc += char.ord
        acc = acc * 17
        acc % 256
      end
    end
  end

  class HashMap
    def initialize
      @boxes = {}
    end

    def process_instruction(instruction)
      /(?<label>[a-z]+)(?<operator>[=-])(?<focal_length>\d+)?/ =~ instruction
      box = Hash.calc label
      case operator
      in '='
        raise "add operation without focal_length for #{instruction}" if focal_length.nil?
        add_to_box(box, label, focal_length.to_i)
      in '-'
        remove_from_box(box, label)
      end
    end

    def setup_box(box, *lenses)
      boxes[box] = lenses
    end

    def remove_from_box(box, label)
      return unless boxes.key? box
      boxes[box].delete_if { |lens| lens.first == label }
    end

    def add_to_box(box, label, focal_length)
      return boxes[box] = [[label, focal_length]] unless boxes.key? box

      already_in = boxes.fetch(box, []).each.with_index.detect { |lens, idx| lens.first == label }
      if already_in
        boxes[box][already_in.last][-1] = focal_length
      else
        boxes[box] ||= []
        boxes[box] << [label, focal_length]
      end
    end

    def focusing_power(box)
      return 0 unless boxes.key? box
      # One plus the box number of the lens in question.
      # The slot number of the lens within the box: 1 for the first lens, 2 for the second lens, and so on.
      # The focal length of the lens.

      boxes[box].map.with_index do |lens, idx|
        (box+1) * (idx+1) * lens.last
      end.sum
    end

    def total_focussing_power = boxes.keys.sum { |box| focusing_power box }

    attr_reader :boxes
  end

  def initialize(initialisation_sequence)
    @initialisation_sequence = initialisation_sequence
  end

  attr_reader :initialisation_sequence

  def result
    initialisation_sequence.each do |instruction|
      hash_map.process_instruction instruction
    end
    hash_map.total_focussing_power
  end

  def hash_map
    @hash_map ||= HashMap.new
  end

end

if __FILE__ == $0
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
