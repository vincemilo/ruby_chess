# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#enemy_occupied?' do
    context 'when it\'s white\'s turn' do
      it 'returns true if black pieces are found' do
        game.turn = 0
        black_piece = 'p'
        expect(game.enemy_occupied?(black_piece)).to eq(true)
      end
    end

    context 'when it\'s black\'s turn' do
      it 'returns true if white pieces are found' do
        game.turn = 1
        white_piece = 'P'
        expect(game.enemy_occupied?(white_piece)).to eq(true)
      end
    end
  end

  describe '#get_piece' do
    it 'returns the piece at the given coordinates' do
      expect(game.get_piece([2, 1])).to eq('P')
    end
  end
end
