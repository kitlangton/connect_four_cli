module ConnectFourCli
  class Board
    attr_reader :size, :grid, :turn, :winner

    def initialize(size)
      @size = size
      @turn = :red
      build_grid
    end

    def build_grid
      @grid = Array.new(size) { Array.new(size) { NoChecker.new } }
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
      place_checker(checker, at: position)
      next_turn
    end

    def place_checker(checker, at:)
      row = free_position(at)
      grid[row][at] = checker
    end

    def column_full?(number)
      column_count(number) == 6
    end

    def column_count(number)
      column(number).count(&:checker?)
    end

    def free_position(number)
      size - column_count(number) - 1
    end

    def red_locations
      output = []
      grid.transpose.each_with_index do |row, y|
        row.each_with_index do |checker, x|
          if checker.color == :red
            output << [x,y]
          end
        end
      end
      output
    end

    def yellow_locations
      output = []
      grid.transpose.each_with_index do |row, y|
        row.each_with_index do |checker, x|
          if checker.color == :yellow
            output << [x,y]
          end
        end
      end
      output
    end


    def column(number)
      grid.transpose[number]
    end

    def display
      output = []
      grid.transpose.each do |column|
        line = []
        column.each do |checker|
          line <<  checker.display
        end
        output << line
      end
      output.transpose.map{ |row| row.join(" ")}.join("\n") +
        "\n " + game_state
    end

    def red_four_in_a_row?
      return true if each_row(:red)
      return true if each_col(:red)
      return true if each_diag(:red)
    end

    def yellow_four_in_a_row?
      return true if each_row(:yellow)
      return true if each_col(:yellow)
      return true if each_diag(:yellow)
    end

    def each_col(color)
      grid.transpose.each do |row|
        row.each_cons(4) do |checkers|
          return true if checkers.all? { |c| c.color == color}
        end
      end
      false
    end

    def each_diag(color)
      diagonals.each do |diagonal|
        return true if diagonal.all? do |x, y|
          grid[x][y].color == color
        end
        return true if diagonal.all? do |x, y|
          grid[y][5-x].color == color
        end
      end
      false
    end

    def diagonals
      output = []
      output << [[0,0],[1,1],[2,2],[3,3]]
      output << [[1,1],[2,2],[3,3],[4,4]]
      output << [[2,2],[3,3],[4,4],[5,5]]

      output << [[0,1],[1,2],[2,3],[3,4]]
      output << [[0,2],[1,3],[2,4],[3,5]]

      output << [[1,0],[2,1],[3,2],[4,3]]
      output << [[2,0],[3,1],[4,2],[5,3]]

      output << [[1,2],[2,3],[3,4],[4,5]]
      output << [[2,1],[3,2],[4,3],[5,4]]
      output
    end

    def each_row(color)
      grid.each do |row|
        row.each_cons(4) do |checkers|
          return true if checkers.all? { |c| c.color == color}
        end
      end
      false
    end

    def game_state
      "\n"
      if yellow_four_in_a_row?
        @winner = :yellow
        @turn = :yellow
        "Yellow wins! Press q to quit."
      elsif red_four_in_a_row?
        @winner = :red
        @turn = :red
        "Red wins! Press q to quit."
      else
      "#{@turn.capitalize}'s turn."
      end
    end
  end
end
