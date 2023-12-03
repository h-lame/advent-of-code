class Solution2
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
    calibrations.map do |c|
      c
        .gsub(/on(?=e)|tw(?=o)|thre(?=e)|four|fiv(?=e)|six|seve(?=n)|eigh(?=t)|nin(?=e)/, {on: '1', tw: '2', thre: '3', four: '4', fiv: '5', six: '6', seve: '7', eigh: '8', nin: '9'}.transform_keys(&:to_s))
        .scan(/\d/)
        .values_at(0, -1)
        .join
        .to_i
    end
  end

  private

  attr_reader :calibrations

end

if __FILE__ == $0
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
