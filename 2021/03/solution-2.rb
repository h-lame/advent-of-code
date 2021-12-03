class Solution
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map &:chomp
    end
  end

  def initialize(reports)
    @raw_reports = reports
    calculate_rates!
  end

  attr_reader :oxygen_generator_rating_binary, :co2_scubber_rating_binary

  def oxygen_generator_rating
    Integer(oxygen_generator_rating_binary, 2)
  end

  def co2_scubber_rating
    Integer(co2_scubber_rating_binary, 2)
  end

  def result
    oxygen_generator_rating * co2_scubber_rating
  end

  private

  attr_reader :raw_reports
  attr_writer :oxygen_generator_rating_binary, :co2_scubber_rating_binary

  def calculate_rates!
    calculate_oxygen_generator_rating_binary!
    calculate_co2_scubber_rating_binary!
  end

  def tally(reports, bit: 0)
    reports.map(&:chars).transpose[bit].tally
  end

  def most_common_value(reports, bit: 0)
    tallied = tally(reports, bit: bit)

    if tallied['0'] == tallied['1']
      '1'
    else
      tallied.max_by { |_char, count| count }.first
    end
  end

  def least_common_value(reports, bit: 0)
    tallied = tally(reports, bit: bit)

    if tallied['0'] == tallied['1']
      '0'
    else
      tallied.min_by { |_char, count| count }.first
    end
  end

  def filter_reports(reports, bit:, method:)
    filter_value =
      if method == :most
        most_common_value(reports, bit: bit)
      else
        least_common_value(reports, bit: bit)
      end

    reports.select do |report|
      report[bit] == filter_value
    end.tap { |x| puts x.inspect }
  end

  def find_rating(reports, bit:, method:)
    return reports.first if reports.size <= 1

    find_rating(filter_reports(reports, bit: bit, method: method), bit: bit+1, method: method)
  end

  def calculate_oxygen_generator_rating_binary!
    self.oxygen_generator_rating_binary =
      find_rating(raw_reports, bit: 0, method: :most)
  end

  def calculate_co2_scubber_rating_binary!
    self.co2_scubber_rating_binary =
      find_rating(raw_reports, bit: 0, method: :least)
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
