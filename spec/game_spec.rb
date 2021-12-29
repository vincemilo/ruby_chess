require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }

  describe '#valid_move?' do
    context 'when a piece is moved off the board' do
      it 'returns false' do
        expect(game.valid_move?([1, 0], [-1, 0], 'P')).to eq(false)
      end
    end
  end

  describe '#get_piece' do
    context 'when a white pawn is in its starting position
             with no units ahead' do
      it 'has 1 move or 2 move ahead options' do
        piece = 'P'
        start_pos = [1, 1]
        end_pos = [1, 3]
        pawn = game.get_piece(piece, start_pos, end_pos)
        expect(pawn.moves).to eq [[0, 1], [0, 2]]
      end
    end
  end
end
