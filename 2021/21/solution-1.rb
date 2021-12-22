class Solution
  class Normalizer
    def self.do_it(file_name)
      lines = File.readlines(file_name).map(&:chomp)
      [
        Integer(lines[0].match(/\APlayer 1 starting position: (\d+)\Z/)[1]),
        Integer(lines[1].match(/\APlayer 2 starting position: (\d+)\Z/)[1]),
      ]
    end
  end

  def initialize(player_positions)
    @player_one = Player.new(player_positions[0])
    @player_two = Player.new(player_positions[1])
    @dice = DeterministicDice.new
    @turns_taken = 0
  end

  def result
    play_until_winner_found!
    (player_one.winner? ? player_two.score : player_one.score) * dice.rolled
  end

  def turn!
    player = [player_one, player_two][self.turns_taken % 2]
    player.take_turn!(dice)
    self.turns_taken += 1
  end

  def over?
    [player_one, player_two].any? { |p| p.winner? }
  end

  attr_reader :player_one, :player_two

  private

  attr_reader :dice
  attr_accessor :turns_taken

  def play_until_winner_found!
    loop do
      break if over?
      turn!
    end
  end

  class DeterministicDice
    def initialize
      @next_number = 1
      @rolled = 0
    end

    def roll
      @rolled += 1
      @next_number.tap { |_| calculate_next_number }
    end

    attr_reader :rolled

    private

    def calculate_next_number
      @next_number += 1
      @next_number = 1 if @next_number > 100
    end
  end

  class Player
    def initialize(starting_position)
      @score = 0
      @position = starting_position
    end

    def take_turn!(dice)
      move = 3.times.sum { |_| dice.roll }
      if position + move <= 10
        self.position += move
      else
        step_1 = 10 - position
        self.position = (move - step_1) % 10
        self.position = 10 if self.position.zero?
      end
      self.score += position
    end

    def winner?
      @score >= 1000
    end

    attr_reader :position, :score

    private

    attr_writer :position, :score
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
