Dispel::Screen.open(colors: true) do |screen|
  map = Dispel::StyleMap.new(3) # number of lines
  map.add(:reverse, 0, 1..5)    # :normal / :reverse / color, line, characters
  map.add(["#aa0000", "#00aa00"], 0, 5..8) # foreground red, background green
  content = ConnectFourCli::Board.new(6).display

  screen.draw content, map, [0,3] # text, styles, cursor position

  Dispel::Keyboard.output do |key|
    case key
    when :down
      screen.draw "Shiny"
    when "q" then break

    end
  end

end
