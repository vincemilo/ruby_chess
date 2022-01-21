# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../lib/units/unit'
require_relative '../../lib/board'
require_relative '../../lib/units/pawn'

describe Unit do
  arr = Array.new(8) { Array.new(8, '0') }
  let(:board) { instance_double(Board, data: arr, turn: 0) }
  subject(:unit) { described_class.new(board) }

  describe '#r_diag' do
    before do
      x = 3
      y = 2
      unit.board.data[y][x] = 'p' # coords must be entered reverse due to array
    end

    it 'returns the square 1 up and 1 right of the selected piece' do
      start_pos = [2, 1]
      expect(unit.r_diag(start_pos)).to eq('p')
    end
  end

  describe '#l_diag' do
    before do
      x = 1
      y = 2
      unit.board.data[y][x] = 'p'
    end

    it 'returns the square 1 up and 1 left of the selected piece' do
      start_pos = [2, 1]
      expect(unit.l_diag(start_pos)).to eq('p')
    end
  end

  describe '#get_unit' do
    before do
      x = 1
      y = 2
      unit.board.data[y][x] = 'P'
    end

    it 'returns the piece at the given coordinates' do
      expect(unit.get_unit([1, 2])).to eq('P')
    end
  end

  describe '#move_unit' do
    before do
      allow(board).to receive(:update_turn)
      allow(board).to receive(:off_the_board?).and_return(false)
    end

    context 'when it\'s white\'s turn' do
      before do
        allow(unit).to receive(:get_unit).and_return('P')
      end

      it 'moves a unit from one location to another' do
        x = 4
        y = 1
        unit.board.data[y][x] = 'P'
        unit.move_unit([x, y], [x, y + 2])
        expect(unit.board.data[y + 2][x]).to eq('P')
      end
    end

    context 'when it\'s black\'s turn' do
      before do
        allow(unit).to receive(:get_unit).and_return('p')
      end

      it 'moves a unit from one location to another' do
        x = 4
        y = 6
        unit.board.data[y][x] = 'p'
        unit.move_unit([x, y], [x, y - 2])
        expect(unit.board.data[y - 2][x]).to eq('p')
      end
    end
  end

  describe '#move_validator' do
    context 'when it\'s white\'s turn and a move entered is valid' do
      let(:w_pawn) { instance_double(Pawn, moves: [[0, 1], [0, 2]]) }

      it 'returns true' do
        expect(unit.move_validator([1, 1], [1, 3], w_pawn)).to be true
      end
    end

    context 'when it\'s black\'s turn and a move entered is valid' do
      let(:b_pawn) { instance_double(Pawn, moves: [[0, -1], [0, -2]]) }

      it 'returns true' do
        expect(unit.move_validator([1, 6], [1, 4], b_pawn)).to be true
      end
    end
  end
end
