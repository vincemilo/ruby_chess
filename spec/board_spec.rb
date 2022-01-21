# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#enemy_occupied?' do
    context 'when it\'s white\'s turn' do
      it 'returns true if black pieces are found' do
        black_piece = 'p'
        expect(board.enemy_occupied?(black_piece)).to eq(true)
      end
    end

    context 'when it\'s black\'s turn' do
      before do
        board.update_turn
      end

      it 'returns true if white pieces are found' do
        white_piece = 'P'
        expect(board.enemy_occupied?(white_piece)).to eq(true)
      end
    end
  end

  describe '#off_the_board?' do
    context 'when a piece is moved off the board' do
      it 'returns true' do
        expect(board.off_the_board?([-1, 1])).to be true
        expect(board.off_the_board?([1, -1])).to be true
        expect(board.off_the_board?([1, 8])).to be true
        expect(board.off_the_board?([8, 1])).to be true
      end
    end
  end
end
