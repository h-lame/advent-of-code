class Solution1
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map &:chomp
    end
  end

  def initialize(calibrations)
    @calibrations = calibrations
  end

  def result
    prepared_calibrations.sum
  end

  def prepared_calibrations
    calibrations.map { |c| c.scan(/\d/).values_at(0, -1).join.to_i }
  end

  private

  attr_reader :calibrations

end

if __FILE__ == $0
  puts Solution1.new(Solution1::Normalizer.do_it(ARGV[0])).result
end
