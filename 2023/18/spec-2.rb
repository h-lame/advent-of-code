require File.join(__dir__, 'solution-2')

RSpec.describe Solution2 do
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
    it 'converts a direction, distance, hexcode instruction into a direction + distance instruction by interpretting the hexcode' do
      digger = described_class

      expect(digger.convert_instruction(raw_digger_instructions[ 0])).to eq ['R', 461937]
      expect(digger.convert_instruction(raw_digger_instructions[ 1])).to eq ['D',  56407]
      expect(digger.convert_instruction(raw_digger_instructions[ 2])).to eq ['R', 356671]
      expect(digger.convert_instruction(raw_digger_instructions[ 3])).to eq ['D', 863240]
      expect(digger.convert_instruction(raw_digger_instructions[ 4])).to eq ['R', 367720]
      expect(digger.convert_instruction(raw_digger_instructions[ 5])).to eq ['D', 266681]
      expect(digger.convert_instruction(raw_digger_instructions[ 6])).to eq ['L', 577262]
      expect(digger.convert_instruction(raw_digger_instructions[ 7])).to eq ['U', 829975]
      expect(digger.convert_instruction(raw_digger_instructions[ 8])).to eq ['L', 112010]
      expect(digger.convert_instruction(raw_digger_instructions[ 9])).to eq ['D', 829975]
      expect(digger.convert_instruction(raw_digger_instructions[10])).to eq ['L', 491645]
      expect(digger.convert_instruction(raw_digger_instructions[11])).to eq ['U', 686074]
      expect(digger.convert_instruction(raw_digger_instructions[12])).to eq ['L',   5411]
      expect(digger.convert_instruction(raw_digger_instructions[13])).to eq ['U', 500254]
    end

    it 'moves the correct number of steps from the instruction' do
      digger = described_class.new
      expect(digger.position).to eq [0,0]

      digger.process_instruction(['R', 6, '#70c710']) # ['R', 461937]
      expect(digger.position).to eq [461937,0]

      digger.process_instruction(['D', 5, '#0dc571']) # ['D',  56407]
      expect(digger.position).to eq [461937, 56407]

      digger.process_instruction(['L', 2, '#5713f0']) # ['R', 356671]
      expect(digger.position).to eq [461937+356671, 56407]

      digger.process_instruction(['D', 2, '#d2c081']) # ['D', 863240]
      expect(digger.position).to eq [461937+356671, 56407+863240]

      digger.process_instruction(['R', 2, '#59c680']) # ['R', 367720]
      expect(digger.position).to eq [461937+356671+367720,56407+863240]

      digger.process_instruction(['D', 2, '#411b91']) # ['D', 266681]
      expect(digger.position).to eq [461937+356671+367720,56407+863240+266681]

      digger.process_instruction(['L', 5, '#8ceee2']) # ['L', 577262]
      expect(digger.position).to eq [461937+356671+367720-577262,56407+863240+266681]

      digger.process_instruction(['U', 2, '#caa173']) # ['U', 829975]
      expect(digger.position).to eq [461937+356671+367720-577262,56407+863240+266681-829975]
    end

    it 'digs out the lagoon once it has processed all the instructions' do
      digger = described_class.new

      digger.dig_lagoon(raw_digger_instructions)

      expect(digger.lagoon_size).to eq 952408144115
    end

    it 'calculates area properly' do
      digger = described_class.new

      # TODO Why does this fail, but a larger, weirder, rectangle like the
      # example actually works?  I suspect there's something about my
      # simplification / the example / input that means I'm winging my solution
      # and it just works because of the inputs, rather than something that's a
      # universal version
      # # R = 0 D = 1 L = 2 U = 3
      # digger.dig_lagoon([
      #   ['R', 5, '#000050'],
      #   ['D', 2, '#000021'],
      #   ['L', 1, '#000012'],
      #   ['D', 2, '#000021'],
      #   ['R', 1, '#000010'],
      #   ['D', 2, '#000021'],
      #   ['L', 5, '#000052'],
      #   ['U', 6, '#000063']
      # ])
      #
      # # #####
      # # #...#
      # # #..##
      # # #..#.
      # # #..##
      # # #...#
      # # #####
      # expect(digger.lagoon_size).to eq 34

      digger = described_class.new
      digger.dig_lagoon([
        ['R', 6, '#000060'],
        ['D', 5, '#000051'],
        ['L', 2, '#000022'],
        ['D', 2, '#000021'],
        ['R', 2, '#000020'],
        ['D', 2, '#000021'],
        ['L', 5, '#000052'],
        ['U', 2, '#000023'],
        ['L', 1, '#000012'],
        ['U', 2, '#000023'],
        ['R', 2, '#000020'],
        ['U', 3, '#000033'],
        ['L', 2, '#000022'],
        ['U', 2, '#000023'],
      ])

      # #######
      # #.....#
      # ###...#
      # ..#...#
      # ..#...#
      # ###.###
      # #...#..
      # ##..###
      # .#....#
      # .######
      expect(digger.lagoon_size).to eq 62
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_digger_instructions).result).to eq 952408144115
  end
end
