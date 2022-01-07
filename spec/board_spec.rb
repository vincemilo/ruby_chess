# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#valid_move?' do
    context 'when a piece is moved off the board' do
      it 'returns false' do
        expect(board.valid_move?([1, 1], [-1, 1], 'P')).to eq(false)
      end
    end
  end

  describe '#enemy_occupied?' do
    context 'when it\'s white\'s turn' do
      it 'returns true if black pieces are found' do
        board.turn = 0
        black_piece = 'p'
        expect(board.enemy_occupied?(black_piece)).to eq(true)
      end
    end

    context 'when it\'s black\'s turn' do
      it 'returns true if white pieces are found' do
        board.turn = 1
        white_piece = 'P'
        expect(board.enemy_occupied?(white_piece)).to eq(true)
      end
    end
  end

  describe '#get_piece' do
    it 'returns the piece at the given coordinates' do
      expect(board.get_piece([2, 1])).to eq('P')
    end
  end
end
