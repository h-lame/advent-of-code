class Solution1
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp)
    end
  end

  Platform = Struct.new(:platform) do
    def load(direction)
      case direction
      in :north
        s = platform.size
        platform.map.with_index { |row, idx|
          row.count('O') * (s - idx)
        }.sum
      else
        raise "dunno yet"
      end
    end

    def tilt(direction)
      case direction
      in :north
        tilt_north
      else
        raise "dunno yet"
      end
    end

    def render = platform

    private :platform
    private

    def tilt_north
      self.platform = platform
        .map { |row| row.chars }
        .transpose
        .map { |col|
          col
            .chunk_while { |x,_| x != '#' }
            .map { |x| x.sort.reverse }
            .reduce([]) { |acc, r| acc + r }
        }
        .transpose
        .map { |x| x.join }
    end
  end

  def initialize(platform)
    @platform = Platform.new(platform: platform)
  end

  def result
    platform.tilt(:north)
    platform.load(:north)
  end

  private

  attr_reader :platform

end

if __FILE__ == $0
  puts Solution1.new(Solution1::Normalizer.do_it(ARGV[0])).result
end
