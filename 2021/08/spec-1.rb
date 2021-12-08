require File.join(__dir__, 'solution-1')

RSpec.describe Solution do
  let(:example_notes) {
    [
      {
        patterns: ['be', 'cfbegad', 'cbdgef', 'fgaecd', 'cgeb', 'fdcge', 'agebfd', 'fecdb', 'fabcd', 'edb'],
        numbers: ['fdgacbe', 'cefdb', 'cefbgd', 'gcbe']
      },
      {
        patterns: ['edbfga', 'begcd', 'cbg', 'gc', 'gcadebf', 'fbgde', 'acbgfd', 'abcde', 'gfcbed', 'gfec'],
        numbers: ['fcgedb', 'cgb', 'dgebacf', 'gc']
      },
      {
        patterns: ['fgaebd', 'cg', 'bdaec', 'gdafb', 'agbcfd', 'gdcbef', 'bgcad', 'gfac', 'gcb', 'cdgabef'],
        numbers: ['cg', 'cg', 'fdcagb', 'cbg']
      },
      {
        patterns: ['fbegcd', 'cbd', 'adcefb', 'dageb', 'afcb', 'bc', 'aefdc', 'ecdab', 'fgdeca', 'fcdbega'],
        numbers: ['efabcd', 'cedba', 'gadfec', 'cb']
      },
      {
        patterns: ['aecbfdg', 'fbg', 'gf', 'bafeg', 'dbefa', 'fcge', 'gcbea', 'fcaegb', 'dgceab', 'fcbdga'],
        numbers: ['gecf', 'egdcabf', 'bgf', 'bfgea']
      },
      {
        patterns: ['fgeab', 'ca', 'afcebg', 'bdacfeg', 'cfaedg', 'gcfdb', 'baec', 'bfadeg', 'bafgc', 'acf'],
        numbers: ['gebdcfa', 'ecba', 'ca', 'fadegcb']
      },
      {
        patterns: ['dbcfg', 'fgd', 'bdegcaf', 'fgec', 'aegbdf', 'ecdfab', 'fbedc', 'dacgb', 'gdcebf', 'gf'],
        numbers: ['cefg', 'dcbef', 'fcge', 'gbcadfe']
      },
      {
        patterns: ['bdfegc', 'cbegaf', 'gecbf', 'dfcage', 'bdacg', 'ed', 'bedf', 'ced', 'adcbefg', 'gebcd'],
        numbers: ['ed', 'bcgafe', 'cdgba', 'cbgef']
      },
      {
        patterns: ['egadfb', 'cdbfeg', 'cegd', 'fecab', 'cgb', 'gbdefca', 'cg', 'fgcdab', 'egfdb', 'bfceg'],
        numbers: ['gbdfcae', 'bgc', 'cg', 'cgb']
      },
      {
        patterns: ['gcafb', 'gcf', 'dcaebfg', 'ecagb', 'gf', 'abcdeg', 'gaef', 'cafbge', 'fdbac', 'fegbdc'],
        numbers: ['fgae', 'cfgab', 'fg', 'bagce']
      },
    ]
  }

  describe Solution::Normalizer do
    let(:extracted_notes) { described_class.do_it(File.join(__dir__,'example.txt')) }

    it 'extracts 1 note per line' do
      expect(extracted_notes.size).to eq example_notes.size
    end

   it 'extracts the patterns for each note as an array of words from before the ` | ` character' do
     expect(extracted_notes.first[:patterns]).to eq ['be', 'cfbegad', 'cbdgef', 'fgaecd', 'cgeb', 'fdcge', 'agebfd', 'fecdb', 'fabcd', 'edb']
   end

   it 'extracts the numbers for each note as an array of words from after the ` | ` character' do
     expect(extracted_notes.first[:numbers]).to eq ['fdgacbe', 'cefdb', 'cefbgd', 'gcbe']
   end

   it 'extracts all the notes as patterns and numbers from the whole file' do
     expect(extracted_notes).to eq example_notes
   end
  end

  it 'gives the correct solution for the example' do
    notes_decoder = described_class.new(example_notes)
    expect(notes_decoder.count( 1)).to eq 8
    expect(notes_decoder.count( 4)).to eq 6
    expect(notes_decoder.count( 7)).to eq 5
    expect(notes_decoder.count( 8)).to eq 7
    expect(notes_decoder.result).to eq 26
  end

  describe Solution::NoteDecoder do
    it 'counts the ones in the output' do
      expect(described_class.new(
        patterns: ['fbegcd', 'cbd', 'adcefb', 'dageb', 'afcb', 'bc', 'aefdc', 'ecdab', 'fgdeca', 'fcdbega'],
        numbers: ['efabcd', 'cedba', 'gadfec', 'cb']
      ).count(1)).to eq 1
      expect(described_class.new(
        patterns: ['fgaebd', 'cg', 'bdaec', 'gdafb', 'agbcfd', 'gdcbef', 'bgcad', 'gfac', 'gcb', 'cdgabef'],
        numbers: ['cg', 'cg', 'fdcagb', 'cbg']
      ).count(1)).to eq 2
      expect(described_class.new(
        patterns: ['be', 'cfbegad', 'cbdgef', 'fgaecd', 'cgeb', 'fdcge', 'agebfd', 'fecdb', 'fabcd', 'edb'],
        numbers: ['fdgacbe', 'cefdb', 'cefbgd', 'gcbe']
      ).count(1)).to eq 0
    end

    it 'counts the fours in the output' do
      expect(described_class.new(
        patterns: ['aecbfdg', 'fbg', 'gf', 'bafeg', 'dbefa', 'fcge', 'gcbea', 'fcaegb', 'dgceab', 'fcbdga'],
        numbers: ['gecf', 'egdcabf', 'bgf', 'bfgea']
      ).count(4)).to eq 1
      expect(described_class.new(
        patterns: ['dbcfg', 'fgd', 'bdegcaf', 'fgec', 'aegbdf', 'ecdfab', 'fbedc', 'dacgb', 'gdcebf', 'gf'],
        numbers: ['cefg', 'dcbef', 'fcge', 'gbcadfe']
      ).count(4)).to eq 2
      expect(described_class.new(
        patterns: ['fbegcd', 'cbd', 'adcefb', 'dageb', 'afcb', 'bc', 'aefdc', 'ecdab', 'fgdeca', 'fcdbega'],
        numbers: ['efabcd', 'cedba', 'gadfec', 'cb']
      ).count(4)).to eq 0
    end

    it 'counts the sevens in the output' do
      expect(described_class.new(
        patterns: ['aecbfdg', 'fbg', 'gf', 'bafeg', 'dbefa', 'fcge', 'gcbea', 'fcaegb', 'dgceab', 'fcbdga'],
        numbers: ['gecf', 'egdcabf', 'bgf', 'bfgea']
      ).count(7)).to eq 1
      expect(described_class.new(
        patterns: ['egadfb', 'cdbfeg', 'cegd', 'fecab', 'cgb', 'gbdefca', 'cg', 'fgcdab', 'egfdb', 'bfceg'],
        numbers: ['gbdfcae', 'bgc', 'cg', 'cgb']
      ).count(7)).to eq 2
      expect(described_class.new(
        patterns: ['fbegcd', 'cbd', 'adcefb', 'dageb', 'afcb', 'bc', 'aefdc', 'ecdab', 'fgdeca', 'fcdbega'],
        numbers: ['efabcd', 'cedba', 'gadfec', 'cb']
      ).count(7)).to eq 0
    end

    it 'counts the eights in the output' do
      expect(described_class.new(
        patterns: ['aecbfdg', 'fbg', 'gf', 'bafeg', 'dbefa', 'fcge', 'gcbea', 'fcaegb', 'dgceab', 'fcbdga'],
        numbers: ['gecf', 'egdcabf', 'bgf', 'bfgea']
      ).count(8)).to eq 1
      expect(described_class.new(
        patterns: ['fgeab', 'ca', 'afcebg', 'bdacfeg', 'cfaedg', 'gcfdb', 'baec', 'bfadeg', 'bafgc', 'acf'],
        numbers: ['gebdcfa', 'ecba', 'ca', 'fadegcb']
      ).count(8)).to eq 2
      expect(described_class.new(
        patterns: ['fbegcd', 'cbd', 'adcefb', 'dageb', 'afcb', 'bc', 'aefdc', 'ecdab', 'fgdeca', 'fcdbega'],
        numbers: ['efabcd', 'cedba', 'gadfec', 'cb']
      ).count(8)).to eq 0
    end
  end
end
