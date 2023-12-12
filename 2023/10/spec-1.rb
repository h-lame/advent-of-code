require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
  let(:raw_pipe_1) { [
    '-L|F7',
    '7S-7|',
    'L|7||',
    '-L-J|',
    'L|-JF',
  ] }
  let(:pipe_loop_1) { [
    '.....',
    '.F-7.',
    '.|.|.',
    '.L-J.',
    '.....',
  ]}
  let(:raw_pipe_2) { [
    '7-F7-',
    '.FJ|7',
    'SJLL7',
    '|F--J',
    'LJ.LJ',
  ] }
  let(:pipe_loop_2) { [
    '..F7.',
    '.FJ|.',
    'FJ.L7',
    '|F--J',
    'LJ...',
  ] }

  describe described_class::Normalizer do
    it 'converts a file into an array of strings, one per line' do
      expect(described_class.do_it File.join(__dir__,'example-1.txt')).to eq raw_pipe_1
      expect(described_class.do_it File.join(__dir__,'example-2.txt')).to eq raw_pipe_2
    end
  end

  describe described_class::PipeLoop do
    it 'can print the pipe loop without extra detail' do
      expect(described_class.new(raw_pipe_1).render_pipe_loop).to eq pipe_loop_1
      expect(described_class.new(raw_pipe_2).render_pipe_loop).to eq pipe_loop_2
    end

    it 'can tell you the size of the pipe loop' do
      expect(described_class.new(raw_pipe_1).size).to eq 8
      expect(described_class.new(raw_pipe_2).size).to eq 16
    end

    it 'can tell you what the pipe under S is supposed to be' do
      # | is a vertical pipe connecting north and south.
      # - is a horizontal pipe connecting east and west.
      # L is a 90-degree bend connecting north and east.
      # J is a 90-degree bend connecting north and west.
      # 7 is a 90-degree bend connecting south and west.
      # F is a 90-degree bend connecting south and east.
      # . is ground; there is no pipe in this tile.

      expect { described_class.new ['S'] }.to raise_error Solution1::InvalidPipe

      expect(described_class.new(['LS-']).starting_pipe).to eq '-'
      expect(described_class.new(['LS7']).starting_pipe).to eq '-'
      expect(described_class.new(['LSJ']).starting_pipe).to eq '-'
      expect { described_class.new(['-SL']).starting_pipe }.to raise_error Solution1::InvalidPipe
      expect(described_class.new(['-S7']).starting_pipe).to eq '-'
      expect(described_class.new(['-SJ']).starting_pipe).to eq '-'
      expect { described_class.new(['7SL']).starting_pipe }.to raise_error Solution1::InvalidPipe
      expect { described_class.new(['7S-']).starting_pipe }.to raise_error Solution1::InvalidPipe
      expect { described_class.new(['7SJ']).starting_pipe }.to raise_error Solution1::InvalidPipe
      expect { described_class.new(['JSL']).starting_pipe }.to raise_error Solution1::InvalidPipe
      expect { described_class.new(['JS-']).starting_pipe }.to raise_error Solution1::InvalidPipe
      expect { described_class.new(['JS7']).starting_pipe }.to raise_error Solution1::InvalidPipe
      expect(described_class.new(['-S-']).starting_pipe).to eq '-'
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_pipe_1).result).to eq 4
    expect(described_class.new(raw_pipe_2).result).to eq 8
  end
end
