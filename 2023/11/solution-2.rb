class Solution2
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp)
    end
  end

  Universe = Data.define(:universe) do
    def initialize(universe:)
      universe = expand_universe(universe)
      @galaxies = extract_galaxies(universe)
      super
    end

    def expanded_size
      x_expansion = universe.first.count 'x'
      y_expansion = universe.transpose.first.count 'x'

      [
        (expanded.first.size - x_expansion) + (x_expansion * 1_000_000),
        (expanded.size - y_expansion) + (y_expansion * 1_000_000),
      ]
    end

    def shortest_paths = pairs.map { |pair| distance(*pair) }.sum

    def distance(galaxy_a, galaxy_b)
      (galaxy_a.first - galaxy_b.first).abs + (galaxy_a.last - galaxy_b.last).abs
    end

    def expanded = universe.map { |ur| ur.join }

    def pairs = galaxies.combination(2)

    attr_reader :galaxies

    private

    def expand_universe(universe_to_expand)
      expand_rows(universe_to_expand.map { |ur| ur.chars })
        .transpose
        .then { |u| expand_rows(u) }
        .transpose
    end

    def expand_rows(universe_to_expand)
      universe_to_expand.map do |universal_row|
        if universal_row.include? '#'
          universal_row
        else
          ['x'] * universal_row.size
        end
      end
    end

    def extract_galaxies(universe_to_extract)
      galaxies = []
      y_expansion = 0
      y = 0
      universe_to_extract.each do |universal_row|
        if universal_row.uniq == ['x']
          y += 1_000_000
          next
        end

        x = 0
        universal_row.each do |space|
          if space == 'x'
            x += 1_000_000
            next
          end

          galaxies << [x, y] if space == '#'
          x += 1
        end

        y += 1
      end
      galaxies
    end
  end

  def initialize(universe)
    @raw_universe = universe
  end

  def result
    prepared_universe.shortest_paths
  end

  private

  attr_reader :raw_universe

  def prepared_universe = Universe.new raw_universe

end

if __FILE__ == $0
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
