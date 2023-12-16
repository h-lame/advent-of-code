require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
  let(:raw_mirror_grid) { [
    ".|...\\....",
    "|.-.\\.....",
    ".....|-...",
    "........|.",
    "..........",
    ".........\\",
    "..../.\\\\..",
    ".-.-/..|..",
    ".|....-|.\\",
    "..//.|....",
  ] }

  describe described_class::Normalizer do
    it 'converts a file into an array of strings' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_mirror_grid
    end
  end

  describe described_class::MirrorGrid do
    it 'inteacts correctly with mirrors' do
      grid = described_class.new(['.'])
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :east))).to eq described_class::Beam.new([1,0], :east)
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :north))).to eq described_class::Beam.new([0,-1], :north)
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :west))).to eq described_class::Beam.new([-1,0], :west)
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :south))).to eq described_class::Beam.new([0,1], :south)

      grid = described_class.new(['-'])
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :east))).to eq described_class::Beam.new([1,0], :east)
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :north))).to eq [described_class::Beam.new([1,0], :east),described_class::Beam.new([-1,0], :west)]
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :west))).to eq described_class::Beam.new([-1,0], :west)
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :south))).to eq [described_class::Beam.new([1,0], :east),described_class::Beam.new([-1,0], :west)]

      grid = described_class.new(['|'])
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :east))).to eq [described_class::Beam.new([0,-1], :north),described_class::Beam.new([0,1], :south)]
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :north))).to eq described_class::Beam.new([0,-1], :north)
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :west))).to eq [described_class::Beam.new([0,-1], :north),described_class::Beam.new([0,1], :south)]
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :south))).to eq described_class::Beam.new([0,1], :south)

      grid = described_class.new(['\\'])
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :east))).to eq described_class::Beam.new([0, 1], :south)
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :north))).to eq described_class::Beam.new([-1,0], :west)
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :west))).to eq described_class::Beam.new([0,-1], :north)
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :south))).to eq described_class::Beam.new([1,0], :east)

      grid = described_class.new(['/'])
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :east))).to eq described_class::Beam.new([0,-1], :north)
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :north))).to eq described_class::Beam.new([1,0], :east)
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :west))).to eq described_class::Beam.new([0, 1], :south)
      expect(grid.interact_with_grid(described_class::Beam.new([0,0], :south))).to eq described_class::Beam.new([-1,0], :west)
    end

    it 'energizes the grid correctly' do
      expect(described_class.new(['...']).render_energized).to eq ['###']

      expect(described_class.new([
         '.',
         '.'
      ]).render_energized).to eq([
         '#',
         '.'
      ])

      expect(described_class.new([
         '\\.',
         '..'
      ]).render_energized).to eq([
         '#.',
         '#.'
      ])

      expect(described_class.new([
         '-.',
         '..']
      ).render_energized).to eq([
         '##',
         '..'
      ])

      expect(described_class.new([
         '\\/.',
         '\\/.'
      ]).render_energized).to eq([
         '###',
         '##.'
      ])

      expect(described_class.new([
         '.\\.',
         '.-.'
      ]).render_energized).to eq([
         '##.',
         '###'
      ])

      expect(described_class.new([
         '.\\.',
         '.|.',
         '...'
      ]).render_energized).to eq([
         '##.',
         '.#.',
         '.#.'
      ])

      expect(described_class.new([
         '\\..',
         '\\|.',
         '...'
      ]).render_energized).to eq([
         '##.',
         '##.',
         '.#.'
      ])
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_mirror_grid).result).to eq 46
  end
end
