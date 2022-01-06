# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }

  describe '#valid_move?' do
    context 'when a piece is moved off the board' do
      it 'returns false' do
        expect(game.valid_move?([1, 1], [-1, 1], 'P')).to eq(false)
      end
    end
  end
end
