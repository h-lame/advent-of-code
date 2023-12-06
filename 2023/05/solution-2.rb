class Solution2
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp).reject { |x| x == '' }
    end
  end

  Map = Data.define(:seeds, :maps) do
    PATH = ['soil', 'fertilizer', 'water', 'light', 'temperature', 'humidity', 'location']
    def self.generate_from(almanac)
      seed_str = almanac.shift
      seeds = generate_seeds_from(seed_str)
      maps_strs = almanac.slice_before { |x| x.match(/:/) }
      maps = maps_strs.map do |map_strs|
        generate_individual_map_from(map_strs)
      end
      new(seeds: seeds, maps: Hash[maps])
    end

    def self.generate_seeds_from(almanac_entry)
      almanac_entry
        .split(':')
        .last
        .scan(/\d+/)
        .map(&:to_i)
        .each_slice(2)
        .map do |(start, size)|
          (start..start+size-1)
        end.flatten
    end

    def self.generate_individual_map_from(almanac_entry)
      map_type_str = almanac_entry.shift
      key = map_type_str.split('to-').last.split(' ').first
      mappings = almanac_entry.map do |map_str|
        destination, source, size = *map_str.scan(/\d+/).map(&:to_i)
        [(source..source+size-1), destination - source]
        #size.times.map { |i| [source + i, destination + i] }
      end#.flatten(1)
      # mappings_func = -> (x) do
      #   mapping = mapping_procs.detect { |mapping| mapping.first.cover? x }
      #   if mapping
      #     mapping.last + x
      #   else
      #     x
      #   end
      # end
      # [key, mappings_func]
      [key, mappings]
    end

    def self.merge_range_into(range, ranges)
      return [range] if ranges == []
      merged = []
      ranges.each do |r|
        z = split_ranges(r, range)
        if z.include? range
          merged << r
        else
          *all, last = *z
          merged += all
          range = last
        end
        # puts "splitting #{r} into #{range}, got #{z}, merged now: #{merged}, range now: #{range}"
      end
      merged << range
      merged.tap { |r| r.sort_by! { |x| x.first.begin } }
      # ranges.map do |r|
      #   z = split_ranges(r, range)
      #   puts "splitting #{r} into #{range}, got #{z}"
      #   z
      # end.flatten(1).tap(&:uniq!).tap { |r| r.sort_by! { |x| x.first.begin } }
    end

    def self.split_ranges(range_1_and_mod, range_2_and_mod)
      return [] if (range_1_and_mod == nil) && (range_1_and_mod == nil)
      return [range_1_and_mod] if range_2_and_mod == nil
      return [range_2_and_mod] if range_1_and_mod == nil

      r1, r1mod = *range_1_and_mod
      r2, r2mod = *range_2_and_mod

      if (r1.min == r2.min) && (r1.max == r2.max)
        [[r1, r1mod+r2mod]]
      elsif ((r1.min < r2.min) && (r1.max < r2.min)) ||
             ((r2.min < r1.min) && (r2.max < r1.min))
        [range_1_and_mod, range_2_and_mod]
      elsif r2.size == 1
        if r1.min == r2.min
          [[r1.min..r2.min, r1mod+r2mod], [(r1.min+1)..r1.max, r1mod]]
        elsif r1.max == r2.max
          [[r1.min..r1.max-1, r1mod], [r2, r1mod+r2mod]]
        else
          [[r1.min..r2.min-1, r1mod], [r2, r1mod+r2mod], [r2.max+1..r1.max, r1mod]]
        end
      elsif r1.size == 1
        if r1.min == r2.min
          [[r1, r1mod+r2mod], [(r2.min+1)..r2.max, r2mod]]
        elsif r1.max == r2.max
          [[r2.min..r1.max-1, r2mod], [r1, r1mod+r2mod]]
        else
          [[r2.min..r1.min-1, r2mod], [r1, r1mod+r2mod], [r1.max+1..r2.max, r2mod]]
        end
      elsif r1.min == r2.min
        if r2.max < r1.max
          [[r1.min..r2.max, r1mod+r2mod], [(r2.max+1)..r1.max, r1mod]]
        elsif r2.max > r1.max
          [[r1, r1mod+r2mod], [(r1.max+1)..r2.max, r2mod]]
        end
      elsif r1.min < r2.min
        if r1.max > r2.max
          [[r1.min..r2.min-1, r1mod], [r2, r1mod+r2mod], [r2.max+1..r1.max, r1mod]]
        elsif r1.max == r2.max
          [[r1.min..r2.min-1, r1mod], [r2.min..r1.max, r1mod+r2mod]]
        elsif r1.max < r2.max
          [[r1.min..r2.min-1, r1mod], [r2.min..r1.max, r1mod+r2mod], [r1.max+1..r2.max, r2mod]]
        end
      elsif r1.min > r2.min
        if r1.max < r2.max
          [[r2.min..r1.min-1, r2mod], [r1, r1mod+r2mod], [r1.max+1..r2.max, r2mod]]
        elsif r1.max == r2.max
          [[r2.min..r1.min-1, r2mod], [r1, r1mod+r2mod]]
        elsif r1.max > r2.max
          [[r2.min..r1.min-1, r2mod], [r1.min..r2.max, r1mod+r2mod], [r2.max+1..r1.max, r1mod]]
        end
      end
    end

    def initialize(seeds:, maps: )
      @ranges = maps.reduce([]) do |merged, map|
        _key, mappings = *map
        mappings.sort_by! { |m| m.first.begin }
        m = mappings.reduce(merged) do |merged, mapping|
          o = self.class.merge_range_into(mapping, merged)
          # puts "merging #{mapping} into #{merged}, got #{o}"
          o
        end
        # puts "end state = #{m}"
        m = m.tap(&:uniq!)#.tap { |r| r.sort_by! { |x| x.first.begin } }
        # puts "and flattedn + uniqued: #{m}"
        m
      end
      super
    end

    attr_reader :ranges

    def seed_count
      seeds.sum { |seed_generator| seed_generator.size }
    end

    def each_seed(&block)
      seeds.each do |seed_generator|
        seed_generator.each(&block)
      end
    end

    def path_to(key, seed:)
      path, _ = *PATH.slice_after { |p| p == key }
      at = seed
      Hash[path.each_with_object({}) do |step, route|
        route[step.to_sym] = at = maps[step].(at)
      end]
    end

    def location_for(seed)
      (ranges.detect do |(range, _change)|
        range.cover? seed
      end&.last || 0) + seed
    end
  end

  def initialize(almanac)
    @almanac = almanac
  end

  def result
    smallest = nil
    iters = 0
    puts "Seed count: #{prepared_almanac.seed_count}"
    prepared_almanac.each_seed do |seed|
      print '.' if (iters % 10_000) == 0
      iters+=1
      loc = prepared_almanac.location_for(seed)
      smallest = loc if smallest.nil? || smallest >= loc
    end
    smallest
  end

  def prepared_almanac
    return @prepared_almanac if defined? @prepared_almanac

    @prepared_almanac = Solution2::Map.generate_from(almanac)
  end

  private

  attr_reader :almanac

end

if __FILE__ == $0
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
