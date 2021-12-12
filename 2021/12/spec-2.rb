require File.join(__dir__, 'solution-2')

RSpec.describe Solution do
  let(:example_map_small) {
    [
      ['start', 'A'],
      ['start', 'b'],
      ['A', 'c'],
      ['A', 'b'],
      ['b', 'd'],
      ['A', 'end'],
      ['b', 'end'],
    ]
  }

  let(:example_map_medium) {
    [
      ['dc', 'end'],
      ['HN', 'start'],
      ['start', 'kj'],
      ['dc', 'start'],
      ['dc', 'HN'],
      ['LN', 'dc'],
      ['HN', 'end'],
      ['kj', 'sa'],
      ['kj', 'HN'],
      ['kj', 'dc'],
    ]
  }

  let(:example_map_large) {
    [
      ['fs', 'end'],
      ['he', 'DX'],
      ['fs', 'he'],
      ['start', 'DX'],
      ['pj', 'DX'],
      ['end', 'zg'],
      ['zg', 'sl'],
      ['zg', 'pj'],
      ['pj', 'he'],
      ['RW', 'he'],
      ['fs', 'DX'],
      ['pj', 'RW'],
      ['zg', 'RW'],
      ['start', 'pj'],
      ['he', 'WI'],
      ['zg', 'he'],
      ['pj', 'fs'],
      ['start', 'RW'],
    ]
  }


  describe Solution::Normalizer do
    it 'extracts the map as an array of pairs of strings, one per line of the file' do
      expect(described_class.do_it(File.join(__dir__,'example-1.txt'))).to eq example_map_small
      expect(described_class.do_it(File.join(__dir__,'example-2.txt'))).to eq example_map_medium
      expect(described_class.do_it(File.join(__dir__,'example-3.txt'))).to eq example_map_large
    end
  end

  it 'finds all the paths that visit one small cave twice, and the rest only once' do
    mapper = described_class.new(example_map_small)
    expect(mapper.paths).to match_array [
      'start,A,b,A,b,A,c,A,end',
      'start,A,b,A,b,A,end',
      'start,A,b,A,b,end',
      'start,A,b,A,c,A,b,A,end',
      'start,A,b,A,c,A,b,end',
      'start,A,b,A,c,A,c,A,end',
      'start,A,b,A,c,A,end',
      'start,A,b,A,end',
      'start,A,b,d,b,A,c,A,end',
      'start,A,b,d,b,A,end',
      'start,A,b,d,b,end',
      'start,A,b,end',
      'start,A,c,A,b,A,b,A,end',
      'start,A,c,A,b,A,b,end',
      'start,A,c,A,b,A,c,A,end',
      'start,A,c,A,b,A,end',
      'start,A,c,A,b,d,b,A,end',
      'start,A,c,A,b,d,b,end',
      'start,A,c,A,b,end',
      'start,A,c,A,c,A,b,A,end',
      'start,A,c,A,c,A,b,end',
      'start,A,c,A,c,A,end',
      'start,A,c,A,end',
      'start,A,end',
      'start,b,A,b,A,c,A,end',
      'start,b,A,b,A,end',
      'start,b,A,b,end',
      'start,b,A,c,A,b,A,end',
      'start,b,A,c,A,b,end',
      'start,b,A,c,A,c,A,end',
      'start,b,A,c,A,end',
      'start,b,A,end',
      'start,b,d,b,A,c,A,end',
      'start,b,d,b,A,end',
      'start,b,d,b,end',
      'start,b,end',
    ]
  end

  it 'gives the correct solution for the example' do
    mapper = described_class.new(example_map_medium)
    expect(mapper.paths.size).to eq 103

    mapper = described_class.new(example_map_large)
    expect(mapper.paths.size).to eq 3509
  end
end
