class Solution1
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp).reject { |x| x == '' }
    end
  end

  Map = Data.define(:seeds, :maps) do
    PATH = ['soil', 'fertilizer', 'water', 'light', 'temperature', 'humidity', 'location']
    def self.generate_from(almanac)
      seed_str = almanac.shift
      seeds = seed_str.split(':').last.scan(/\d+/).map(&:to_i)
      maps_strs = almanac.slice_before { |x| x.match(/:/) }
      maps = maps_strs.map do |map_strs|
        generate_individual_map_from(map_strs)
      end
      new(seeds: seeds, maps: Hash[maps])
    end

    def self.generate_individual_map_from(almanac_entry)
      map_type_str = almanac_entry.shift
      key = map_type_str.split('to-').last.split(' ').first
      mapping_procs = almanac_entry.map do |map_str|
        destination, source, size = *map_str.scan(/\d+/).map(&:to_i)
        [(source..source+size-1), ->(x) { destination - source + x }]
        #size.times.map { |i| [source + i, destination + i] }
      end#.flatten(1)
      mappings_func = -> (x) do
        mapping = mapping_procs.detect { |mapping| mapping.first.cover? x }
        if mapping
          mapping.last.(x)
        else
          x
        end
      end
      [key, mappings_func]
    end

    def path_to(key, seed:)
      path, _ = *PATH.slice_after { |p| p == key }
      at = seed
      Hash[path.each_with_object({}) do |step, route|
        route[step.to_sym] = at = maps[step].(at)
      end]
    end
  end

  def initialize(almanac)
    @almanac = almanac
  end

  def result
    prepared_almanac.seeds.map { |x| prepared_almanac.path_to('location', seed: x)[:location] }.min
  end

  def prepared_almanac
    return @prepared_almanac if defined? @prepared_almanac

    @prepared_almanac = Solution1::Map.generate_from(almanac)
  end

  private

  attr_reader :almanac

end

if __FILE__ == $0
  puts Solution1.new(Solution1::Normalizer.do_it(ARGV[0])).result
end
