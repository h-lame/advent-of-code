require 'csv'

class Solution
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map do |line|
        line.chomp.split('-')
      end
    end
  end

  attr_reader :paths

  def initialize(map)
    @map = map
  end

  def result
    paths.size
  end

  def paths
    return @paths if defined? @paths

    @paths = []
    walk(caves['start'], [caves['start']])
    @paths
  end

  private

  attr_reader :map

  def walk(from_cave, route)
    if from_cave.end?
      paths << route.map(&:name).join(',')
      return
    end

    from_cave.linked_caves.each do |link|
      next if link.start?

      if link.small?
        if route.detect { |x| x.name == link.name }.nil? ||
            route.select { |x| x.small? }.group_by { |x| x.name }.detect { |x| x.last.size == 2 }.nil?
          walk(link, route + [link])
        else
          next
        end
      else
        walk(link, route + [link])
      end
    end
  end

  def caves
    return @caves if defined? @caves

    @caves = {}
    map.flatten.uniq.map.with_object(@caves) { |cave| @caves[cave] = Cave.new(cave) }
    map.each do |route|
      @caves[route.first].linked_caves << @caves[route.last]
      @caves[route.last].linked_caves << @caves[route.first]
    end
    @caves
  end

  class Cave
    attr_reader :linked_caves, :name

    def initialize(name)
      @name = name
      @linked_caves = []
    end

    def start?
      return @start if defined? @start

      @start = (name == 'start')
    end

    def end?
      return @end if defined? @end

      @end = (name == 'end')
    end

    def big?
      return @big if defined? @big

      @big = name.match? /\A[A-Z]+\Z/
    end

    def small?
      return @small if defined? @small

      @small = name.match? /\A[a-z]+\Z/
    end
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
