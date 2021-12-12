require File.join(__dir__, 'solution-1')

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

  it 'finds all the paths that visit a small cave only once' do
    mapper = described_class.new(example_map_small)
    expect(mapper.paths).to match_array [
      'start,A,b,A,c,A,end',
      'start,A,b,A,end',
      'start,A,b,end',
      'start,A,c,A,b,A,end',
      'start,A,c,A,b,end',
      'start,A,c,A,end',
      'start,A,end',
      'start,b,A,c,A,end',
      'start,b,A,end',
      'start,b,end',
    ]

    mapper = described_class.new(example_map_medium)
    expect(mapper.paths).to match_array [
      'start,HN,dc,HN,end',
      'start,HN,dc,HN,kj,HN,end',
      'start,HN,dc,end',
      'start,HN,dc,kj,HN,end',
      'start,HN,end',
      'start,HN,kj,HN,dc,HN,end',
      'start,HN,kj,HN,dc,end',
      'start,HN,kj,HN,end',
      'start,HN,kj,dc,HN,end',
      'start,HN,kj,dc,end',
      'start,dc,HN,end',
      'start,dc,HN,kj,HN,end',
      'start,dc,end',
      'start,dc,kj,HN,end',
      'start,kj,HN,dc,HN,end',
      'start,kj,HN,dc,end',
      'start,kj,HN,end',
      'start,kj,dc,HN,end',
      'start,kj,dc,end',
    ]
  end

  it 'gives the correct solution for the example' do
    mapper = described_class.new(example_map_large)

    expect(mapper.paths.size).to eq 226
  end
end
