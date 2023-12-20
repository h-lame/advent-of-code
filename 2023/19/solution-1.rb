require 'set'

class Solution1
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

  Part = Data.define(:x,:m,:a,:s) do
    def self.from_raw(part)
      new(**part)
    end

    def score
      x + m + a + s
    end
  end

  Workflow = Data.define(:rules) do
    def initialize(rules: )
      super(rules: self.class.extract_rules(rules))
    end

    def apply_to_part(part)
      rules.lazy.map { |r| r.call(part) }.compact.first
    end

    def self.extract_rules(rules)
      rules.map do |rule|
        expr, result = *rule.split(':')
        if result.nil?
          -> (part) { expr }
        else
          /\A(?<attribute>[xmas])(?<operator>[<>])(?<value>\d+)\Z/ =~ expr
          value = value.to_i
          if operator == '>'
            -> (part) { part.send(attribute) > value ? result : nil }
          else
            -> (part) { part.send(attribute) < value ? result : nil }
          end
        end
      end
    end
  end

  Engine = Data.define(:workflow_map) do
    def accepted_parts(parts)
      parts.select { |part| process_part(part) == 'A' }
    end

    def process_part(part)
      workflow = workflow_map[:in]
      result = nil
      loop do
        result = workflow.apply_to_part(part)
        if ['A', 'R'].include? result
          break
        else
          workflow = workflow_map[result.to_sym]
        end
      end
      result
    end
  end

  def initialize(workflows_and_parts)
    workflows, parts = *workflows_and_parts
    @parts = parts.map { |p| Part.from_raw(p) }
    @workflow_engine = Engine.new(workflow_map: workflows.transform_values { |w| Workflow.new(rules: w) })
  end

  attr_reader :parts, :workflow_engine

  def result
    workflow_engine.accepted_parts(parts).sum &:score
  end
end

if __FILE__ == $0
  puts Solution1.new(Solution1::Normalizer.do_it(ARGV[0])).result
end
