# frozen_string_literal: true

require_relative '../../lib/units/rook'
require_relative '../../lib/board'

describe Rook do
  def display_board
    print "#{('a'..'h').to_a} \n"
    board.data.reverse.each do |row|
      puts row.to_s
    end
    print "#{('a'..'h').to_a} \n"
  end

  describe '#check_vert' do
    context 'when a rook has no units vertical on either side' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr) }
      subject(:rook) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(false)
      end

      it 'has 7 vertical move options' do
        row = 4
        col = 3
        board.data[row][col] = 'R'
        w_rook = rook.check_vert([row, col], rook)
        rook_moves = [[5, 3], [6, 3], [7, 3], [3, 3], [2, 3], [1, 3], [0, 3]]
        expect(w_rook.moves).to eq(rook_moves)
      end
    end
  end

  describe '#check_horiz' do
    context 'when a rook has no units horizontal on either side' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr) }
      subject(:rook) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(false)
      end

      it 'has 7 horizontal move options' do
        row = 4
        col = 3
        board.data[row][col] = 'R'
        w_rook = rook.check_horiz([row, col], rook)
        rook_moves = [[4, 4], [4, 5], [4, 6], [4, 7], [4, 2], [4, 1], [4, 0]]
        expect(w_rook.moves).to eq(rook_moves)
      end
    end
  end
end
