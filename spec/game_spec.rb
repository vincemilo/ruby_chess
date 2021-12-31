# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

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

  describe '#enemy_occupied?' do
    context 'when its\'s white\'s turn' do
      it 'returns true if black pieces are found' do
        game.turn = 1
        black_piece = 'p'
        expect(game.enemy_occupied?(black_piece)).to eq(true)
      end
    end

    context 'when its\'s black\'s turn' do
      it 'returns true if white pieces are found' do
        game.turn = 0
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

  describe '#white_pawn' do
    context 'when a white pawn is in its starting position
             with no units ahead' do
      it 'has 1 move or 2 move ahead options' do
        start_pos = [1, 1]
        end_pos = [1, 3]
        pawn = game.white_pawn(start_pos, end_pos)
        expect(pawn.moves).to eq [[0, 1], [0, 2]]
      end
    end

    context 'when a unit is two spaces in front and no diagonal
             captures available' do
      before do
        x = 1
        y = 3
        game.board[y][x] = 'p'
      end

      it 'should have one move ahead' do
        start_pos = [1, 1]
        end_pos = [1, 3]
        pawn = game.white_pawn(start_pos, end_pos)
        expect(pawn.moves).to eq [[0, 1]]
      end
    end

    context 'when a unit is one space in front and no diagonal
             captures available' do
      before do
        x = 1
        y = 2
        game.board[y][x] = 'p'
      end

      it 'should have no legal moves' do
        start_pos = [1, 1]
        end_pos = [1, 2]
        pawn = game.white_pawn(start_pos, end_pos)
        expect(pawn.moves).to eq []
      end
    end

    context 'when a unit is one space in front but pawn has diagonal
             captures available' do
      before do
        x = 1
        y = 2
        game.board[y][x] = 'p'
        display_board
      end

      xit 'should have diagonal moves' do
        start_pos = [1, 1]
        end_pos = [1, 2]
        pawn = game.white_pawn(start_pos, end_pos)
        expect(pawn.moves).to eq [[1, 1], [-1, 1]]
      end
    end
  end
end
