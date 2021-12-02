class Solution
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map { |s| Integer(s) }
    end
  end

  def initialize(scans)
    @scans = scans
  end

  def result
    prepared_scans.count { |x| x.last > x.first }
  end

  private

  attr_reader :scans

  def prepared_scans
    summed_measurements.zip(summed_measurements[1..-1])[0..-2]
  end

  def summed_measurements
    three_measurement_windows.map &:sum
  end

  def three_measurement_windows
    return @three_measurement_windows if defined? @three_measurement_windows

    @three_measurement_windows = scans.each_cons(3)
    @three_measurement_windows.pop if @three_measurement_windows.to_a.last.size != 3
    @three_measurement_windows
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
