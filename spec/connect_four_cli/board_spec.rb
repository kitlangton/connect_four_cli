require 'spec_helper'

describe ConnectFourCli::Board do
  describe '#initialize' do
    it 'initializes with a grid size' do
      board = build_board
      expect(board.size).to eq 6
    end
  end

  describe '#place_checker' do
    it 'drops a checker in the given column' do
      board = build_board
      checker = "hi" # !> assigned but unused variable - checker
      board.place_checker(red_checker, at: 3)
      board.place_checker(yellow_checker, at: 3)
      board.display
      expect(board.column_count(3)).to eq 2
      p board.each_diag :red
    end
  end

  def build_board
    ConnectFourCli::Board.new(6)
  end

  def red_checker
    ConnectFourCli::Checker.new(:red)
  end

  def yellow_checker
    ConnectFourCli::Checker.new(:yellow)
  end
end
