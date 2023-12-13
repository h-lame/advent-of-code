class Solution1
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp).map do |line|
        cog_map, cog_group_counts = line.split(' ')

        [cog_map, cog_group_counts.scan(/\d+/).map(&:to_i)]
      end
    end
  end

  CogReport = Data.define(:map, :group_counts) do
    def self.from_raw(raw_report)
      new(map: raw_report.first, group_counts: raw_report.last)
    end

    def initialize(map:, group_counts:)
      @groups = extract_groups(group_counts)
      super
    end

    attr_reader :groups

    def arrangements
      collect_arrangements(map.chars).select do |x|
        valid_map? x.join
      end
    end

    def collect_arrangements(for_map)
      return [[]] if for_map == []
      collected_arrangements = []
      collect = ''
      cur, *rest = *for_map
      collect_arrangements(rest).map do |a|
        if cur == '?'
          [['.', *a], ['#', *a]]
        else
          [[cur, *a]]
        end
      end.flatten(1)
    end

    private

    def valid_map?(potential_map)
      potential_map.scan(/#+/) == groups
    end

    def extract_groups(group_counts_to_extract)
      group_counts_to_extract.map { |gc| '#' * gc }
    end
  end

  def initialize(cog_reports)
    @raw_cog_reports = cog_reports
  end

  def result
    prepared_cog_reports.map { |r| r.arrangements.size }.sum
  end

  private

  attr_reader :raw_cog_reports

  def prepared_cog_reports = raw_cog_reports.map { |raw_cog_report| CogReport.from_raw raw_cog_report }

end

if __FILE__ == $0
  puts Solution1.new(Solution1::Normalizer.do_it(ARGV[0])).result
end
