require File.join(__dir__, 'solution-1')

RSpec.describe Solution do
  let(:example_calls) { [7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1] }
  let(:example_boards) {
    [
      [
        [22, 13, 17, 11,  0],
        [ 8,  2, 23,  4, 24],
        [21,  9, 14, 16,  7],
        [ 6, 10,  3, 18,  5],
        [ 1, 12, 20, 15, 19]
      ],
      [
        [ 3, 15,  0,  2, 22],
        [ 9, 18, 13, 17,  5],
        [19,  8,  7, 25, 23],
        [20, 11, 10, 24,  4],
        [14, 21, 16, 12,  6]
      ],
      [
        [14, 21, 17, 24,  4],
        [10, 16, 15,  9, 19],
        [18,  8, 23, 26, 20],
        [22, 11, 13,  6,  5],
        [ 2,  0, 12,  3,  7]
      ]
    ]
  }

  describe Solution::Normalizer do
    it 'extracts the called numbers from the first line of a file, as an array of numbers' do
      expect(described_class.do_it(File.join(__dir__,'example.txt')).calls).to eq example_calls
    end

    it 'extracts the boards from the remaining lines of a file, as an array of 5x5 arrays of numbers' do
      expect(described_class.do_it(File.join(__dir__,'example.txt')).boards).to eq example_boards
    end
  end

  it 'gives the correct solution for the example' do
    bingo = described_class.new(Solution::BingoGame.new(example_calls, example_boards))
    expect(bingo.final_call).to eq 24
    expect(bingo.winning_board_id).to eq 2
    expect(bingo.winning_board_uncalled_sum).to eq 188
    expect(bingo.result).to eq 4512
  end
end
