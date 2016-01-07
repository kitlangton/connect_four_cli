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

    def terrible_moves
      moves = []
      possible_moves.each do |possible_move|
        all_directions_from(1,possible_move.reverse).each do |ray|
          if ray.all? { |checker| checker.checker? && checker.color == :yellow }
            moves << possible_move
          end
        end
      end
      moves
    end

    def decent_moves
      moves = []
      possible_moves.each do |possible_move|
        all_directions_from(2,possible_move.reverse).each do |ray|
          if ray.all? { |checker| checker.checker? && checker.color == :yellow }
            moves << possible_move
          end
        end
      end
      moves
    end

    def winning_moves
      moves = []
      possible_moves.each do |possible_move|
        all_directions_from(3,possible_move.reverse).each do |ray|
          color = ray[0].color
          if ray.all? { |checker| checker.checker? && checker.color == color }
            moves << possible_move
          end
        end

        other_moves = all_directions_from(2,possible_move.reverse).map.with_index do |ray2, i|
          ray2 << all_directions_from(1,possible_move.reverse)[i][0]
        end
        other_moves.each do |ray|
          color = ray[0].color
          if ray.all? { |checker| checker.checker? && checker.color == color }
            moves << possible_move
          end
        end
      end
      moves
    end

    def all_directions_from(distance, coord)
      directions = []
      [:+,:-].repeated_permutation(2) do |first, second|
        direction = []
        x, y = coord
        distance.times do
          x = x.send(first, 1)
          y = y.send(second, 1)
          next if x > 5 || x < 0 || y > 6 || y < 0
          direction << [x,y]
        end
        directions << direction

        x, y = coord
        directionx = []
        directiony = []
        distance.times do
          x = x.send(first, 1)
          y = y.send(second, 1)
          directionx << [x,coord[1]] unless x > 5 || x < 0
          directiony << [coord[0], y] unless y > 5 || y < 0
        end
        directions << directiony
        directions << directionx
      end
      directions = directions.reject { |direction| direction.length < distance}.uniq

      directions.map do |direction|
        direction.map do |x,y|
          grid[x][y]
        end
      end
    end

    def possible_moves
      (0...size).map do |row|
        position = free_position(row)
        [row, position] unless column_full?(row)
      end.compact
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

    def full?
      @grid.flatten.all?(&:checker?)
    end

    def place_checker(checker, at:)
      return false if column_full?(at)
      row = free_position(at)
      grid[row][at] = checker
      true
    end

  end
end
