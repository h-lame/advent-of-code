require File.join(__dir__, 'solution-2')

RSpec.describe Solution do
  let(:example_crab_submarine_positions) { [16,1,2,0,4,2,7,1,2,14] }

  describe Solution::Normalizer do
    it 'extracts the crab submarine positions from the file as an array of numbers from the first line' do
      expect(described_class.do_it(File.join(__dir__,'example.txt'))).to eq example_crab_submarine_positions
    end
  end

  it 'gives the correct solution for the example' do
    crab_submarine_positioner = described_class.new(example_crab_submarine_positions)
    expect(crab_submarine_positioner.fuel_cost_to_move(from:  1, to:  2)).to eq 1
    expect(crab_submarine_positioner.fuel_cost_to_move(from:  1, to:  3)).to eq 3
    expect(crab_submarine_positioner.fuel_cost_to_move(from:  1, to:  4)).to eq 6
    expect(crab_submarine_positioner.fuel_cost_to_move(from: 16, to:  5)).to eq 66
    expect(crab_submarine_positioner.fuel_cost_to_move(from:  5, to: 16)).to eq 66
    expect(crab_submarine_positioner.fuel_cost_to_align_at(2)).to eq 206
    expect(crab_submarine_positioner.fuel_cost_to_align_at(5)).to eq 168
    expect(crab_submarine_positioner.result).to eq 168
  end
end
