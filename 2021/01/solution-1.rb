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
    scans.zip(scans[1..-1])[0..-2]
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
