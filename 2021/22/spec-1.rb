require File.join(__dir__, 'solution-1')

RSpec.describe Solution do
  let(:example_reboot_instructions) {
    [
      [:on, -20..26, -36..17, -47..7],
      [:on, -20..33, -21..23, -26..28],
      [:on, -22..28, -29..23, -38..16],
      [:on, -46..7, -6..46, -50..-1],
      [:on, -49..1, -3..46, -24..28],
      [:on, 2..47, -22..22, -23..27],
      [:on, -27..23, -28..26, -21..29],
      [:on, -39..5, -6..47, -3..44],
      [:on, -30..21, -8..43, -13..34],
      [:on, -22..26, -27..20, -29..19],
      [:off, -48..-32, 26..41, -47..-37],
      [:on, -12..35, 6..50, -50..-2],
      [:off, -48..-32, -32..-16, -15..-5],
      [:on, -18..26, -33..15, -7..46],
      [:off, -40..-22, -38..-28, 23..41],
      [:on, -16..35, -41..10, -47..6],
      [:off, -32..-23, 11..30, -14..3],
      [:on, -49..-5, -3..45, -29..18],
      [:off, 18..30, -20..-8, -3..13],
      [:on, -41..9, -7..43, -33..15],
      [:on, -54112..-39298, -85059..-49293, -27449..7877],
      [:on, 967..23432, 45373..81175, 27513..53682],
    ]
  }

  describe Solution::Normalizer do
    it 'extracts the reactor reboot instructions an array of tuples formed by an instruction, then x y z rangers to specify the cuboid, one tuple extracted per line of the file' do
      expect(described_class.do_it(File.join(__dir__,'example-1.txt'))).to eq example_reboot_instructions
    end
  end

  it 'ignores any instructions outside the 50x50x50 range for the initialization process' do
    reactor = described_class.new(example_reboot_instructions)

    expect(reactor.initialization_process).to eq [
      [:on, -20..26, -36..17, -47..7],
      [:on, -20..33, -21..23, -26..28],
      [:on, -22..28, -29..23, -38..16],
      [:on, -46..7, -6..46, -50..-1],
      [:on, -49..1, -3..46, -24..28],
      [:on, 2..47, -22..22, -23..27],
      [:on, -27..23, -28..26, -21..29],
      [:on, -39..5, -6..47, -3..44],
      [:on, -30..21, -8..43, -13..34],
      [:on, -22..26, -27..20, -29..19],
      [:off, -48..-32, 26..41, -47..-37],
      [:on, -12..35, 6..50, -50..-2],
      [:off, -48..-32, -32..-16, -15..-5],
      [:on, -18..26, -33..15, -7..46],
      [:off, -40..-22, -38..-28, 23..41],
      [:on, -16..35, -41..10, -47..6],
      [:off, -32..-23, 11..30, -14..3],
      [:on, -49..-5, -3..45, -29..18],
      [:off, 18..30, -20..-8, -3..13],
      [:on, -41..9, -7..43, -33..15],
    ]
  end

  it 'turns cubes on and off correctly' do
    reactor = described_class.new(example_reboot_instructions)

    reactor.process_instruction!([:on, 10..12, 10..12, 10..12])
    expect(reactor.cubes_on).to match_array [
      [10,10,10],
      [10,10,11],
      [10,10,12],
      [10,11,10],
      [10,11,11],
      [10,11,12],
      [10,12,10],
      [10,12,11],
      [10,12,12],
      [11,10,10],
      [11,10,11],
      [11,10,12],
      [11,11,10],
      [11,11,11],
      [11,11,12],
      [11,12,10],
      [11,12,11],
      [11,12,12],
      [12,10,10],
      [12,10,11],
      [12,10,12],
      [12,11,10],
      [12,11,11],
      [12,11,12],
      [12,12,10],
      [12,12,11],
      [12,12,12],
    ]

    reactor.process_instruction!([:on, 11..13, 11..13, 11..13])
    expect(reactor.cubes_on).to match_array [
      [10,10,10],
      [10,10,11],
      [10,10,12],
      [10,11,10],
      [10,11,11],
      [10,11,12],
      [10,12,10],
      [10,12,11],
      [10,12,12],
      [11,10,10],
      [11,10,11],
      [11,10,12],
      [11,11,10],
      [11,11,11],
      [11,11,12],
      [11,12,10],
      [11,12,11],
      [11,12,12],
      [12,10,10],
      [12,10,11],
      [12,10,12],
      [12,11,10],
      [12,11,11],
      [12,11,12],
      [12,12,10],
      [12,12,11],
      [12,12,12],
      [11,11,13],
      [11,12,13],
      [11,13,11],
      [11,13,12],
      [11,13,13],
      [12,11,13],
      [12,12,13],
      [12,13,11],
      [12,13,12],
      [12,13,13],
      [13,11,11],
      [13,11,12],
      [13,11,13],
      [13,12,11],
      [13,12,12],
      [13,12,13],
      [13,13,11],
      [13,13,12],
      [13,13,13],
    ]

    reactor.process_instruction!([:off, 9..11, 9..11, 9..11])
    expect(reactor.cubes_on).to match_array [
      [10,10,12],
      [10,11,12],
      [10,12,10],
      [10,12,11],
      [10,12,12],
      [11,10,12],
      [11,11,12],
      [11,12,10],
      [11,12,11],
      [11,12,12],
      [12,10,10],
      [12,10,11],
      [12,10,12],
      [12,11,10],
      [12,11,11],
      [12,11,12],
      [12,12,10],
      [12,12,11],
      [12,12,12],
      [11,11,13],
      [11,12,13],
      [11,13,11],
      [11,13,12],
      [11,13,13],
      [12,11,13],
      [12,12,13],
      [12,13,11],
      [12,13,12],
      [12,13,13],
      [13,11,11],
      [13,11,12],
      [13,11,13],
      [13,12,11],
      [13,12,12],
      [13,12,13],
      [13,13,11],
      [13,13,12],
      [13,13,13],
    ]

    reactor.process_instruction!([:on, 10..10, 10..10, 10..10])
    expect(reactor.cubes_on).to match_array [
      [10,10,10],
      [10,10,12],
      [10,11,12],
      [10,12,10],
      [10,12,11],
      [10,12,12],
      [11,10,12],
      [11,11,12],
      [11,12,10],
      [11,12,11],
      [11,12,12],
      [12,10,10],
      [12,10,11],
      [12,10,12],
      [12,11,10],
      [12,11,11],
      [12,11,12],
      [12,12,10],
      [12,12,11],
      [12,12,12],
      [11,11,13],
      [11,12,13],
      [11,13,11],
      [11,13,12],
      [11,13,13],
      [12,11,13],
      [12,12,13],
      [12,13,11],
      [12,13,12],
      [12,13,13],
      [13,11,11],
      [13,11,12],
      [13,11,13],
      [13,12,11],
      [13,12,12],
      [13,12,13],
      [13,13,11],
      [13,13,12],
      [13,13,13],
    ]
  end

  it 'generates the correct solution for the example' do
    reactor = described_class.new(example_reboot_instructions)

    expect(reactor.result).to eq 590784
  end
end
