module ConnectFourCli
  class Game
    attr_reader :board, :turn, :winner

    def initialize(size)
      @turn = :red
      @board = Board.new(size)
    end

    def next_turn
      if @winner
          @turn = @winner
      else
        @turn = (@turn == :red ? :yellow : :red)
      end
    end

    def place_turn_checker(position)
      return if column_full?(position)
      checker = Checker.new(@turn)
      board.place_checker(checker, at: position)
      next_turn
    end

    def red_locations
      board.red_locations
    end

    def yellow_locations
      board.yellow_locations
    end

    def display
      output = []
      output << board.display
      output << game_state
      output.join("\n\n")
    end

    def game_state
      if board.four_in_a_row?(:yellow)
        @winner = :yellow
        @turn = :yellow
        "Yellow wins! Press q to quit."
      elsif board.four_in_a_row?(:red)
        @winner = :red
        @turn = :red
        "Red wins! Press q to quit."
      else
      "#{@turn.capitalize}'s turn."
      end
    end
  end
end
