# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

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
        rook_moves = [[0, 1], [0, 2], [0, 3], [0, -1], [0, -2], [0, -3], [0, -4]]
        expect(w_rook.moves).to eq(rook_moves)
      end
    end

    context 'when a rook has enemy units vertical on either side' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr) }
      subject(:rook) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(true)
      end

      it 'has 2 vertical move options' do
        row = 4
        col = 3
        board.data[row][col] = 'R'
        board.data[row + 1][col] = 'r'
        board.data[row - 1][col] = 'r'
        w_rook = rook.check_vert([row, col], rook)
        rook_moves = [[0, 1], [0, -1]]
        expect(w_rook.moves).to eq(rook_moves)
      end
    end

    context 'when a rook has friendly units vertical on either side' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # instance_double(Board, data: arr) }
      subject(:rook) { described_class.new(board) }

      before do
        # allow(board).to receive(:enemy_occupied?).and_return(false)
      end

      it 'has 0 vertical move options' do
        row = 0
        col = 0
        board.data[row][col] = 'R'
        board.data[row + 1][col] = 'P'
        # board.data[row - 1][col] = 'R'
        w_rook = rook.check_vert([row, col], rook)
        # board.display_board
        rook_moves = []
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
        rook_moves = [[1, 0], [2, 0], [3, 0], [4, 0], [-1, 0], [-2, 0], [-3, 0]]
        expect(w_rook.moves).to eq(rook_moves)
      end
    end

    context 'when a rook has enemy units horizontal on either side' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr) }
      subject(:rook) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(true)
      end

      it 'has 2 horizontal move options' do
        row = 4
        col = 3
        board.data[row][col] = 'R'
        board.data[row][col + 1] = 'r'
        board.data[row][col - 1] = 'r'
        w_rook = rook.check_horiz([row, col], rook)
        rook_moves = [[1, 0], [-1, 0]]
        expect(w_rook.moves).to eq(rook_moves)
      end
    end

    context 'when a rook has friendly units horizontal on either side' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr) }
      subject(:rook) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(false)
      end

      it 'has 0 horizontal move options' do
        row = 4
        col = 3
        board.data[row][col] = 'R'
        board.data[row][col + 1] = 'R'
        board.data[row][col - 1] = 'R'
        w_rook = rook.check_horiz([row, col], rook)
        rook_moves = []
        expect(w_rook.moves).to eq(rook_moves)
      end
    end
  end

  describe '#assign_moves' do
    context 'when a rook has no units vertical or horizontal' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr) }
      subject(:rook) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(false)
      end

      it 'displays the correct available moves' do
        row = 4
        col = 3
        board.data[row][col] = 'R'
        w_rook = rook.assign_moves([row, col], rook)
        rook_moves = [[0, 1], [0, 2], [0, 3], [0, -1], [0, -2], [0, -3], [0, -4],
                      [1, 0], [2, 0], [3, 0], [4, 0], [-1, 0], [-2, 0], [-3, 0]]
        expect(w_rook.moves).to eq(rook_moves)
      end
    end

    context 'when a rook has various units on either side' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new }
      subject(:rook) { described_class.new(board) }
      subject(:rook2) { described_class.new(board) }

      it 'displays the correct availabile moves' do
        row = 0
        col = 0
        board.data[row][col] = 'R'
        board.data[row + 2][col] = 'P'
        board.data[row][col + 7] = 'R'
        board.data[row + 6][col] = 'p'
        board.data[row + 7][col + 7] = 'r'
        w_rook = rook.assign_moves([row, col], rook)
        rook_moves = [[0, 1], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0]]
        expect(w_rook.moves).to eq(rook_moves)
        w_rook2 = rook2.assign_moves([row, col + 7], rook2)
        rook2_moves = [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
                       [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0]]
        expect(w_rook2.moves).to eq(rook2_moves)
      end
    end
  end
end
