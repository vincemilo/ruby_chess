# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../lib/units/unit'

describe Unit do
  subject(:unit) { described_class.new }

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
      x = 4
      y = 1
      unit.board.data[y][x] = 'P'
      unit.move_unit([4, 1], [4, 3])
    end

    context 'when it\'s white\'s turn' do
      it 'moves a unit from one location to another' do
        x = 4
        y = 3
        expect(unit.board.data[y][x]).to eq('P')
      end
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
