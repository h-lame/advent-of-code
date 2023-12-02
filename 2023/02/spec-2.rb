require File.join(__dir__, 'solution-2')

RSpec.describe Solution do
  let(:raw_games) { [
    'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green',
    'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue',
    'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red',
    'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red',
    'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green',
  ] }
  let(:prepared_games) { [
    Solution::Game.new(
      id: 1,
      reveals: [
        {blue: 3, red: 4, green: 0},
        {blue: 6, red: 1, green: 2},
        {blue: 0, red: 0, green: 2}
      ]
    ),
    Solution::Game.new(
      id: 2,
      reveals: [
        {blue: 1, red: 0, green: 2},
        {blue: 4, red: 1, green: 3},
        {blue: 1, red: 0, green: 1}
      ]
    ),
    Solution::Game.new(
      id: 3,
      reveals: [
        {blue: 6, red: 20, green: 8},
        {blue: 5, red: 4, green: 13},
        {blue: 0, red: 1, green: 5}
      ]
    ),
    Solution::Game.new(
      id: 4,
      reveals: [
        {blue: 6, red: 3, green: 1},
        {blue: 0, red: 6, green: 3},
        {blue: 15, red: 14, green: 3}
      ]
    ),
    Solution::Game.new(
      id: 5,
      reveals: [
        {blue: 1, red: 6, green: 3},
        {blue: 2, red: 1, green: 2}
      ]
    ),
  ] }
  let(:question) { {blue: 14, red: 12, green: 13} }
  let(:selected_games) { [
    prepared_games[0],
    prepared_games[1],
    prepared_games[4]
  ] }

  describe Solution::Normalizer do
    it 'converts a file into an array of strings, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_games
    end

    it 'converts a string into a hash of blue, red, green counts including 0 for missing colours' do
      expect(described_class.get_cubes '12 red, 13 green, 14 blue').to eq question
    end
  end

  describe Solution::Game do
    it 'is possible given a question, if each colour in the reveals is less than the question amount' do
      game = prepared_games[0]
      expect(game.possible? blue: 14, red: 12, green: 13).to be_truthy
      expect(game.possible? blue: 0, red: 0, green: 0).to be_falsey
      expect(game.possible? blue: 6, red: 4, green: 2).to be_truthy
      expect(game.possible? blue: 5, red: 4, green: 2).to be_falsey
      expect(game.possible? blue: 6, red: 3, green: 2).to be_falsey
      expect(game.possible? blue: 6, red: 4, green: 1).to be_falsey
    end

    it 'can extract the minimum possible cubes needed to support the reveals - choosing the largest number for each colour from all reveals' do
      expect(prepared_games[0].minimum_possible).to eq({blue: 6, red: 4, green: 2})
      expect(prepared_games[1].minimum_possible).to eq({blue: 4, red: 1, green: 3})
      expect(prepared_games[2].minimum_possible).to eq({blue: 6, red: 20, green: 13})
      expect(prepared_games[3].minimum_possible).to eq({blue: 15, red: 14, green: 3})
      expect(prepared_games[4].minimum_possible).to eq({blue: 2, red: 6, green: 3})
    end

    it 'calculates the minimum power of a game by multiplying the minimum possible cube values' do
      expect(prepared_games[0].minimum_power).to eq(48)
      expect(prepared_games[1].minimum_power).to eq(12)
      expect(prepared_games[2].minimum_power).to eq(1560)
      expect(prepared_games[3].minimum_power).to eq(630)
      expect(prepared_games[4].minimum_power).to eq(36)
    end
  end

  it 'converts raw games into an array of games with an id and array of cube reveals, including 0 scores for missing colours' do
    expect(described_class.new(raw_games).prepared_games).to eq prepared_games
  end

  it 'gives the correct solution for the example by summing the minimum possible power for all games' do
    expect(described_class.new(raw_games).result).to eq 2286
  end
end
