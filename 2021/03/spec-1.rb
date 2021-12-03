require File.join(__dir__, 'solution-1')

RSpec.describe Solution do
  let(:example_reports) { ['00100', '11110', '10110', '10111', '10101', '01111', '00111', '11100', '10000', '11001','00010','01010'] }

  describe Solution::Normalizer do
    it 'converts a file into an array of strings, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq example_reports
    end
  end

  it 'gives the correct solution for the example' do
    power_consumption = described_class.new(example_reports)
    expect(power_consumption.gamma_rate_binary).to eq '10110'
    expect(power_consumption.gamma_rate).to eq 22
    expect(power_consumption.epsilon_rate_binary).to eq '01001'
    expect(power_consumption.epsilon_rate).to eq 9
    expect(power_consumption.result).to eq 198
  end
end
