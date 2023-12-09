class Solution2
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp).map { |x| x.scan(/-?\d+/).map(&:to_i) }
    end
  end

  History = Data.define(:readings) do
    def next_reading
      next_rows = extrapolate_rows
      readings[0] - next_rows[0][0]
    end

    def extrapolate_rows
      rows = []
      row = readings
      while !(row.all? &:zero?)
        rows << row = row.each_cons(2).map { |x| x[1] - x[0] }
      end
      rows.reverse.map.with_index do |row, idx|
        if idx.zero?
          row.append 0
          row.prepend 0
        else
          prev_row = rows[0-idx]
          row.append row[-1] + prev_row[-1]
          row.prepend row[0] - prev_row[0]
        end
        row
      end.reverse
    end
  end

  def initialize(readings)
    @raw_readings = readings
  end

  def result
    prepared_readings.sum { |r| r.next_reading }
  end

  private

  attr_reader :raw_readings

  def prepared_readings = raw_readings.map { |reading| History.new reading }

end

if __FILE__ == $0
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
