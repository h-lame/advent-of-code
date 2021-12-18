require File.join(__dir__, 'solution-1')

RSpec.describe Solution do
  let(:example_target_area) {
    {x: 20..30, y: -10..-5}
  }

  describe Solution::Normalizer do
    it 'extracts the bits as a hash with x and y keys, whose values integer ranges' do
      expect(described_class.do_it(File.join(__dir__,'example.txt'))).to eq example_target_area
    end
  end

  it 'knows if a firing plan will hit the target' do
    probe_launcher = described_class.new(example_target_area)

    probe_journey = probe_launcher.fire(7,2)
    expect(probe_journey).to hit_target(on_step: 7)

    probe_journey = probe_launcher.fire(6,3)
    expect(probe_journey).to hit_target(on_step: 9)

    probe_journey = probe_launcher.fire(9,0)
    expect(probe_journey).to hit_target(on_step: 4)

    probe_journey = probe_launcher.fire(17,-4)
    expect(probe_journey).to miss_target(on_step: 2)
  end

  it 'generates the correct solution for the example' do
    probe_launcher = described_class.new(example_target_area)

    expect(probe_launcher.firing_plan.plan).to eq [6,9]
    expect(probe_launcher.result).to eq 45
  end

  RSpec::Matchers.define :hit_target do |on_step:|
    match do |firing_plan|
      firing_plan.hit_target? && firing_plan.hit_target_on == on_step
    end
  end

  RSpec::Matchers.define :miss_target do |on_step:|
    match do |firing_plan|
      firing_plan.missed_target? && firing_plan.missed_target_on == on_step
    end
  end
end
