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
        display_board
        expect(king.hostile_r_col?(col + 1, row)).to eq(true)
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
        expect(king.hostile_r_col?(col + 1, row)).to eq(false)
      end
    end

    context 'when a white king has an non-hostile r column via capture' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 1
        col = 6
        board.data[row][col] = 'K'
        board.data[row][col + 1] = 'r'
        expect(king.hostile_r_col?(col + 1, row)).to eq(false)
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
        expect(king.hostile_r_col?(col + 1, row)).to eq(true)
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
        expect(king.hostile_r_col?(col + 1, row)).to eq(false)
      end
    end
  end

  describe '#hostile_r_col_diag?' do
    context 'when a white king is put in check but can escape via capture' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 1][col + 1] = 'r'
        board.data[row][col + 2] = 'r'
        expect(king.hostile_r_col_diag?(col + 1, row + 1)).to eq(false)
        expect(king.r_u_diag_invalid?(row, col)).to eq(false)
      end
    end

    context 'when a white king is put in check but can escape via capture' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row - 1][col + 1] = 'r'
        board.data[row][col + 2] = 'r'
        expect(king.hostile_r_col_diag?(col + 1, row - 1)).to eq(false)
        expect(king.r_d_diag_invalid?(row, col)).to eq(false)
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
        expect(king.hostile_l_col?(col - 1, row)).to eq(true)
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
        expect(king.hostile_l_col?(col - 1, row)).to eq(false)
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
        expect(king.hostile_l_col?(col - 1, row)).to eq(true)
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
        expect(king.hostile_l_col?(col - 1, row)).to eq(false)
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
        expect(king.hostile_u_row?(col, row + 1)).to eq(true)
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

    context 'when a white king has no hostile up row via capture' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 1
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 1][col + 1] = 'r'
        expect(king.hostile_u_row?(col + 1, row + 1)).to eq(false)
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
        expect(king.hostile_u_row?(col, row + 1)).to eq(true)
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
        expect(king.hostile_d_row?(col, row - 1)).to eq(true)
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
        expect(king.hostile_d_row?(col, row - 1)).to eq(false)
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
        expect(king.hostile_d_row?(col, row - 1)).to eq(true)
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
        expect(king.hostile_d_row?(col, row - 1)).to eq(false)
      end
    end
  end

  describe '#hostile_neg_diag?' do
    context 'when an bishop is blocking the up right diag of a white king' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns true' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row - 1][col + 3] = 'b'
        expect(king.hostile_neg_diag?(col + 1, row + 1)).to eq(true)
        expect(king.r_u_diag_invalid?(row, col)).to eq(true)
      end
    end

    context 'when a bishop is not blocking the up right diag of a white king' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row][col + 3] = 'b'
        expect(king.hostile_neg_diag?(col + 1, row + 1)).to eq(false)
      end
    end

    context 'when a bishop is blocking the down left diag of a white king' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns true' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 1][col - 3] = 'b'
        expect(king.hostile_neg_diag?(col - 1, row - 1)).to eq(true)
        expect(king.l_d_diag_invalid?(row, col)).to eq(true)
      end
    end

    context 'when a bishop is blocking the down left diag  of a white king' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row][col - 3] = 'b'
        expect(king.hostile_neg_diag?(col - 1, row - 1)).to eq(false)
      end
    end

    context 'when an bishop is blocking the up right diag of a white king' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns true' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row - 1][col + 3] = 'b'
        expect(king.hostile_neg_diag?(col + 1, row + 1)).to eq(true)
      end
    end

    context 'when a bishop is not blocking the up right diag of a white king' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row][col + 3] = 'b'
        expect(king.hostile_neg_diag?(col + 1, row + 1)).to eq(false)
      end
    end

    context 'when a bishop is blocking the down left diag of a white king' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns true' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 1][col - 3] = 'b'
        expect(king.hostile_neg_diag?(col - 1, row - 1)).to eq(true)
      end
    end

    context 'when a bishop is blocking the down left diag  of a white king' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row][col - 3] = 'b'
        expect(king.hostile_neg_diag?(col - 1, row - 1)).to eq(false)
      end
    end
  end

  describe '#hostile_pos_diag?' do
    context 'when a bishop is blocking the up left diag' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns true' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row - 1][col - 3] = 'b'
        expect(king.hostile_pos_diag?(col - 1, row + 1)).to eq(true)
        expect(king.l_u_diag_invalid?(row, col)).to eq(true)
      end
    end

    context 'when a bishop is not blocking the down right diag' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 1][col + 3] = 'B'
        expect(king.hostile_pos_diag?(col + 1, row - 1)).to eq(false)
      end
    end

    context 'when a bishop is blocking the down right diag' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns true' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 1][col + 3] = 'b'
        expect(king.hostile_pos_diag?(col + 1, row - 1)).to eq(true)
        expect(king.r_d_diag_invalid?(row, col)).to eq(true)
      end
    end

    context 'when the up left diag is not blocked' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row][col - 2] = 'Q'
        expect(king.hostile_pos_diag?(col - 1, row + 1)).to eq(false)
      end
    end
  end

  describe '#hostile_b_pawns?' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
    subject(:king) { described_class.new(board) }

    it 'returns the correct value' do
      row = 0
      col = 4
      board.data[row][col] = 'K'
      board.data[row + 2][col] = 'p'
      board.data[row + 2][col + 1] = 'p'
      expect(king.hostile_b_pawns?(col - 1, row + 1)).to eq(true)
      expect(king.hostile_b_pawns?(col - 1, row)).to eq(false)
    end
  end

  describe '#hostile_w_pawns?' do
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
      board.data[row - 2][col] = 'P'
      board.data[row - 2][col + 1] = 'P'
      expect(king.hostile_w_pawns?(col - 1, row - 1)).to eq(true)
      expect(king.hostile_w_pawns?(col - 1, row)).to eq(false)
    end
  end

  describe '#hostile_king?' do
    context 'when a white king has an enemy king nearby' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns the correct value' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 2][col] = 'k'
        expect(king.hostile_king?(col - 1, row + 1)).to eq(true)
        expect(king.hostile_king?(col, row + 1)).to eq(true)
        expect(king.hostile_king?(col - 1, row + 1)).to eq(true)
        expect(king.hostile_king?(col - 1, row)).to eq(false)
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
        expect(king.hostile_king?(col - 1, row - 1)).to eq(true)
        expect(king.hostile_king?(col, row - 1)).to eq(true)
        expect(king.hostile_king?(col + 1, row - 1)).to eq(true)
        expect(king.hostile_king?(col - 1, row)).to eq(false)
      end
    end
  end

  describe '#hostile_knights?' do
    context 'when a white king has an enemy knight nearby' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns the correct value' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 2][col] = 'n'
        expect(king.hostile_knights?(col - 1, row)).to eq(true)
        expect(king.hostile_knights?(col + 1, row)).to eq(true)
        expect(king.hostile_knights?(col + 1, row + 1)).to eq(false)
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
        expect(king.hostile_knights?(col - 1, row)).to eq(true)
        expect(king.hostile_knights?(col + 1, row)).to eq(true)
        expect(king.hostile_knights?(col + 1, row - 1)).to eq(false)
      end
    end
  end
end
