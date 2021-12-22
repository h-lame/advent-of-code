require File.join(__dir__, 'solution-1')

RSpec.describe Solution do
  let(:example_positions) { [4,8] }

  describe Solution::Normalizer do
    it 'extracts the player positions as a pair of integers, one extracted from the first two lines of the file' do
      expect(described_class.do_it(File.join(__dir__,'example.txt'))).to eq example_positions
    end
  end

  it 'generates the correct solution for the example' do
    game = described_class.new(example_positions)

    expect(game.player_one.position).to eq 4
    expect(game.player_one.score).to eq 0
    expect(game.player_two.position).to eq 8
    expect(game.player_two.score).to eq 0
    expect(game).not_to be_over

    game.turn!
    expect(game.player_one.position).to eq 10
    expect(game.player_one.score).to eq 10
    expect(game.player_two.position).to eq 8
    expect(game.player_two.score).to eq 0
    expect(game).not_to be_over

    game.turn!
    expect(game.player_one.position).to eq 10
    expect(game.player_one.score).to eq 10
    expect(game.player_two.position).to eq 3
    expect(game.player_two.score).to eq 3
    expect(game).not_to be_over

    game.turn!; game.turn!
    expect(game.player_one.position).to eq 4
    expect(game.player_one.score).to eq 14
    expect(game.player_two.position).to eq 6
    expect(game.player_two.score).to eq 9
    expect(game).not_to be_over

    game.turn!; game.turn!
    expect(game.player_one.position).to eq 6
    expect(game.player_one.score).to eq 20
    expect(game.player_two.position).to eq 7
    expect(game.player_two.score).to eq 16
    expect(game).not_to be_over

    game.turn!; game.turn!
    expect(game.player_one.position).to eq 6
    expect(game.player_one.score).to eq 26
    expect(game.player_two.position).to eq 6
    expect(game.player_two.score).to eq 22
    expect(game).not_to be_over

    319.times { game.turn! }
    expect(game).not_to be_over

    game.turn!
    expect(game.player_two.position).to eq 6
    expect(game.player_two.score).to eq 742
    expect(game).not_to be_over

    game.turn!
    expect(game.player_one.position).to eq 4
    expect(game.player_one.score).to eq 990
    expect(game.player_two.position).to eq 6
    expect(game.player_two.score).to eq 742
    expect(game).not_to be_over

    game.turn!
    expect(game.player_one.position).to eq 4
    expect(game.player_one.score).to eq 990
    expect(game.player_two.position).to eq 3
    expect(game.player_two.score).to eq 745
    expect(game).not_to be_over

    game.turn!
    expect(game.player_one.position).to eq 10
    expect(game.player_one.score).to eq 1000
    expect(game.player_two.position).to eq 3
    expect(game.player_two.score).to eq 745
    expect(game).to be_over

    expect(game.result).to eq 739785
  end
end
