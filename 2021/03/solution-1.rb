class Solution
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map &:chomp
    end
  end

  def initialize(reports)
    @reports = reports
    calculate_rates!
  end

  attr_reader :gamma_rate_binary, :epsilon_rate_binary

  def gamma_rate
    Integer(gamma_rate_binary, 2)
  end

  def epsilon_rate
    Integer(epsilon_rate_binary, 2)
  end

  def result
    gamma_rate * epsilon_rate
  end

  private

  attr_reader :reports
  attr_writer :gamma_rate_binary, :epsilon_rate_binary

  def calculate_rates!
    calculate_gamma_rate_binary!
    calculate_epsilon_rate_binary!
  end

  def calculate_gamma_rate_binary!
    self.gamma_rate_binary =
      reports       #=> ['101', '100', ...]
        .reduce([0] * reports.first.size) do |rate, figure|
          rate         #=> [0, 0, 0, ...]
            .map.with_index do |x, idx|
              figure[idx] == '1' ? x + 1 : x
            end        #=> [1, 0, 1, ...]
        end         #=> [2, 0, 1]
        .map do |count|
          (count >= reports.size / 2) ? 1 : 0
        end         #=> [1, 0, 0]
        .join       #=> '100'
  end

  def calculate_epsilon_rate_binary!
    self.epsilon_rate_binary = '%0*b' % [report_binary_size, (self.gamma_rate ^ flipper)]
  end

  def flipper
    @_flipper ||= Integer('1' * report_binary_size, 2)
  end

  def report_binary_size
    @_report_binary_size ||= reports.first.size
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
