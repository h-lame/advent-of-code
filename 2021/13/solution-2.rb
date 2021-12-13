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
    folds.each { |fold| apply_fold(fold) }
    display_paper
  end

  private

  attr_reader :marks, :folds, :paper

  def display_paper(paper = self.paper)
    paper.map { |row| display_paper_row(row) }.join "\n"
  end

  def display_paper_row(row)
    row.map { |cell| cell.nil? ? '.' : cell }.join
  end

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
    @paper = base.reverse.zip(fold).reverse.map do |base_row, fold_row|
      base_row.map.with_index { |base_mark, x| base_mark || (fold_row || [])[x] }
    end
  end

  def apply_vertical_fold(column)
    @paper = paper.map do |paper_column|
      base = paper_column[0..column-1]
      fold = paper_column[column+1..-1]
      base.reverse.zip(fold).reverse.map { |(base_mark, fold_mark)| base_mark || fold_mark }
    end
  end

  def mark_paper!
    x_size = marks.max_by { |mark| mark.first }.first
    y_size = marks.max_by { |mark| mark.last }.last
    @paper = Array.new(y_size + 1).map { |_x| Array.new(x_size + 1) }
    marks.map do |(x,y)|
      @paper[y][x] = '#'
    end
    @paper
  end
end

if __FILE__ == $0
  puts Solution.new(*Solution::Normalizer.do_it(ARGV[0])).result
end
