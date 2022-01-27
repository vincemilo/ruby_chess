# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/board'
require_relative '../lib/units/pawn'

describe Board do
  subject(:board) { described_class.new }

  describe '#get_unit' do
    before do
      row = 2
      col = 1
      board.data[row][col] = 'P'
    end

    it 'returns the piece at the given coordinates' do
      expect(board.get_unit([1, 2])).to eq('P')
    end
  end

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

  describe '#move_unit' do
    context 'when it\'s white\'s turn' do
      it 'moves a unit from one location to another' do
        x = 4
        y = 1
        board.data[y][x] = 'P'
        board.move_unit([x, y], [x, y + 2])
        expect(board.data[y + 2][x]).to eq('P')
      end
    end

    context 'when it\'s black\'s turn' do
      it 'moves a unit from one location to another' do
        x = 4
        y = 6
        board.data[y][x] = 'p'
        board.move_unit([x, y], [x, y - 2])
        expect(board.data[y - 2][x]).to eq('p')
      end
    end
  end

  describe '#capture' do
    context 'when it\'s white\'s turn and a valid capture is entered' do
      subject(:board) { described_class.new }
      let(:w_pawn) { instance_double(Pawn, moves: [[1, 1]]) }

      before do
        allow(board).to receive(:puts)
      end

      it 'captures the piece and adds it to the list' do
        row = 3
        col = 4
        board.data[row][col] = 'P'
        board.data[row + 1][col + 1] = 'p'
        board.capture([col + 1, row + 1])
        expect(board.captured).to eq([['p'], []])
      end
    end
  end

  describe '#en_passant_capture' do
    context 'when it\'s white\'s turn and a valid capture is entered' do
      subject(:board) { described_class.new }

      before do
        allow(board).to receive(:puts)
        board.update_en_passant([5, 4])
      end

      it 'captures the piece and adds it to the list' do
        row = 4
        col = 4
        board.data[row][col] = 'P'
        board.data[row][col + 1] = 'p'
        board.en_passant_capture
        expect(board.captured).to eq([['p'], []])
      end
    end

    context 'when it\'s black\'s turn and a valid capture is entered' do
      subject(:board) { described_class.new }

      before do
        # allow(board).to receive(:puts)
        board.update_turn
        board.update_en_passant([1, 3])
      end

      it 'captures the piece and adds it to the list' do
        row = 3
        col = 2
        board.data[row][col] = 'p'
        board.data[row][col - 1] = 'P'
        board.en_passant_capture
        board.display_board
        expect(board.captured).to eq([[], ['P']])
      end
    end
  end
end
