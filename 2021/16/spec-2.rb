require File.join(__dir__, 'solution-2')

RSpec.describe Solution do
  let(:example_bits) {
    [
      '8A004A801A8002F478', # represents an operator packet (version 4) which contains an operator packet (version 1) which contains an operator packet (version 5) which contains a literal value (version 6); this packet has a version sum of 16.
      '620080001611562C8802118E34', # represents an operator packet (version 3) which contains two sub-packets; each sub-packet is an operator packet that contains two literal values. This packet has a version sum of 12.
      'C0015000016115A2E0802F182340', # has the same structure as the previous example, but the outermost packet uses a different length type ID. This packet has a version sum of 23.
      'A0016C880162017C3686B18A3D4780' # is an operator packet that contains an operator packet that contains an operator packet that contains five literal values; it has a version sum of 31.
    ]
  }

  describe Solution::Normalizer do
    it 'extracts the bits as a single number' do
      expect(described_class.do_it(File.join(__dir__,'example-1.txt'))).to eq example_bits[0]
      expect(described_class.do_it(File.join(__dir__,'example-2.txt'))).to eq example_bits[1]
      expect(described_class.do_it(File.join(__dir__,'example-3.txt'))).to eq example_bits[2]
      expect(described_class.do_it(File.join(__dir__,'example-4.txt'))).to eq example_bits[3]
    end
  end

  it 'parses a value bits example properly' do
    packet = described_class.new('D2FE28').packet

    expect(packet.version).to eq 6
    expect(packet.type).to eq :value
    expect(packet.type_id).to eq 4
    expect(packet.value).to eq 2021
  end

  it 'parses an operator bits example properly' do
    packet = described_class.new('38006F45291200').packet

    expect(packet.version).to eq 1
    expect(packet.type).to eq :operator
    expect(packet.type_id).to eq 6
    expect(packet.value).to eq 1
    expect(packet.subpackets.size).to eq 2

    expect(packet.subpackets[0].version).to eq 6
    expect(packet.subpackets[0].type).to eq :value
    expect(packet.subpackets[0].type_id).to eq 4
    expect(packet.subpackets[0].value).to eq 10

    expect(packet.subpackets[1].version).to eq 2
    expect(packet.subpackets[1].type).to eq :value
    expect(packet.subpackets[1].type_id).to eq 4
    expect(packet.subpackets[1].value).to eq 20
  end

  it 'parses the a complex bits examples properly' do
    packet = described_class.new(example_bits[0]).packet

    expect(packet.version).to eq 4
    expect(packet.type).to eq :operator
    expect(packet.type_id).to eq 2
    expect(packet.subpackets.size).to eq 1
    expect(packet.value).to eq 15

    expect(packet.subpackets[0].version).to eq 1
    expect(packet.subpackets[0].type).to eq :operator
    expect(packet.subpackets[0].type_id).to eq 2
    expect(packet.subpackets[0].subpackets.size).to eq 1
    expect(packet.subpackets[0].value).to eq 15

    expect(packet.subpackets[0].subpackets[0].version).to eq 5
    expect(packet.subpackets[0].subpackets[0].type).to eq :operator
    expect(packet.subpackets[0].subpackets[0].type_id).to eq 2
    expect(packet.subpackets[0].subpackets[0].subpackets.size).to eq 1
    expect(packet.subpackets[0].subpackets[0].value).to eq 15

    expect(packet.subpackets[0].subpackets[0].subpackets[0].version).to eq 6
    expect(packet.subpackets[0].subpackets[0].subpackets[0].type).to eq :value
    expect(packet.subpackets[0].subpackets[0].subpackets[0].type_id).to eq 4
    expect(packet.subpackets[0].subpackets[0].subpackets[0].subpackets.size).to eq 0
    expect(packet.subpackets[0].subpackets[0].subpackets[0].value).to eq 15
  end

  it 'generates the correct solution for the example' do
    expect(described_class.new('C200B40A82').packet.value).to eq 3
    expect(described_class.new('04005AC33890').packet.value).to eq 54
    expect(described_class.new('880086C3E88112').packet.value).to eq 7
    expect(described_class.new('CE00C43D881120').packet.value).to eq 9
    expect(described_class.new('D8005AC2A8F0').packet.value).to eq 1
    expect(described_class.new('F600BC2D8F').packet.value).to eq 0
    expect(described_class.new('9C005AC2F8F0').packet.value).to eq 0
    expect(described_class.new('9C0141080250320F1802104A08').packet.value).to eq 1
  end
end
