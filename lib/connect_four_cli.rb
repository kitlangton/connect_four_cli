require "connect_four_cli/version"
require "connect_four_cli/checker"
require "connect_four_cli/game"
require "connect_four_cli/board"
require "connect_four_cli/computer"
require "connect_four_cli/renderer"

module ConnectFourCli
  def self.start
    if ARGV[0] == "-c"
      game = Game.new(6, true)
    else
      game = Game.new(6)
    end
    Renderer.start(game)
  end
end
