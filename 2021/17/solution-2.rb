class Solution
  class Normalizer
    def self.do_it(file_name)
      Hash[File.read(file_name).chomp.split(':').last.strip.split(', ').map do |dimension|
        axis, range = *dimension.split('=')
        [axis.to_sym, Range.new(*range.split('..').map { |x| Integer(x) })]
      end]
    end
  end

  def initialize(target_area)
    @target_area = target_area
  end

  def fire(x_velocity, y_velocity)
    FiringPlan.new(x_velocity, y_velocity, target_area).tap { |fp| fp.execute! }
  end

  def firing_plans
    return @firing_plans if defined? @firing_plans

    @firing_plans = valid_x_velocities.map do |x|
      valid_y_velocities.map do |y|
        FiringPlan.new(x, y, target_area).tap { |fp| fp.execute! }
      end
    end.flatten.select { |fp| fp.hit_target? }
  end

  def result
    firing_plans.size
  end

  private

  attr_reader :target_area

  def valid_x_velocities
    return @valid_x_velocities if defined? @valid_x_velocities

    @valid_x_velocities = []
    across_steps = (1..).lazy.map { |s| (s * (s + 1)) / 2 }
    (1..target_area[:x].max).each do |x|
      across_steps.take(x).each do |x_step|
        break if x_step > target_area[:x].max
        if target_area[:x].cover? x_step
          @valid_x_velocities << x
          break
        end
      end
    end
    @valid_x_velocities
  end

  def valid_y_velocities
    return @valid_y_velocities if defined? @valid_y_velocities

    @valid_y_velocities = []
    down_steps = (1..).lazy.map { |s| (s * (s + 1)) / 2 }
    # Found the uppper bound through exploratory testing, not logic
    # I _think_ it's because once you go up as much as the lower bound
    # then by the time you come down, you'll already be overshooting...
    # I'm not sold on that reasoning though...
    (target_area[:y].min..target_area[:y].min.abs).each do |y|
      up = (y * (y + 1))/2
      down_range = (up - target_area[:y].max)..(up - target_area[:y].min)
      down_steps.each do |down_step|
        break if down_step > down_range.max
        if down_range.cover? down_step
          @valid_y_velocities << y
          break
        end
      end
    end
    @valid_y_velocities
  end

  class FiringPlan
    def initialize(x_velocity, y_velocity, target_area)
      @x_velocity = @initial_x_velocity = x_velocity
      @y_velocity = @initial_y_velocity = y_velocity
      @target_area = target_area
      @position = [0,0]
      @step_count = 0
    end

    def plan
      [initial_x_velocity, initial_y_velocity]
    end

    def execute!
      loop do
        break if hit_target?
        break if missed_target?
        step!
      end
    end

    def max_distance
      (initial_x_velocity * (initial_x_velocity + 1))/2
    end

    def max_height
      (initial_y_velocity * (initial_y_velocity + 1))/2
    end

    def hit_target?
      target_area[:x].cover?(position.first) && target_area[:y].cover?(position.last)
    end

    def missed_target?
      position.first > target_area[:x].max || position.last < target_area[:y].min
    end

    def hit_target_on
      step_count
    end

    def missed_target_on
      step_count
    end

    private

    attr_accessor :x_velocity, :y_velocity, :step_count, :initial_x_velocity, :initial_y_velocity
    attr_reader :target_area, :position

    def step!
      # The probe's x position increases by its x velocity.
      position[0] += x_velocity
      # The probe's y position increases by its y velocity.
      position[1] += y_velocity
      # Due to drag, the probe's x velocity changes by 1 toward the value 0; that is, it decreases by 1 if it is greater than 0, increases by 1 if it is less than 0, or does not change if it is already 0.
      if x_velocity > 0
        self.x_velocity -= 1
      elsif x_velocity < 0
        self.x_velocity += 1
      end
      # Due to gravity, the probe's y velocity decreases by 1.
      self.y_velocity -= 1
      self.step_count += 1
    end
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
