class Solution2
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
      new(map: ([raw_report.first]*5).join('?'), group_counts: raw_report.last*5)
    end

    def initialize(map:, group_counts:)
      @groups = extract_groups(group_counts)
      @cache = { [] => [''] }
      super
    end

    attr_reader :groups, :cache

    def broken_cog_count = group_counts.sum

    def arrangements
      collect_arrangements(map, groups)
    end

    def collect_arrangements_from_hash(for_map, groups)
      expected_group = groups[0]

      cur_group = for_map[0..expected_group.size-1]
      cur_group.tr!('?','#')
      return 0 if cur_group != expected_group

      if for_map.size == expected_group.size
        return 1 if groups.size == 1
        return 0
      end

      if '?.'.include? for_map[expected_group.size]
        collect_arrangements(for_map[expected_group.size+1..], groups[1..])
      else
        0
      end
    end

    def collect_arrangements_from_dot(for_map, groups)
      collect_arrangements(for_map[1..], groups)
    end

    def collect_arrangements_from_wildcard(for_map, groups)
      collect_arrangements_from_dot(for_map, groups) + collect_arrangements_from_hash(for_map, groups)
    end

    def collect_arrangements(for_map, groups)
      if cache.key? [for_map, groups]
        #puts "Cache hit! #{for_map} x #{groups}"
        return cache[[for_map, groups]]
      end

      #puts "collecting from #{for_map} w/ #{groups}"
      if groups.empty?
        if for_map.include? '#'
          return 0
        else
          return 1
        end
      end

      if for_map.empty?
        return 0
      end

      cur = for_map[0]

      arrangements =
        if cur == '#'
          collect_arrangements_from_hash(for_map, groups)
        elsif cur == '.'
          collect_arrangements_from_dot(for_map, groups)
        elsif cur == '?'
          collect_arrangements_from_wildcard(for_map, groups)
        else
          raise "arg"
        end

      puts "For: #{for_map} + #{groups} = #{arrangements}"
      cache.store([for_map, groups], arrangements)
      arrangements
      # collected_arrangements = []
      #
      #
      # cur, *rest = *for_map
      # puts "looking at #{before} + #{cur} and generating from #{rest}"
      # if cur == '?'
      #   collected_arrangements += collect_arrangements(before + '.', rest).map { |x| '.' + x }
      #   collected_arrangements += collect_arrangements(before + '#', rest).map { |x| '#' + x }
      #   # new_state = before + '#'
      #   # new_groups = new_state.scan(/#/)
      #   # if new_groups.empty?
      #   #   collected_arrangements += collect_arrangements(new_state, rest)
      #   # else
      #   #   last_new_group = new_groups.pop
      #   #   if new_groups.empty?
      #   #     if last_new_group.size <= groups[0].size
      #   #       collected_arrangements += collect_arrangements(new_state, rest).map { |x| '#' + x }
      #   #     else
      #   #       puts "not checking # - #{new_state} doesn't match #{groups[0]}"
      #   #     end
      #   #   else
      #   #     if new_groups == groups[0..new_groups.size-1] && last_new_group.size <= groups[0].size
      #   #       collected_arrangements += collect_arrangements(new_state, rest).map { |x| '#' + x }
      #   #     else
      #   #       puts "not checking # - #{new_state} doesn't match #{groups[0..new_groups.size-1]}"
      #   #     end
      #   #   end
      #   # end
      # else
      #   collected_arrangements << collect_arrangements(before + cur, rest).map { |x| cur + x }
      # end
      # puts "#{for_map} - generated: #{collected_arrangements.size} arrangements"
      # cache.store(for_map, collected_arrangements.flatten(1))
      # #
      # # x = collect_arrangements(rest).map do |a|
      # #     if cur == '?'
      # #       [['.', *a], ['#', *a]]
      # #     else
      # #       [[cur, *a]]
      # #     end
      # #   end.flatten(1)
      # # puts "#{for_map} - generated: #{x}"
      # #cache.store(for_map, x)
      # #x
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
    prepared_cog_reports.map { |r| r.arrangements }.sum
  end

  private

  attr_reader :raw_cog_reports

  def prepared_cog_reports = raw_cog_reports.map { |raw_cog_report| CogReport.from_raw raw_cog_report }

end

if __FILE__ == $0
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
