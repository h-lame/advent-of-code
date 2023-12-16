class Solution2
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
      in :west
        tilt_west
      in :east
        tilt_east
      in :south
        tilt_south
      else
        raise "dunno yet"
      end
    end

    def spin(times = 1)
      iter = 0
      seen = {platform => 0}
      puts "Load for 0: #{load(:north)}"
      times.times do
        puts "Spin #{iter+1}"
        tilt(:north)
        tilt(:west)
        tilt(:south)
        tilt(:east)
        iter += 1
        puts "Load for #{iter}: #{load(:north)}"
        if seen.key? platform
          break
        else
          seen[platform] = iter
        end
      end
      if iter == times
        puts "Done (times = #{times} - seen = #{seen.size})"
      else
        puts "Found loop after #{iter} spins (#{seen.keys.size})"
        loop_iter = seen[self.platform]
        period = iter - loop_iter
        puts "Got back to #{loop_iter} iter; loop period is #{period}"
        puts "Spins left = #{times - iter}, need to do #{(times - iter) % period} extra spins to get to #{times}th spin e.g. take the #{loop_iter + ((times - iter)%period)}th iter"
        self.platform = seen.rassoc(loop_iter + ((times - iter)%period)).first
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

    def tilt_west
      self.platform = platform
        .map { |row| row.chars }
        .map { |col|
          col
            .chunk_while { |x,_| x != '#' }
            .map { |x| x.sort.reverse }
            .reduce([]) { |acc, r| acc + r }
        }
        .map { |x| x.join }
    end

    def tilt_south
      self.platform = platform
        .map { |row| row.chars }
        .transpose
        .map { |col|
          col
            .reverse!
            .chunk_while { |x,_| x != '#' }
            .map { |x| x.sort.reverse }
            .reduce([]) { |acc, r| acc + r }
        }
        .transpose
        .reverse
        .map { |x| x.join }
    end

    def tilt_east
      self.platform = platform
        .map { |row| row.chars }
        .map { |col|
          col
            .reverse
            .chunk_while { |x,_| x != '#' }
            .map { |x| x.sort.reverse }
            .reduce([]) { |acc, r| acc + r }
            .reverse
        }
        .map { |x| x.join }
    end
  end

  def initialize(platform)
    @platform = Platform.new(platform: platform)
  end

  def result
    platform.spin(1_000_000_000)
    platform.load(:north)
  end

  private

  attr_reader :platform

end

if __FILE__ == $0
  puts Solution2.new(Solution2::Normalizer.do_it(ARGV[0])).result
end
