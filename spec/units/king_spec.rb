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
        board.data[row + 1][col] = 'n'
        board.data[row - 1][col] = 'R'
        w_king = king.assign_moves([col, row], king)
        king_moves = [[1, -1], [-1, -1], [-1, 1], [1, 0], [0, 1]]
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
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 1][col + 1] = 'N'
        board.data[row][col + 1] = 'N'
        board.data[row][col - 1] = 'r'
        board.data[row - 1][col] = 'r'
        b_king = king.assign_moves([col, row], king)
        king_moves = [[1, -1], [-1, -1], [1, 0]]
        expect(b_king.moves).to eq(king_moves)
      end
    end
  end

  describe '#castle' do
    context 'when a white king castles right' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row][col + 3] = 'R'
        king.castle([col + 2, row])
        expect(board.data[row][col + 1]).to eq('R')
      end
    end

    context 'when a white king castles left' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row][col - 4] = 'R'
        king.castle([col - 2, row])
        expect(board.data[row][col - 1]).to eq('R')
      end
    end

    context 'when a black king castles right' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row][col + 3] = 'r'
        king.castle([col + 2, row])
        expect(board.data[row][col + 1]).to eq('r')
      end
    end

    context 'when a black king castles left' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row][col - 4] = 'r'
        king.castle([col - 2, row])
        expect(board.data[row][col - 1]).to eq('r')
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

  describe '#assign_castle_moves' do
    context 'when a white king castles right' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row][col + 3] = 'R'
        king.assign_castle_moves
        expect(king.moves).to eq([[2, 0], [-2, 0]])
      end
    end

    context 'when a black king castles right' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row][col + 3] = 'r'
        king.assign_castle_moves
        expect(king.moves).to eq([[2, 0], [-2, 0]])
      end
    end
  end

  describe '#hostile_r_col?' do
    context 'when a white king has a hostile r column' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns true' do
        row = 0
        col = 6
        board.data[row][col] = 'K'
        board.data[row + 7][col + 1] = 'r'
        expect(king.hostile_r_col?(col, row)).to eq(true)
      end
    end

    context 'when a white king has an non-hostile r column' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 0
        col = 6
        board.data[row][col] = 'K'
        board.data[row + 7][col + 1] = 'R'
        expect(king.hostile_r_col?(col, row)).to eq(false)
      end
    end

    context 'when a black king has a hostile r column' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:king) { described_class.new(board) }

      it 'returns true' do
        row = 7
        col = 6
        board.data[row][col] = 'k'
        board.data[row - 7][col + 1] = 'R'
        expect(king.hostile_r_col?(col, row)).to eq(true)
      end
    end

    context 'when a black king has an non-hostile r column' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 7
        col = 6
        board.data[row][col] = 'k'
        board.data[row - 7][col + 1] = 'r'
        expect(king.hostile_r_col?(col, row)).to eq(false)
      end
    end
  end

  describe '#hostile_l_col?' do
    context 'when a white king has a hostile l column' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns true' do
        row = 0
        col = 6
        board.data[row][col] = 'K'
        board.data[row + 7][col - 1] = 'r'
        expect(king.hostile_l_col?(col, row)).to eq(true)
      end
    end

    context 'when a white king has an non-hostile l column' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 0
        col = 6
        board.data[row][col] = 'K'
        board.data[row + 7][col - 1] = 'R'
        expect(king.hostile_l_col?(col, row)).to eq(false)
      end
    end

    context 'when a black king has a hostile l column' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:king) { described_class.new(board) }

      it 'returns true' do
        row = 7
        col = 6
        board.data[row][col] = 'k'
        board.data[row - 7][col - 1] = 'R'
        expect(king.hostile_l_col?(col, row)).to eq(true)
      end
    end

    context 'when a black king has an non-hostile l column' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 7
        col = 6
        board.data[row][col] = 'k'
        board.data[row - 7][col - 1] = 'r'
        expect(king.hostile_l_col?(col, row)).to eq(false)
      end
    end
  end

  describe '#hostile_u_row?' do
    context 'when a white king has a hostile up row' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns true' do
        row = 1
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 1][col + 3] = 'r'
        expect(king.hostile_u_row?(col, row)).to eq(true)
      end
    end

    context 'when a white king has no hostile up row' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 1
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 1][col + 3] = 'R'
        expect(king.hostile_u_row?(col, row)).to eq(false)
      end
    end

    context 'when a black king has a hostile up row' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:king) { described_class.new(board) }

      it 'returns true' do
        row = 1
        col = 4
        board.data[row][col] = 'k'
        board.data[row + 1][col + 3] = 'R'
        expect(king.hostile_u_row?(col, row)).to eq(true)
      end
    end

    context 'when a black king has no hostile up row' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 1
        col = 4
        board.data[row][col] = 'k'
        board.data[row + 1][col + 3] = 'r'
        expect(king.hostile_u_row?(col, row)).to eq(false)
      end
    end
  end

  describe '#hostile_d_row?' do
    context 'when a white king has a hostile up row' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns true' do
        row = 1
        col = 4
        board.data[row][col] = 'K'
        board.data[row - 1][col + 3] = 'r'
        expect(king.hostile_d_row?(col, row)).to eq(true)
      end
    end

    context 'when a white king has no hostile up row' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 1
        col = 4
        board.data[row][col] = 'K'
        board.data[row - 1][col + 3] = 'R'
        expect(king.hostile_d_row?(col, row)).to eq(false)
      end
    end

    context 'when a black king has a hostile up row' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:king) { described_class.new(board) }

      it 'returns true' do
        row = 1
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 1][col + 3] = 'R'
        expect(king.hostile_d_row?(col, row)).to eq(true)
      end
    end

    context 'when a black king has no hostile up row' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 1
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 1][col + 3] = 'r'
        expect(king.hostile_d_row?(col, row)).to eq(false)
      end
    end
  end

  describe '#hostile_neg_diag?' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
    subject(:king) { described_class.new(board) }

    it 'returns true' do
      row = 3
      col = 4
      board.data[row][col] = 'K'
      board.data[row - 1][col + 3] = 'b'
      king.hostile_neg_diag?(col + 1, row + 1)
      expect(king.hostile_neg_diag?(col + 1, row + 1)).to eq(true)
    end
  end
end
