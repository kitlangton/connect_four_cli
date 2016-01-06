require "connect_four_cli/version"
require "connect_four_cli/checker"
require "connect_four_cli/game"
require "connect_four_cli/board"
require "connect_four_cli/renderer"

module ConnectFourCli
  def self.start
    Renderer.start
  end
end
