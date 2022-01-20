# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/units/pawn'

describe Game do
  def display_board
    print "#{('a'..'h').to_a} \n"
    board.data.reverse.each do |row|
      puts row.to_s
    end
    print "#{('a'..'h').to_a} \n"
  end

  describe '#move_translator' do
    subject(:game) { described_class.new }

    before do
      allow(game).to receive(:puts)
      allow(game).to receive(:gets)
    end

    it 'returns the coords for the board' do
      expect(game.move_translator('e4')).to eq([5, 4])
    end
  end

  describe '#select_unit' do
    
  end
end
