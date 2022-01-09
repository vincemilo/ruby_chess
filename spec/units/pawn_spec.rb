# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../lib/units/pawn'

describe Pawn do
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
      pawn.board.data[y][x] = 'p'
    end

    it 'returns the square 1 up and 1 left of the selected piece' do
      start_pos = [2, 1]
      expect(pawn.l_diag(start_pos)).to eq('p')
    end
  end

  describe '#white_pawn' do
    # subject(:w_pawn) { described_class.new(board) }

    context 'when a white pawn is in its starting position
             with no units ahead and no diagonal captures' do
      it 'has 1 move or 2 move ahead options' do
        start_pos = [1, 1]
        w_pawn = pawn.white_pawn(start_pos, pawn)
        expect(w_pawn.moves).to eq [[0, 1], [0, 2]]
      end
    end

    context 'when a white pawn is in its starting position
             with no units ahead and has two diagonal captures' do
      before do
        x = 3
        y = 2
        pawn.board.data[y][x] = 'p'
        pawn.board.data[y][x - 2] = 'p'
        pawn.board.display_board
      end

      it 'has all move options' do
        start_pos = [2, 1]
        w_pawn = pawn.white_pawn(start_pos, pawn)
        expect(w_pawn.moves).to eq [[0, 1], [0, 2], [1, 1], [-1, 1]]
      end
    end

    context 'when a unit is two spaces in front and no diagonal
             captures available' do
      before do
        x = 1
        y = 3
        pawn.board.data[y][x] = 'p'
      end

      it 'should have one move ahead' do
        start_pos = [1, 1]
        w_pawn = pawn.white_pawn(start_pos, pawn)
        expect(w_pawn.moves).to eq [[0, 1]]
      end
    end

    context 'when a unit is one space in front and no diagonal
             captures available' do
      before do
        x = 1
        y = 2
        pawn.board.data[y][x] = 'p'
      end

      it 'should have no legal moves' do
        start_pos = [1, 1]
        w_pawn = pawn.white_pawn(start_pos, pawn)
        expect(w_pawn.moves).to eq []
      end
    end

    context 'when a unit is one space in front but pawn has diagonal
             captures available' do
      before do
        x = 1
        y = 2
        pawn.board.data[y][x] = 'p'
        pawn.board.data[y][x + 1] = 'p'
        pawn.board.data[y][x - 1] = 'p'
      end

      it 'should have diagonal moves' do
        start_pos = [1, 1]
        w_pawn = pawn.white_pawn(start_pos, pawn)
        expect(w_pawn.moves).to eq [[1, 1], [-1, 1]]
      end
    end
  end

  describe '#black_pawn' do
    before do
      pawn.board.turn = 1
    end

    context 'when a black pawn is in its starting position
             with no units ahead and no diagonal captures' do
      it 'has 1 move or 2 move ahead options' do
        start_pos = [1, 6]
        b_pawn = pawn.black_pawn(start_pos, pawn)
        expect(b_pawn.moves).to eq [[0, -1], [0, -2]]
      end
    end

    context 'when a black pawn is in its starting position
             with no units ahead and has two diagonal captures' do
      before do
        x = 3
        y = 5
        pawn.board.data[y][x] = 'P'
        pawn.board.data[y][x - 2] = 'P'
      end

      it 'has all move options' do
        start_pos = [2, 6]
        b_pawn = pawn.black_pawn(start_pos, pawn)
        expect(b_pawn.moves).to eq [[0, -1], [0, -2], [-1, -1], [1, -1]]
      end
    end

    context 'when a unit is two spaces in front and no diagonal
             captures available' do
      before do
        x = 1
        y = 4
        pawn.board.data[y][x] = 'P'
      end

      it 'should have one move ahead' do
        start_pos = [1, 6]
        b_pawn = pawn.black_pawn(start_pos, pawn)
        expect(b_pawn.moves).to eq [[0, -1]]
      end
    end

    context 'when a unit is one space in front and no diagonal
             captures available' do
      before do
        x = 1
        y = 5
        pawn.board.data[y][x] = 'P'
      end

      it 'should have no legal moves' do
        start_pos = [1, 6]
        b_pawn = pawn.black_pawn(start_pos, pawn)
        expect(b_pawn.moves).to eq []
      end
    end

    context 'when a unit is one space in front but pawn has diagonal
             captures available' do
      before do
        x = 1
        y = 5
        pawn.board.data[y][x] = 'P'
        pawn.board.data[y][x + 1] = 'P'
        pawn.board.data[y][x - 1] = 'P'
      end

      it 'should have diagonal moves' do
        start_pos = [1, 6]
        b_pawn = pawn.black_pawn(start_pos, pawn)
        expect(b_pawn.moves).to eq [[-1, -1], [1, -1]]
      end
    end
  end

  describe '#promote' do
    context 'when a white pawn reaches the last row' do
      xit '' do
      end
    end
  end

  describe '#en_passant' do
    context 'when a black pawn moves two squares past a white pawn' do
      subject(:b_pawn) { described_class.new([1, 6]) }
      before do
        x = 1
        y = 4
        b_pawn.board.data[y][x + 1] = 'P'
        b_pawn.board.display_board
      end

      it 'allows a capture' do
        p b_pawn.start_pos
      end
    end
  end
end
