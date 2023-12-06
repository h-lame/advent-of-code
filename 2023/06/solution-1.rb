class Solution1
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name)
        .map(&:chomp)
        .map { |x|
          x
            .split(/:\s+/)
            .last
            .scan(/\d+/)
            .map(&:to_i)
        }
        .transpose
    end
  end

  Race = Data.define(:time, :distance) do
    def strategies
      (0..time).map { |x| [x, (time - x) * x ] }
    end

    def record_breaking_strategies
      (0..time).select { |x| ((time - x) * x) > distance }.map { |x| [x, (time - x) * x ] }
    end

    def record_breakers
      seconds = (0..time).to_a
      smallest = seconds.index { |x| ((time - x) * x) > distance }
      largest = seconds.rindex { |x| ((time - x) * x) > distance }
      (smallest..largest).size
    end
  end

  def initialize(races)
    @races = races
  end

  def result
    prepared_races.reduce(1) { |sum, r| sum * r.record_breakers }
  end

  def prepared_races
    return @prepared_races if defined? @prepared_races

    @prepared_races = races.map { |race| Race.new(time: race[0], distance: race[1]) }
  end

  private

  attr_reader :races

end

if __FILE__ == $0
  puts Solution1.new(Solution1::Normalizer.do_it(ARGV[0])).result
end
