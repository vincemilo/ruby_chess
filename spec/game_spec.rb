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

  describe '#r_diag' do
    before do
      x = 3
      y = 2
      game.board[y][x] = 'p' # coords must be entered reverse due to array
    end

    it 'returns the square 1 up and 1 right of the selected piece' do
      start_pos = [2, 1]
      expect(game.r_diag(start_pos)).to eq('p')
    end
  end

  describe '#l_diag' do
    before do
      x = 1
      y = 2
      game.board[y][x] = 'p' # coords must be entered reverse due to array
    end

    it 'returns the square 1 up and 1 left of the selected piece' do
      start_pos = [2, 1]
      expect(game.l_diag(start_pos)).to eq('p')
    end
  end

  describe '#white_pawn' do
    context 'when a white pawn is in its starting position
             with no units ahead and no diagonal captures' do
      it 'has 1 move or 2 move ahead options' do
        start_pos = [1, 1]
        end_pos = [1, 3]
        pawn = game.white_pawn(start_pos, end_pos)
        expect(pawn.moves).to eq [[0, 1], [0, 2]]
      end
    end

    context 'when a white pawn is in its starting position
             with no units ahead and has two diagonal captures' do
      before do
        x = 3
        y = 2
        game.board[y][x] = 'p'
        game.board[y][x - 2] = 'p'
      end

      it 'has all move options' do
        start_pos = [2, 1]
        end_pos = [3, 2]
        pawn = game.white_pawn(start_pos, end_pos)
        expect(pawn.moves).to eq [[0, 1], [0, 2], [1, 1], [-1, 1]]
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
        game.board[y][x + 1] = 'p'
        game.board[y][x - 1] = 'p'
      end

      it 'should have diagonal moves' do
        start_pos = [1, 1]
        end_pos = [1, 2]
        pawn = game.white_pawn(start_pos, end_pos)
        expect(pawn.moves).to eq [[1, 1], [-1, 1]]
      end
    end
  end
end
