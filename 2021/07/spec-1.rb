require File.join(__dir__, 'solution-1')

RSpec.describe Solution do
  let(:example_crab_submarine_positions) { [16,1,2,0,4,2,7,1,2,14] }

  describe Solution::Normalizer do
    it 'extracts the crab submarine positions from the file as an array of numbers from the first line' do
      expect(described_class.do_it(File.join(__dir__,'example.txt'))).to eq example_crab_submarine_positions
    end
  end

  it 'gives the correct solution for the example' do
    crab_submarine_positioner = described_class.new(example_crab_submarine_positions)
    expect(crab_submarine_positioner.fuel_cost_to_align_at( 1)).to eq 41
    expect(crab_submarine_positioner.fuel_cost_to_align_at( 2)).to eq 37
    expect(crab_submarine_positioner.fuel_cost_to_align_at( 3)).to eq 39
    expect(crab_submarine_positioner.fuel_cost_to_align_at(10)).to eq 71
    expect(crab_submarine_positioner.result).to eq 37
  end
end
