require 'csv'

class Solution
  BingoGame = Struct.new(:calls, :boards)

  class Normalizer
    def self.do_it(file_name)
      bingo_data = File.readlines(file_name).map &:chomp

      BingoGame.new([], []).tap do |game|
        calls = bingo_data.shift
        game.calls = CSV.parse_line calls, converters: [:numeric]
        game.boards = bingo_data.each_slice(6).map do |board_lines|
          board_lines.shift
          board_lines.map { |board_line| board_line.split.map { |number| Integer(number) } }
        end
      end
    end
  end

  def initialize(game_data)
    @calls = game_data.calls
    @boards = game_data.boards.map.with_index { |board, idx| Board.new(idx, board) }
    play_bingo!
  end

  def final_call
    calls.first
  end

  def winning_board_id
    winning_board.id
  end

  def winning_board_uncalled_sum
    winning_board.uncalled_sum
  end

  def result
    final_call * winning_board_uncalled_sum
  end

  private

  attr_reader :boards
  attr_accessor :calls, :winning_board

  def play_bingo!
    self.calls = calls.drop_while do |call|
      self.winning_board =
        boards.detect do |board|
          board.call call
          board.complete?
        end
      self.winning_board.nil?
    end
  end

  class Board
    attr_reader :id

    def initialize(id, data)
      @id = id
      @rows = data.map { |row| row.map { |cell| Cell.new(cell, false) } }
      @columns = @rows.transpose
    end

    def call(number)
      @rows.each do |row|
        called = row.detect { |cell| cell.number == number }
        if called
          called.used = true
          break
        end
      end
    end

    def complete?
      @rows.detect { |row| row.all? { |cell| cell.used? } } ||
        @columns.detect { |column| column.all? { |cell| cell.used? }}
    end

    def uncalled_sum
      @rows.sum { |row| row.sum }
    end

    Cell = Struct.new(:number, :used) do
      def coerce(other)
        if other.is_a? Numeric
          [used? ? 0 : number, other]
        else
          super
        end
      end

      def used?; used; end
    end
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
