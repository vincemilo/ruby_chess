# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../lib/units/king'
require_relative '../../lib/board'

describe King do
  def display_board
    print "#{('a'..'h').to_a} \n"
    board.data.reverse.each do |row|
      puts row.to_s
    end
    print "#{('a'..'h').to_a} \n"
  end

  describe '#assign_moves' do
    context 'when a surrounded king is selected' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      it 'assigns the correct moves' do
        row = 4
        col = 3
        board.data[row][col] = 'K'
        board.data[row + 1][col + 1] = 'P'
        board.data[row - 1][col + 1] = 'n'
        board.data[row][col + 1] = 'n'
        board.data[row][col - 1] = 'R'
        board.data[row + 1][col] = 'p'
        board.data[row - 1][col] = 'R'
        w_king = king.assign_moves([col, row], king)
        king_moves = [[1, -1]]
        expect(w_king.moves).to eq(king_moves)
      end
    end

    context 'when a white king on the edge is selected' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      it 'assigns the correct moves' do
        row = 0
        col = 0
        board.data[row][col] = 'K'
        w_king = king.assign_moves([col, row], king)
        king_moves = [[1, 1], [1, 0], [0, 1]]
        expect(w_king.moves).to eq(king_moves)
      end
    end

    context 'when a black king on the edge is selected' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'assigns the correct moves' do
        row = 7
        col = 7
        board.data[row][col] = 'k'
        b_king = king.assign_moves([col, row], king)
        king_moves = [[-1, -1], [-1, 0], [0, -1]]
        expect(b_king.moves).to eq(king_moves)
      end
    end

    context 'when a white king with hostile left and right cols is selected' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      it 'assigns the correct moves' do
        row = 2
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 5][col - 1] = 'r'
        board.data[row - 2][col + 1] = 'r'
        w_king = king.assign_moves([col, row], king)
        king_moves = [[0, 1], [0, -1]]
        expect(w_king.moves).to eq(king_moves)
      end
    end

    context 'when a white king with hostile up and down rows is selected' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      it 'assigns the correct moves' do
        row = 2
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 1][col - 4] = 'r'
        board.data[row - 1][col + 2] = 'r'
        w_king = king.assign_moves([col, row], king)
        king_moves = [[1, 0], [-1, 0]]
        expect(w_king.moves).to eq(king_moves)
      end
    end

    context 'when a white king with hostile r col friendly l col is selected' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      it 'assigns the correct moves' do
        row = 0
        col = 6
        board.data[row][col] = 'K'
        board.data[row + 7][col + 1] = 'r'
        board.data[row][col - 1] = 'R'
        w_king = king.assign_moves([col, row], king)
        king_moves = [[-1, 1], [0, 1]]
        expect(w_king.moves).to eq(king_moves)
      end
    end

    context 'when a white king is checkmated via cols' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      it 'should have no moves' do
        row = 0
        col = 7
        board.data[row][col] = 'K'
        board.data[row + 7][col] = 'r'
        board.data[row + 6][col - 1] = 'r'
        w_king = king.assign_moves([col, row], king)
        king_moves = []
        expect(w_king.moves).to eq(king_moves)
      end
    end

    context 'when a black king is checkmated via cols' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'should have no moves' do
        row = 7
        col = 7
        board.data[row][col] = 'k'
        board.data[row - 7][col] = 'R'
        board.data[row - 6][col - 1] = 'R'
        w_king = king.assign_moves([col, row], king)
        king_moves = []
        expect(w_king.moves).to eq(king_moves)
      end
    end

    context 'when a white king is checkmated via rows' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      it 'should have no moves' do
        row = 0
        col = 6
        board.data[row][col] = 'K'
        board.data[row][col - 6] = 'r'
        board.data[row + 1][col - 5] = 'r'
        w_king = king.assign_moves([col, row], king)
        king_moves = []
        expect(w_king.moves).to eq(king_moves)
      end
    end

    context 'when a white king is surrounded by hostile pawns' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      it 'should assign the correct moves' do
        row = 0
        col = 6
        board.data[row][col] = 'K'
        board.data[row + 2][col + 1] = 'p'
        board.data[row + 2][col] = 'p'
        w_king = king.assign_moves([col, row], king)
        king_moves = [[1, 0], [-1, 0]]
        expect(w_king.moves).to eq(king_moves)
      end
    end

    context 'when a white king is surrounded by hostile pawns' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'should assign the correct moves' do
        row = 7
        col = 6
        board.data[row][col] = 'k'
        board.data[row - 2][col - 1] = 'P'
        board.data[row - 2][col] = 'P'
        b_king = king.assign_moves([col, row], king)
        king_moves = [[1, 0], [-1, 0]]
        expect(b_king.moves).to eq(king_moves)
      end
    end

    context 'when a white king has an enemy king nearby' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns the correct value' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 2][col] = 'k'
        w_king = king.assign_moves([col, row], king)
        king_moves = [[1, 0], [-1, 0]]
        expect(w_king.moves).to eq(king_moves)
      end
    end

    context 'when a black king has an enemy king nearby' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'returns the correct value' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 2][col] = 'K'
        b_king = king.assign_moves([col, row], king)
        king_moves = [[1, 0], [-1, 0]]
        expect(b_king.moves).to eq(king_moves)
      end
    end

    context 'when a white king has an enemy knight nearby' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns the correct value' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 2][col] = 'n'
        w_king = king.assign_moves([col, row], king)
        king_moves = [[1, 1], [-1, 1], [0, 1]]
        expect(w_king.moves).to eq(king_moves)
      end
    end

    context 'when a black king has an enemy knight nearby' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'returns the correct value' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 2][col] = 'N'
        b_king = king.assign_moves([col, row], king)
        king_moves = [[1, -1], [-1, -1], [0, -1]]
        expect(b_king.moves).to eq(king_moves)
      end
    end

    context 'when a black king is in check via enemy knight' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'returns the correct value' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 2][col] = 'N'
        b_king = king.assign_moves([col, row], king)
        king_moves = [[1, -1], [-1, -1], [0, -1]]
        expect(b_king.moves).to eq(king_moves)
      end
    end

    context 'when a white king has both castling options available' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns the correct options' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row][col + 3] = 'R'
        board.data[row][col - 4] = 'R'
        board.data[row + 1][col + 1] = 'P'
        board.data[row + 1][col] = 'P'
        board.data[row + 1][col - 1] = 'P'
        w_king = king.assign_moves([col, row], king)
        king_moves = [[1, 0], [-1, 0], [2, 0], [-2, 0]]
        expect(w_king.moves).to eq(king_moves)
      end
    end

    context 'when a white king can capture via right diag' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 6
        board.data[row][col] = 'K'
        board.data[row + 1][col + 1] = 'r'
        w_king = king.assign_moves([col, row], king)
        king_moves = [[1, 1], [-1, 0]]
        expect(w_king.moves).to eq(king_moves)
      end
    end

    context 'when a w king cant capture via r col due to defended piece' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 3
        col = 6
        board.data[row][col] = 'K'
        board.data[row][col + 1] = 'r'
        board.data[row][col - 6] = 'r'
        w_king = king.assign_moves([col, row], king)
        king_moves = [[-1, -1], [-1, 1], [0, 1], [0, -1]]
        expect(w_king.moves).to eq(king_moves)
      end
    end

    context 'when a black king is blocked via pos and neg diag' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 7
        col = 3
        board.data[row][col] = 'k'
        board.data[row - 1][col] = 'p'
        board.data[row - 2][col - 3] = 'B'
        board.data[row - 3][col + 4] = 'Q'
        b_king = king.assign_moves([col, row], king)
        king_moves = [[1, -1], [-1, -1]]
        expect(b_king.moves).to eq(king_moves)
      end
    end

    context 'when a black king is checkmated via diag' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 7
        col = 6
        board.data[row][col] = 'k'
        board.data[row - 2][col - 1] = 'B'
        board.data[row - 1][col] = 'Q'
        b_king = king.assign_moves([col, row], king)
        king_moves = []
        expect(b_king.moves).to eq(king_moves)
      end
    end
  end

  describe '#check_1' do
    context 'when a black king can capture via right up diag' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 6
        col = 1
        board.data[row][col] = 'k'
        board.data[row + 1][col + 1] = 'B'
        b_king = king.check_1(row, col, king)
        king_moves = [[1, 1]]
        expect(b_king.moves).to eq(king_moves)
      end
    end
  end

  describe '#check_l' do
    context 'when a black king is blocked via pos diag' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 7
        col = 3
        board.data[row][col] = 'k'
        board.data[row - 1][col] = 'p'
        board.data[row - 2][col - 3] = 'B'
        board.data[row - 3][col + 4] = 'Q'
        b_king = king.check_l(row, col, king)
        king_moves = []
        expect(b_king.moves).to eq(king_moves)
      end
    end

    context 'when a black king can capture via left col' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 6
        col = 1
        board.data[row][col] = 'k'
        board.data[row][col - 1] = 'R'
        b_king = king.check_l(row, col, king)
        king_moves = [[-1, 0]]
        expect(b_king.moves).to eq(king_moves)
      end
    end
  end

  describe '#check_r' do
    context 'when a black king is blocked via pos and neg diag' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 7
        col = 3
        board.data[row][col] = 'k'
        board.data[row - 1][col] = 'p'
        board.data[row - 3][col + 4] = 'Q'
        b_king = king.check_r(row, col, king)
        king_moves = []
        expect(b_king.moves).to eq(king_moves)
      end
    end

    context 'when a white king can capture via right col' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 3
        col = 6
        board.data[row][col] = 'K'
        board.data[row][col + 1] = 'r'
        w_king = king.check_r(row, col, king)
        king_moves = [[1, 0]]
        expect(w_king.moves).to eq(king_moves)
      end
    end
  end

  describe '#check_u' do
    context 'when a black king can capture via up row' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 6
        col = 1
        board.data[row][col] = 'k'
        board.data[row + 1][col] = 'R'
        b_king = king.check_u(row, col, king)
        king_moves = [[0, 1]]
        expect(b_king.moves).to eq(king_moves)
      end
    end
  end

  describe '#check_d' do
    context 'when a white king can capture via right col' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 3
        col = 6
        board.data[row][col] = 'K'
        board.data[row][col - 1] = 'r'
        w_king = king.check_d(row, col, king)
        king_moves = [[0, -1]]
        expect(w_king.moves).to eq(king_moves)
      end
    end
  end

  describe '#move_king' do
    context 'when a white king castles right' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row][col + 3] = 'R'
        king.move_king([col, row], [col + 2, row])
        expect(board.data[row][col + 2]).to eq('K')
        expect(board.data[row][col + 1]).to eq('R')
      end
    end

    context 'when a black king castles right' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row][col + 3] = 'r'
        king.move_king([col, row], [col + 2, row])
        expect(board.data[row][col + 2]).to eq('k')
        expect(board.data[row][col + 1]).to eq('r')
      end
    end
  end
end
