# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../lib/units/unit'

describe Unit do
  subject(:unit) { described_class.new }

  describe '#enemy_occupied?' do
    context 'when it\'s white\'s turn' do
      it 'returns true if black pieces are found' do
        unit.board.turn = 0
        black_piece = 'p'
        expect(unit.enemy_occupied?(black_piece)).to eq(true)
      end
    end

    context 'when it\'s black\'s turn' do
      it 'returns true if white pieces are found' do
        unit.board.turn = 1
        white_piece = 'P'
        expect(unit.enemy_occupied?(white_piece)).to eq(true)
      end
    end
  end

  describe '#get_piece' do
    it 'returns the piece at the given coordinates' do
      expect(unit.get_piece([2, 1])).to eq('P')
    end
  end

  describe '#valid_move?' do
    context 'when a piece is moved off the board' do
      it 'returns false' do
        expect(unit.valid_move?([-1, 1])).to eq(false)
      end
    end
  end
end
