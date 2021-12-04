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

  def last_board_final_call
    last_board.final_call
  end

  def last_board_id
    last_board.id
  end

  def last_board_uncalled_sum
    last_board.uncalled_sum
  end

  def result
    last_board_final_call * last_board_uncalled_sum
  end

  private

  attr_reader :boards, :calls, :last_board

  def play_bingo!
    calls.each.with_index do |call, turn|
      break if boards.all? &:complete?

      boards.reject(&:complete?).each do |board|
        board.call call, turn
      end
    end
    @last_board = boards.sort.last
  end

  class Board
    attr_reader :id, :winner_rank, :final_call

    def initialize(id, data)
      @id = id
      @rows = data.map { |row| row.map { |cell| Cell.new(cell, false) } }
      @columns = @rows.transpose
    end

    def call(number, turn)
      @rows.each do |row|
        called = row.detect { |cell| cell.number == number }
        if called
          called.used = true
          break
        end
      end
      if complete?
        self.winner_rank = turn
        self.final_call = number
      end
    end

    def complete?
      @_complete ||=
        (
         @rows.detect { |row| row.all? { |cell| cell.used? } } ||
         @columns.detect { |column| column.all? { |cell| cell.used? } }
        )
    end

    def uncalled_sum
      @rows.sum { |row| row.sum }
    end

    def <=>(other)
      return nil unless other.is_a? self.class

      winner_rank.<=>(other.winner_rank)
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

    private

    attr_writer :winner_rank, :final_call
  end
end

if __FILE__ == $0
  puts Solution.new(Solution::Normalizer.do_it(ARGV[0])).result
end
