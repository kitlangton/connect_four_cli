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
      board.place_checker(red_checker, at: 0)
      board.place_checker(red_checker, at: 2)
      board.place_checker(red_checker, at: 3)
      board.display
      puts board.display
      p board.winning_moves
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
