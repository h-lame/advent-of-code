require File.join(__dir__, 'solution-2')

RSpec.describe Solution do
  let(:example_lantern_fish) { [3,4,3,1,2] }

  describe Solution::Normalizer do
    it 'extracts the fish from the file as an array of numbers from the first line' do
      expect(described_class.do_it(File.join(__dir__,'example.txt'))).to eq example_lantern_fish
    end
  end

  it 'gives the correct solution for the example' do
    fish_modeller = described_class.new(example_lantern_fish)
    expect(fish_modeller.result_at( 0)).to eq  5
    expect(fish_modeller.result_at( 1)).to eq  5
    expect(fish_modeller.result_at( 2)).to eq  6
    expect(fish_modeller.result_at( 3)).to eq  7
    expect(fish_modeller.result_at( 4)).to eq  9
    expect(fish_modeller.result_at( 5)).to eq 10
    expect(fish_modeller.result_at( 6)).to eq 10
    expect(fish_modeller.result_at( 7)).to eq 10
    expect(fish_modeller.result_at( 8)).to eq 10
    expect(fish_modeller.result_at( 9)).to eq 11
    expect(fish_modeller.result_at(10)).to eq 12
    expect(fish_modeller.result_at(11)).to eq 15
    expect(fish_modeller.result_at(12)).to eq 17
    expect(fish_modeller.result_at(13)).to eq 19
    expect(fish_modeller.result_at(14)).to eq 20
    expect(fish_modeller.result_at(15)).to eq 20
    expect(fish_modeller.result_at(16)).to eq 21
    expect(fish_modeller.result_at(17)).to eq 22
    expect(fish_modeller.result_at(18)).to eq 26
    expect(fish_modeller.result_at(80)).to eq 5934
  end
end
