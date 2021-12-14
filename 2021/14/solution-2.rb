class Solution
  class Normalizer
    def self.do_it(file_name)
      polymer, *pair_insertions = *File.readlines(file_name).map(&:chomp)
      [
        polymer,
        pair_insertions.reject { |x| x == '' }.map do |pair_insertion|
          pair_insertion.split(' -> ')
        end
      ]
    end
  end

  attr_reader :polymer

  def initialize(polymer_template, pair_insertions)
    @polymer_template = polymer_template
    @pair_insertions = Hash[pair_insertions]
  end

  def result
    polymer_after(40)
    min_max_elements.map { |x| x.last }.reduce(:-).abs
  end

  def min_max_elements
    Hash[
      polymer[:elements].
        minmax { |a,b| a.last <=> b.last }
    ]
  end

  def polymer_after(steps)
    self.polymer = {
      pairs: Hash[polymer_template.chars.each_cons(2).to_a.map { |pair| [pair.join, 1] }],
      elements: Hash[polymer_template.chars.group_by { |x| x }.map { |x, o| [x, o.size] }]
    }
    steps.times do |step|
      next_polymer = {pairs: {}, elements: polymer[:elements]}
      polymer[:pairs].each do |pair, count|
        insertion = pair_insertions[pair]
        left_pair = [pair.chars.first, insertion].join
        right_pair = [insertion, pair.chars.last].join
        next_polymer[:pairs][left_pair] ||= 0
        next_polymer[:pairs][left_pair] += count
        next_polymer[:pairs][right_pair] ||= 0
        next_polymer[:pairs][right_pair] += count
        next_polymer[:elements][insertion] ||= 0
        next_polymer[:elements][insertion] += count
      end
      self.polymer = next_polymer
    end
    self.polymer
  end

  private

  attr_reader :polymer_template, :pair_insertions
  attr_writer :polymer

end

if __FILE__ == $0
  puts Solution.new(*Solution::Normalizer.do_it(ARGV[0])).result
end
