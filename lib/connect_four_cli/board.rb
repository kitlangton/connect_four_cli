module ConnectFourCli
  class Board
    attr_reader :size, :grid

    def initialize(size)
      @size = size
      build_grid
    end

    def build_grid
      @grid = Array.new(size) { Array.new(size) { NoChecker.new } }
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
      locations_for(:red)
    end

    def yellow_locations
      locations_for(:yellow)
    end

    def locations_for(color)
      output = []
      grid.transpose.each_with_index do |row, y|
        row.each_with_index do |checker, x|
          if checker.color == color
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
      output.transpose.map{ |row| row.join(" ")}.join("\n")
    end

    def four_in_a_row?(color)
      if each_row(color) || each_col(color) || each_diag(color)
        return true
      end
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
      all_diagonals.each do |diagonal|
        diagonal.each_cons(4) do |winning_diag|
          return true if winning_diag.all? do |x, y|
            grid[x][y].color == color
          end
          return true if winning_diag.all? do |x, y|
            grid[y][5-x].color == color
          end
        end
      end
      false
    end

    def all_diagonals
      diagonals = []
      (grid.length).times do |i|
        x = i
        y = 0
        set = []
        until x == grid.length || y == grid.length
          set << [x, y]
          x += 1
          y += 1
        end
        diagonals << set
      end

      diagonals.map { |diag| [diag, diag.map(&:reverse) ] }.flatten(1).uniq.select { |diag| diag.length >= 4}
    end

    def each_row(color)
      grid.each do |row|
        row.each_cons(4) do |checkers|
          return true if checkers.all? { |c| c.color == color}
        end
      end
      false
    end

    def place_checker(checker, at:)
      return false if column_full?(at)
      row = free_position(at)
      grid[row][at] = checker
      true
    end

  end
end
