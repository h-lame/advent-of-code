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
    @polymer_template = @polymer = polymer_template
    @pair_insertions = Hash[pair_insertions]
  end

  def result
    polymer_after(10)
    min_max_elements.map { |x| x.last }.reduce(:-).abs
  end

  def min_max_elements
    Hash[
      polymer.
        chars.
        group_by { |x| x }.
        map { |(element, occurences)| [element, occurences.size] }.
        minmax { |a,b| a.last <=> b.last }
    ]
  end

  def polymer_after(steps)
    self.polymer = polymer_template
    steps.times do |step|
      next_polymer = ''
      polymer.chars.each_cons(2) do |pair|
        next_polymer << pair.first
        next_polymer << pair_insertions[pair.join] if pair_insertions[pair.join]
      end
      next_polymer << polymer.chars.last
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
