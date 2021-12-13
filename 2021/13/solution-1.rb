class Solution
  class Normalizer
    def self.do_it(file_name)
      marks, folds = *File.readlines(file_name).map(&:chomp).chunk do |line|
        if line =~ /\A\Z/
          nil
        elsif line =~ /\A\d+,\d+\Z/
          'marks'
        else
          'folds'
        end
      end
      [
        marks.last.map { |marks| marks.split(',').map { |mark| Integer(mark) } },
        folds.last.map do |folds|
          axis, magnitude = *folds.gsub('fold along ', '').split('=')
          [
            axis.to_sym,
            Integer(magnitude)
          ]
        end
      ]
    end
  end

  def initialize(marks, folds)
    @marks = marks
    @folds = folds
    mark_paper!
  end

  def result
    apply_fold(folds.first)
    paper.sum { |row| row.compact.size }
  end

  private

  attr_reader :marks, :folds, :paper

  def apply_fold(fold)
    case fold.first
    when :x
      apply_vertical_fold(fold.last)
    when :y
      apply_horizontal_fold(fold.last)
    end
  end

  def apply_horizontal_fold(row)
    base = paper[0..row-1]
    fold = paper[row+1..-1]
    @paper = base.map.with_index do |row, y|
      row.map.with_index do |mark, x|
        mark || fold[-1 - y][x]
      end
    end
  end

  def apply_vertical_fold(column)
    @paper = paper.map do |row|
      base = row[0..column-1]
      fold = row[column+1..-1]
      base.map.with_index do |mark, x|
        mark || fold[-1 - x]
      end
    end
  end

  def mark_paper!
    @paper = []
    marks.map do |(x,y)|
      @paper[y] ||= []
      @paper[y][x] = '#'
    end
    @paper
  end
end

if __FILE__ == $0
  puts Solution.new(*Solution::Normalizer.do_it(ARGV[0])).result
end
