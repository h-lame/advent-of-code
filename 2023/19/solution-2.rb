require 'set'

class Solution2
  class Normalizer
    def self.do_it(file_name)
      workflows, parts = *File.readlines(file_name).map(&:chomp).slice_when { |x, y| x == '' }
      [
        # px{a<2006:qkq,m>2090:A,rfg}
        Hash[workflows.reject { |x| x=='' }.map do |w|
          /\A(?<label>[^{]+)\{(?<rules>[^}]+)\}\Z/ =~ w
          [label.to_sym, rules.split(',')]
        end],
        # {x=787,m=2655,a=1222,s=2876}
        parts.map! do |part|
          Hash[part.tr('{}','').split(',').map { |category| /(?<cat>[xmas])=(?<val>\d+)/ =~ category; [cat.to_sym, val.to_i] }]
        end
      ]
    end
  end

  def graph(from = raw_workflows[:in])
    Hash[from.map do |rule|
      expr, result = *rule.split(':')
      expr, result = *['*', expr] if result.nil?
      result = graph(raw_workflows[result.to_sym]) unless ['A', 'R'].include? result
      [expr, result]
    end]
  end

  def split_graph(ranges = {x: 1..4_000, m: 1..4_000, a: 1..4_000, s: 1..4_000}, from = raw_workflows[:in])
    Hash[from.map do |rule|
      expr, result = *rule.split(':')

      my_ranges, next_ranges, result = *(
        if result.nil?
          [ranges, ranges, expr]
        else
          /\A(?<attribute>[xmas])(?<operator>[<>])(?<value>\d+)\Z/ =~ expr
          value = value.to_i
          attribute = attribute.to_sym
          range_splits = ranges.map do |k, v|
            if k == attribute
              if operator == '>'
                [k, v.begin..value, (value+1)..v.end]
              else
                [k, (value)..v.end, v.begin..(value-1)]
              end
            else
              [k, v, v]
            end
          end
          [Hash[range_splits.map { |k,_,v| [k,v] }], Hash[range_splits.map { |k,v,_| [k,v] }], result]
        end
      )

      result = split_graph(my_ranges, raw_workflows[result.to_sym]) unless ['A', 'R'].include? result
      ranges = next_ranges
      [my_ranges, result]
    end]
  end

  def accepted_ranges(via = split_graph)
    accepted = []
    via.each do |ranges, result|
      if result == 'A'
        accepted << ranges
      elsif result == 'R'
        next
      else
        accepted += accepted_ranges(result)
      end
    end
    accepted
  end

  def initialize(workflows_and_parts)
    @raw_workflows, _parts = *workflows_and_parts
  end

  attr_reader :raw_workflows

  def result
    accepted_ranges.map do |accepted_range|
      accepted_range.map do |_attribute, range|
        range.size
      end.reduce(1) { |acc, size| acc * size }
    end.sum
  end
end

if __FILE__ == $0
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
