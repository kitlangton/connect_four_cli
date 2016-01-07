module ConnectFourCli
  class Computer
    attr_reader :board, :checker

    def initialize(board)
      @board = board
      @checker = Checker.new(:yellow)
    end

    def random_move
      (0...board.size).map do |i|
        board.column_full?(i) ? nil : i
      end.compact.sample
    end

    def make_move
      if board.winning_moves.length > 0
        move = board.winning_moves[0][0]
      else
        move = random_move
      end
      board.place_checker(checker, at: move)
    end
  end
end
