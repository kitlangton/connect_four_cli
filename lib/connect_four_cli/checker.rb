require 'rainbow'

module ConnectFourCli
class Checker

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def ==(other_checker)
    color == other_checker.color
  end

  def display
    "O"
  end

  def checker?
    true
  end
end

class NoChecker < Checker
  def initialize
    super(:none)
  end

  def display
    "0"
  end

  def checker?
    false
  end
end
end
