class Solution
  class Normalizer
    def self.do_it(file_name)
      File.readlines(file_name).map &:chomp
    end

    def self.get_cubes(cube_string)
      blue = (cube_string.match(/(\d+) blue/) || [nil, 0])[1].to_i
      red = (cube_string.match(/(\d+) red/) || [nil, 0])[1].to_i
      green = (cube_string.match(/(\d+) green/) || [nil, 0])[1].to_i
      {blue: blue, red: red, green: green}
    end
  end

  Game = Data.define(:id, :reveals) do
    def possible?(question)
      reveals.all? do |reveal|
        reveal[:blue] <= question[:blue] &&
          reveal[:red] <= question[:red] &&
          reveal[:green] <= question[:green]
      end
    end
  end

  def initialize(games)
    @games = games
  end

  def result(question)
    selected_games(question).sum { |g| g.id }
  end

  def selected_games(question)
    prepared_games.select { |g| g.possible? question }
  end

  def prepared_games
    games.map do |g|
      id_str, reveals_str = g.split(':')
      id = id_str.match(/Game (\d+)/)[1].to_i
      reveals = reveals_str.split(';').map do |reveal_str|
        Solution::Normalizer.get_cubes(reveal_str)
      end
      Game.new id: id, reveals: reveals
    end
  end

  private

  attr_reader :games

end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result(Solution::Normalizer.get_cubes(ARGV[1..].join(' ')))
end
