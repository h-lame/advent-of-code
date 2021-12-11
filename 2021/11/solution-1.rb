require 'csv'

class Solution
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map do |line|
        line.chomp.chars.map { |char| Integer(char) }
      end
    end
  end

  def initialize(octopus_grid)
    @octopus_grid_initial_state = octopus_grid
  end

  def simulate(steps:)
    reset_simulation!
    # display_state("Initial State")
    steps.times do |x|
      raise_energy!
      flash!
      # display_state(x)
    end
    octopus_grid
  end

  def result
    simulate(steps: 100)
    flash_count
  end

  private

  attr_reader :octopus_grid_initial_state
  attr_accessor :flash_count, :octopus_grid

  def raise_energy!
    self.octopus_grid = self.octopus_grid.map { |row| row.map { |octopus_energy| octopus_energy + 1 } }
  end

  def reset_simulation!
    self.flash_count = 0
    self.octopus_grid = octopus_grid_initial_state.map { |row| row.dup }
  end

  def flash!(pass = 0, extra_energy = octopus_grid.map { |row| row.map { |_x| 0 } })
    extra_flashes = 0
    octopus_grid.each.with_index do |row, y|
      row.each.with_index do |energy, x|
        if energy > 9
          extra_flashes += 1
          extra_energy[y][x] = nil
          if y - 1 >= 0
            extra_energy[y - 1][x - 1] += 1 if x - 1 >= 0 && extra_energy[y - 1][x - 1]
            extra_energy[y - 1][x]     += 1 if extra_energy[y - 1][x]
            extra_energy[y - 1][x + 1] += 1 if x + 1 < extra_energy[y].size && extra_energy[y - 1][x + 1]
          end
          extra_energy[y][x - 1] += 1 if x - 1 >= 0 && extra_energy[y][x - 1]
          extra_energy[y][x + 1] += 1 if x + 1 < extra_energy[y].size && extra_energy[y][x + 1]
          if y + 1 < extra_energy.size
            extra_energy[y + 1][x - 1] += 1 if x - 1 >= 0 && extra_energy[y + 1][x - 1]
            extra_energy[y + 1][x]     += 1 if extra_energy[y + 1][x]
            extra_energy[y + 1][x + 1] += 1 if x + 1 < extra_energy[y].size && extra_energy[y + 1][x + 1]
          end
        end
      end
    end
    self.octopus_grid = extra_energy.map.with_index { |row, y| row.map.with_index { |energy, x| energy.nil? ? 0 : octopus_grid[y][x] + energy } }
    self.flash_count += extra_flashes
    flash!(pass+1, extra_energy.map { |row| row.map { |x| x.nil? ? x : 0 }}) unless extra_flashes.zero?
  end

  def display_state(step)
    puts octopus_grid.map { |row| row.map(&:to_s).join }.join("\n")
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
