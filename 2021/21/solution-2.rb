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
    @games = {
      # [[p1_pos, p1_score], [p2_pos, p2_score]] => count
      [[player_positions[0], 0], [player_positions[1], 0]] => 1
    }
    @dice = DiracDice.new
    @turns_taken = 0
  end

  def result
    play_until_all_games_complete!
    @games
      .group_by { |g, c| g.first.last >= 21 ? 0 : 1 } # [0, [ [[(pos, score), (pos, score)], count], [[(pos, score), (pos, score)], count], ...]]
      .map { |_w, gs| gs.sum { |g, c| c } }.max
  end

  def turn!
    puts "Looking at #{games.keys.size} unique games (#{games.values.sum} total, #{games.count { |g,_c| over?(g) }} unique over, #{games.sum { |g,c| over?(g) ? c : 0 }} total over)"
    new_games = {}
    games.each do |game, count|
      next if count == 0
      if over? game
        new_games[game] ||= 0
        new_games[game] += count
        next
      end
      dice.rolls.each do |three_rolls_of_the_dice|
        player = self.turns_taken % 2
        new_game = [
          (player.zero? ? take_turn!(three_rolls_of_the_dice, game.first) : game.first),
          (player.zero? ? game.last : take_turn!(three_rolls_of_the_dice, game.last)),
        ]
        new_games[new_game] ||= 0
        new_games[new_game] += count
      end
    end
    @games = new_games
    puts "Took one turn (rolled dirac 3 times to bifurcate #{dice.rolls.size} times, now we have unique games (#{games.values.sum} total, #{games.count { |g,_c| over?(g) }} unique over, #{games.sum { |g,c| over?(g) ? c : 0 }} total over)"
    self.turns_taken += 1
  end

  def over?(game)
    game.any? { |x| x.last >= 21 }
  end

  attr_reader :games

  private

  attr_reader :dice
  attr_accessor :turns_taken

  def take_turn!(dice_rolls, player)
    move = dice_rolls.sum
    position, score = *player
    step_1 = 10 - position
    position = (move - step_1) % 10
    position = 10 if position.zero?
    [position, score += position]
  end

  def play_until_all_games_complete!
    loop do
      break if games.keys.all? { |g| over?(g) }
      turn!
    end
  end

  class DiracDice
    ROLLS = [
      [1,1,1],
      [1,1,2],
      [1,1,3],
      [1,2,1],
      [1,2,2],
      [1,2,3],
      [1,3,1],
      [1,3,2],
      [1,3,3],
      [2,1,1],
      [2,1,2],
      [2,1,3],
      [2,2,1],
      [2,2,2],
      [2,2,3],
      [2,3,1],
      [2,3,2],
      [2,3,3],
      [3,1,1],
      [3,1,2],
      [3,1,3],
      [3,2,1],
      [3,2,2],
      [3,2,3],
      [3,3,1],
      [3,3,2],
      [3,3,3],
    ].freeze

    def initialize
      @rolled = 0
    end

    def rolls
      @rolled += 3
      ROLLS
    end

    attr_reader :rolled
  end

  class Player
    def initialize(starting_position)
      @score = 0
      @position = starting_position
    end

    def take_turn!(dice_rolls)
      move = dice_rolls.sum
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
      @score >= 21
    end

    attr_reader :position, :score

    private

    attr_writer :position, :score
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
#
# class Solution
#   class Normalizer
#     def self.do_it(file_name)
#       lines = File.readlines(file_name).map(&:chomp)
#       [
#         Integer(lines[0].match(/\APlayer 1 starting position: (\d+)\Z/)[1]),
#         Integer(lines[1].match(/\APlayer 2 starting position: (\d+)\Z/)[1]),
#       ]
#     end
#   end
#
#   def initialize(player_positions)
#     # position -> turns -> [ score ]
#     @p1_positions = Hash.new { Hash.new { [0] * 22 } }
#     @p2_positions = Hash.new { Hash.new { [0] * 22 } }
#     @p1_positions[player_positions[0]][0] += 0
#     @p2_positions[player_positions[0]][0] += 0
#     @dice = DiracDice.new
#     @turns_taken = 0
#   end
#
#   1 + 3
#
#   def result
#     play_until_all_games_complete!
#     p1_wins = @p1_positions.map { |x| x[21] }.sum
#     p2_wins = @p2_positions.map { |x| x[21] }.sum
#     p1_wins > p2_wins ? p1_wins : p2_wins
#   end
#
#   def turn!
#     @games = games.map do |game|
#       dice.rolls.map do |three_rolls_of_the_dice|
#         new_world = [game.first.dup, game.last.dup]
#         player = new_world[self.turns_taken % 2]
#         player.take_turn!(three_rolls_of_the_dice)
#         new_world
#       end
#     end.flatten(1)
#     puts "Took one turn (rolled diract 3 times to bifurcate #{dice.rolls.size} times, now we have #{games.size} games"
#     self.turns_taken += 1
#   end
#
#   def over?(game)
#     game.any? { |p| p.winner? }
#   end
#
#   attr_reader :games
#
#   private
#
#   attr_reader :dice
#   attr_accessor :turns_taken
#
#   def play_until_all_games_complete!
#     loop do
#       break if games.all? { |g| over?(g) }
#       turn!
#     end
#   end
#
#   class DiracDice
#     ROLLS = [
#       [1,1,1], # 3
#       [1,1,2], # 4
#       [1,1,3], # 5
#       [1,2,1], # 4
#       [1,2,2], # 5
#       [1,2,3], # 6
#       [1,3,1], # 5
#       [1,3,2], # 6
#       [1,3,3], # 7
#       [2,1,1], # 4
#       [2,1,2], # 5
#       [2,1,3], # 6
#       [2,2,1], # 5
#       [2,2,2], # 6
#       [2,2,3], # 7
#       [2,3,1], # 6
#       [2,3,2], # 7
#       [2,3,3], # 8
#       [3,1,1], # 5
#       [3,1,2], # 6
#       [3,1,3], # 7
#       [3,2,1], # 6
#       [3,2,2], # 7
#       [3,2,3], # 8
#       [3,3,1], # 7
#       [3,3,2], # 8
#       [3,3,3], # 9
#     ].freeze
#
#     def initialize
#       @rolled = 0
#     end
#
#     def rolls
#       @rolled += 3
#       ROLLS
#     end
#
#     attr_reader :rolled
#   end
#
#   class Player
#     def initialize(starting_position)
#       @score = 0
#       @position = starting_position
#     end
#
#     def take_turn!(dice_rolls)
#       move = dice_rolls.sum
#       if position + move <= 10
#         self.position += move
#       else
#         step_1 = 10 - position
#         self.position = (move - step_1) % 10
#         self.position = 10 if self.position.zero?
#       end
#       self.score += position
#     end
#
#     def winner?
#       @score >= 21
#     end
#
#     attr_reader :position, :score
#
#     private
#
#     attr_writer :position, :score
#   end
# end
#
# if __FILE__ == $0
#   puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
# end
