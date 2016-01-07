require 'dispel'

module ConnectFourCli
  class Renderer
    def self.turn_color(turn)
      if turn == :red
        ["#ff0000", "#000000"].reverse
      else
        ["#ffff00", "#000000"].reverse
      end
    end

    def self.highlight_column(game, column)
      map = Dispel::StyleMap.new(6) # number of lines
      (0..5).each do |row|
        map.add(turn_color(game.turn), row, column..column)
      end
      game.red_locations.each do |location|
        map.add(["#ff0000", "#000000"], location[0], location[1]*2..location[1]*2 + 1)
      end
      game.yellow_locations.each do |location|
        map.add(["#ffff00", "#000000"], location[0], location[1]*2..location[1]*2 + 1)
      end
      map.add(turn_color(game.turn), 0, column..column)
      map
    end

    def self.start(game)
      ::Dispel::Screen.open(colors: true) do |screen|
        Curses.curs_set 0

        content = game.display

        x = 0
        y = 0

        map = self.highlight_column(game, x)
        screen.draw content, map, [y,x]

        Dispel::Keyboard.output do |key|
          if game.winner
            Dispel::Keyboard.output do |key|
              case key
              when "q" then break
              end
            end
            break
          end

          case key
          when :right
            next if x + 2 >= 12
            x += 2
          when :left
            next if x - 2 < 0
            x-= 2
          when " "
            game.place_turn_checker(x / 2)
          when "q" then break

          end
          map = self.highlight_column(game, x)
          content = game.display
          screen.draw content, map, [y,x]
        end
      end
    end
  end
end
