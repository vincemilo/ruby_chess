# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../lib/units/unit'
require_relative '../../lib/board'
require_relative '../../lib/units/pawn'

describe Unit do
  def display_board
    print "#{('a'..'h').to_a} \n"
    board.data.reverse.each do |row|
      puts row.to_s
    end
    print "#{('a'..'h').to_a} \n"
  end

  describe '#r_diag' do
    arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { instance_double(Board, data: arr, turn: 0) }
    subject(:unit) { described_class.new(board) }

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
    arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { instance_double(Board, data: arr, turn: 0) }
    subject(:unit) { described_class.new(board) }

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

  describe '#move_validator' do
    context 'when it\'s white\'s turn and a move entered is valid' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:unit) { described_class.new(board) }
      let(:w_pawn) { instance_double(Pawn, moves: [[0, 1], [0, 2]]) }

      it 'returns true' do
        expect(unit.move_validator([1, 1], [1, 3], w_pawn)).to be true
      end
    end

    context 'when it\'s black\'s turn and a move entered is valid' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:unit) { described_class.new(board) }
      let(:b_pawn) { instance_double(Pawn, moves: [[0, -1], [0, -2]]) }

      it 'returns true' do
        expect(unit.move_validator([1, 6], [1, 4], b_pawn)).to be true
      end
    end
  end
end
