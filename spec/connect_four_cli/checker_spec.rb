require 'spec_helper'

describe ConnectFourCli::Checker do
  describe '#color' do
    it 'has a color' do

      checker = red_checker
      expect(checker.color).to eq :red
    end
  end

  describe '#==' do
    it 'equals another checker of the same color' do
      expect(red_checker == red_checker).to be true
    end

    it 'does not equal another checker of the same color' do
      expect(red_checker == yellow_checker).to be false
    end
  end

  def red_checker
    ConnectFourCli::Checker.new(:red)
  end

  def yellow_checker
    ConnectFourCli::Checker.new(:yellow)
  end
end

