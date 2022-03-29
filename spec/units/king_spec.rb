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
