require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
  let(:raw_games) { [
    'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green',
    'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue',
    'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red',
    'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red',
    'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green',
  ] }
  let(:prepared_games) { [
    Solution1::Game.new(
      id: 1,
      reveals: [
        {blue: 3, red: 4, green: 0},
        {blue: 6, red: 1, green: 2},
        {blue: 0, red: 0, green: 2}
      ]
    ),
    Solution1::Game.new(
      id: 2,
      reveals: [
        {blue: 1, red: 0, green: 2},
        {blue: 4, red: 1, green: 3},
        {blue: 1, red: 0, green: 1}
      ]
    ),
    Solution1::Game.new(
      id: 3,
      reveals: [
        {blue: 6, red: 20, green: 8},
        {blue: 5, red: 4, green: 13},
        {blue: 0, red: 1, green: 5}
      ]
    ),
    Solution1::Game.new(
      id: 4,
      reveals: [
        {blue: 6, red: 3, green: 1},
        {blue: 0, red: 6, green: 3},
        {blue: 15, red: 14, green: 3}
      ]
    ),
    Solution1::Game.new(
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

  describe Solution1::Normalizer do
    it 'converts a file into an array of strings, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_games
    end

    it 'converts a string into a hash of blue, red, green counts including 0 for missing colours' do
      expect(described_class.get_cubes '12 red, 13 green, 14 blue').to eq question
    end
  end

  describe Solution1::Game do
    it 'is possible given a question, if each colour in the reveals is less than the question amount' do
      game = prepared_games[0]
      expect(game.possible? blue: 14, red: 12, green: 13).to be_truthy
      expect(game.possible? blue: 0, red: 0, green: 0).to be_falsey
      expect(game.possible? blue: 6, red: 4, green: 2).to be_truthy
      expect(game.possible? blue: 5, red: 4, green: 2).to be_falsey
      expect(game.possible? blue: 6, red: 3, green: 2).to be_falsey
      expect(game.possible? blue: 6, red: 4, green: 1).to be_falsey
    end
  end

  it 'converts raw games into an array of games with an id and array of cube reveals, including 0 scores for missing colours' do
    expect(described_class.new(raw_games).prepared_games).to eq prepared_games
  end

  it 'selects the correct games given the question input' do
    expect(described_class.new(raw_games).selected_games(question)).to eq selected_games
  end

  it 'gives the correct solution for the example' do
    expect(described_class.new(raw_games).result(question)).to eq 8
  end
end
