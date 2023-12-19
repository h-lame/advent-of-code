require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
  let(:raw_digger_instructions) { [
    ['R', 6, '#70c710'],
    ['D', 5, '#0dc571'],
    ['L', 2, '#5713f0'],
    ['D', 2, '#d2c081'],
    ['R', 2, '#59c680'],
    ['D', 2, '#411b91'],
    ['L', 5, '#8ceee2'],
    ['U', 2, '#caa173'],
    ['L', 1, '#1b58a2'],
    ['U', 2, '#caa171'],
    ['R', 2, '#7807d2'],
    ['U', 3, '#a77fa3'],
    ['L', 2, '#015232'],
    ['U', 2, '#7a21e3'],
  ] }

  describe described_class::Normalizer do
    it 'converts a file into an array of arrays - each array has a character, a number, and a hexcode, each sub-array extracted from a line of the file' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_digger_instructions
    end
  end

  describe described_class::Digger do
    it 'moves the correct number of steps from the instruction' do
      digger = described_class.new
      expect(digger.position).to eq [0,0]

      digger.process_instruction(['R', 6, '#70c710'])
      expect(digger.position).to eq [6,0]

      digger.process_instruction(['D', 5, '#0dc571'])
      expect(digger.position).to eq [6,5]

      digger.process_instruction(['L', 2, '#5713f0'])
      expect(digger.position).to eq [4,5]

      digger.process_instruction(['D', 2, '#d2c081'])
      expect(digger.position).to eq [4,7]

      digger.process_instruction(['R', 2, '#59c680'])
      expect(digger.position).to eq [6,7]

      digger.process_instruction(['D', 2, '#411b91'])
      expect(digger.position).to eq [6,9]

      digger.process_instruction(['L', 5, '#8ceee2'])
      expect(digger.position).to eq [1,9]

      digger.process_instruction(['U', 2, '#caa173'])
      expect(digger.position).to eq [1,7]
    end

    it 'tracks the digger path' do
      digger = described_class.new

      raw_digger_instructions.each do |digger_instruction|
        digger.process_instruction digger_instruction
      end

      expect(digger.lagoon_size).to eq 38
      expect(digger.render_lagoon).to eq(
        <<~LAGOON.chomp
          #######
          #.....#
          ###...#
          ..#...#
          ..#...#
          ###.###
          #...#..
          ##..###
          .#....#
          .######
        LAGOON
      )
    end

    it 'can dig out the lagoon' do
      digger = described_class.new

      raw_digger_instructions.each do |digger_instruction|
        digger.process_instruction digger_instruction
      end
      digger.dig_out

      expect(digger.lagoon_size).to eq 62
      expect(digger.render_lagoon).to eq(
        <<~LAGOON.chomp
          #######
          #######
          #######
          ..#####
          ..#####
          #######
          #####..
          #######
          .######
          .######
        LAGOON
      )
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_digger_instructions).result).to eq 62
  end
end
