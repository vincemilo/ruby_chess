# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../lib/units/pawn'
require_relative '../../lib/board'

describe Pawn do
  # let(:board) { instance_double(Board) }
  subject(:pawn) { described_class.new }

  describe '#r_diag' do
    before do
      x = 3
      y = 2
      pawn.board.data[y][x] = 'p' # coords must be entered reverse due to array
    end

    it 'returns the square 1 up and 1 right of the selected piece' do
      start_pos = [2, 1]
      expect(pawn.r_diag(start_pos)).to eq('p')
    end
  end

  describe '#l_diag' do
    before do
      x = 1
      y = 2
      pawn.board[y][x] = 'p' # coords must be entered reverse due to array
    end

    xit 'returns the square 1 up and 1 left of the selected piece' do
      start_pos = [2, 1]
      expect(pawn.l_diag(start_pos)).to eq('p')
    end
  end

  describe '#white_pawn' do
    # subject(:w_pawn) { described_class.new(board) }

    context 'when a white pawn is in its starting position
             with no units ahead and no diagonal captures' do
      xit 'has 1 move or 2 move ahead options' do
        start_pos = [1, 1]
        end_pos = [1, 3]
        w_pawn = pawn.white_pawn(start_pos, end_pos, pawn)
        expect(w_pawn.moves).to eq [[0, 1], [0, 2]]
      end
    end

    context 'when a white pawn is in its starting position
             with no units ahead and has two diagonal captures' do
      before do
        x = 3
        y = 2
        pawn.board[y][x] = 'p'
        pawn.board[y][x - 2] = 'p'
      end

      xit 'has all move options' do
        start_pos = [2, 1]
        end_pos = [3, 2]
        pawn = pawn.white_pawn(start_pos, end_pos)
        expect(pawn.moves).to eq [[0, 1], [0, 2], [1, 1], [-1, 1]]
      end
    end

    context 'when a unit is two spaces in front and no diagonal
             captures available' do
      before do
        x = 1
        y = 3
        pawn.board[y][x] = 'p'
      end

      xit 'should have one move ahead' do
        start_pos = [1, 1]
        end_pos = [1, 3]
        pawn = pawn.white_pawn(start_pos, end_pos)
        expect(pawn.moves).to eq [[0, 1]]
      end
    end

    context 'when a unit is one space in front and no diagonal
             captures available' do
      before do
        x = 1
        y = 2
        pawn.board[y][x] = 'p'
      end

      xit 'should have no legal moves' do
        start_pos = [1, 1]
        end_pos = [1, 2]
        pawn = pawn.white_pawn(start_pos, end_pos)
        expect(pawn.moves).to eq []
      end
    end

    context 'when a unit is one space in front but pawn has diagonal
             captures available' do
      before do
        x = 1
        y = 2
        pawn.board[y][x] = 'p'
        pawn.board[y][x + 1] = 'p'
        pawn.board[y][x - 1] = 'p'
      end

      xit 'should have diagonal moves' do
        start_pos = [1, 1]
        end_pos = [1, 2]
        w_pawn = pawn.white_pawn(start_pos, end_pos)
        expect(w_pawn.moves).to eq [[1, 1], [-1, 1]]
      end
    end
  end
end
