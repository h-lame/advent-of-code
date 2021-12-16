class Solution
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map(&:chomp).map { |line| line.chars.map { |c| Integer(c) } }
    end
  end

  attr_reader :chiton_density

  def initialize(chiton_density)
    @chiton_density = chiton_density
  end

  def path
    shortest_path
  end

  def result
    shortest_path[:weight]
  end

  private

  def start
    @start ||= [0,0]
  end

  def finish
    @finish ||= [chiton_density.first.size - 1, chiton_density.size - 1]
  end

  def finish_weight
    @finish_weight ||= chiton_density[finish.last][finish.first]
  end

  def shortest_path(paths = [{route: [start], weight: 0}])
    loop do
      sorted = paths.sort_by { |path| path[:weight] }
      shortest = sorted.shift
      return shortest if shortest[:route].last == finish
      paths = step_along(path: shortest) + sorted
    end
  end

  def step_along(path:)
    next_steps = choices(path: path)
    if next_steps == :end
      [{route: path[:route] + [finish], weight: path[:weight] + finish_weight}]
    else
      next_steps.map do |next_step|
        {route: path[:route] + [next_step], weight: path[:weight] + chiton_density[next_step.last][next_step.first]}
      end
    end
  end

  def choices(path:)
    cur = path[:route].last
    max = (chiton_density.first.size + chiton_density.size) * 9
    @choices ||= Hash.new(max)

    # If we've already generated the possibilities for a point then we've been here before on a shorter path, so no point continuing, right?
    if @choices[cur] <= path[:weight]
      return []
    else
      possibilities = []
      # right
      possibilities << [cur.first + 1, cur.last] if cur.first + 1 < chiton_density.first.size
      # down
      possibilities << [cur.first, cur.last + 1] if cur.last + 1 < chiton_density.size
      # left
      possibilities << [cur.first - 1, cur.last] if cur.first > 0
      # up
      possibilities << [cur.first, cur.last - 1] if cur.last > 0

      @choices[cur] = path[:weight]
      if possibilities.detect { |choice| choice == finish }
        :end
      else
        possibilities
      end
    end
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
