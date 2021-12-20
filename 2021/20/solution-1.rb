class Solution
  class Normalizer
    def self.do_it(file_name)
      lines = File.readlines(file_name).map(&:chomp)
      [
        lines.first,
        lines[2..-1].map { |x| x.chars }
      ]
    end
  end

  def initialize(enhancement_algorithm, base_image)
    @enhancement_algorithm = enhancement_algorithm
    @base_image = base_image
  end

  def display(image = base_image)
    image.map { |row| row.join }.join("\n")
  end

  def enhance(iterations)
    image = base_image.map { |row| row.map { |pixel| pixel } }
    iterations.times do |step|
      default = (enhancement_algorithm[0] == '#' ? ((step % 2 == 1) ? '#' : '.') : '.')
      con_image = contract(image, default)
      exp_image = expand(con_image, default)
      enh_image = [
        *exp_image.map.with_index do |row, y|
          [
            *row.map.with_index do |pixel, x|
              focus = focus(x,y, exp_image, default)
              enhance_pixel(focus)
            end
          ]
        end
      ]
      image = enh_image
    end
    last_default = (enhancement_algorithm[0] == '#' ? ((iterations + 1 % 2 == 1) ? '#' : '.') : '.')

    contract(image, last_default)
  end

  def result
    lit(enhance(2))
  end

  private

  attr_reader :enhancement_algorithm, :base_image

  def contract(image, default)
    strip_count = 0
    blank_row = [default] * image.first.size
    image.each do |row|
      if row == blank_row
        strip_count += 1
      else
        break
      end
    end
    t_image = image.transpose
    blank_column = [default] * image.size
    safe_strip_count = 0
    strip_count.times do |c|
      if ((image[c] == blank_row) &&
          (image[-1 - c] == blank_row) &&
          (t_image[c] == blank_column) &&
          (t_image[-1 - c] == blank_column))
        safe_strip_count += 1
      else
        break
      end
    end
    image[safe_strip_count..(-1 - safe_strip_count)].map do |row|
      row[safe_strip_count..(-1 - safe_strip_count)]
    end
  end

  def lit(image)
    image.map { |row| row.count { |pixel| pixel == '#' } }.sum
  end

  def enhance_pixel(focus)
    enhancement_algorithm[Integer(focus.join.tr('.#', '01'), 2)]
  end

  def expand(image, default)
    [
      [default] * (image.first.size),
      [default] * (image.first.size),
      [default] * (image.first.size),
      *image,
      [default] * (image.first.size),
      [default] * (image.first.size),
      [default] * (image.first.size)].map do |row|
      [default, default, default, *row, default, default, default]
    end
  end

  def focus(x,y, image, default)
    focus = []
    if (y - 1) >= 0
      focus += focus_row(y-1, x, image, default)
    else
      focus += [default,default,default]
    end
    focus += focus_row(y, x, image, default)
    if (y + 1) < image.size
      focus += focus_row(y+1, x, image, default)
    else
      focus += [default,default,default]
    end
    focus
  end

  def focus_row(y, x, image, default)
    focus_row = []
    if (x - 1) >= 0
      focus_row << image[y][x - 1]
    else
      focus_row << default
    end
    focus_row << image[y][x]
    if (x + 1) < image[y].size
      focus_row << image[y][x + 1]
    else
      focus_row << default
    end
    focus_row
  end
end

if __FILE__ == $0
  puts Solution.new(*Solution::Normalizer.do_it(ARGV[0])).result
end
