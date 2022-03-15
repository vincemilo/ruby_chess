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

  describe '#w_r_castle?' do
    context 'when a white king castling right would put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 7][col + 1] = 'r'
        board.data[row][col + 3] = 'R'
        expect(king.w_r_castle?).to eq(false)
      end
    end

    context 'when a white king castling right would put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 7][col + 2] = 'r'
        board.data[row][col + 3] = 'R'
        expect(king.w_r_castle?).to eq(false)
      end
    end

    context 'when a white king castling right would put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 2][col - 1] = 'b'
        board.data[row][col + 3] = 'R'
        expect(king.w_r_castle?).to eq(false)
      end
    end

    context 'when a white king castling right would put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 2][col + 3] = 'q'
        board.data[row][col + 3] = 'R'
        expect(king.w_r_castle?).to eq(false)
      end
    end

    context 'when a white king castling right would not put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 7][col + 3] = 'r'
        board.data[row][col + 3] = 'R'
        expect(king.w_r_castle?).to eq(true)
      end
    end
  end

  describe '#w_l_castle?' do
    context 'when a white king castling left would put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 7][col - 1] = 'r'
        board.data[row][col - 4] = 'R'
        expect(king.w_l_castle?).to eq(false)
      end
    end

    context 'when a white king castling left would put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 7][col - 2] = 'r'
        board.data[row][col - 4] = 'R'
        expect(king.w_l_castle?).to eq(false)
      end
    end

    context 'when a white king castling left would put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 2][col] = 'b'
        board.data[row][col - 4] = 'R'
        expect(king.w_l_castle?).to eq(false)
      end
    end

    context 'when a white king castling left would put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 2][col - 3] = 'q'
        board.data[row][col - 4] = 'R'
        expect(king.w_l_castle?).to eq(false)
      end
    end

    context 'when a white king castling left would not put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 7][col - 3] = 'r'
        board.data[row][col - 4] = 'R'
        display_board
        expect(king.w_l_castle?).to eq(true)
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
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new} # { instance_double(Board, data: arr, turn: 0) }
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
    context 'when a bishop is blocking the up right diag' do
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

    context 'when a bishop is not blocking the up right diag' do
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

    context 'when a bishop is blocking the down left diag' do
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

    context 'when a bishop is blocking the down left diag' do
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
    context 'when a bishop is blocking the up right diag' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns true' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row - 1][col - 3] = 'b'
        expect(king.hostile_pos_diag?(col - 1, row + 1)).to eq(true)
      end
    end

    context 'when a bishop is not blocking the up right diag' do
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

    context 'when a bishop is blocking the down left diag' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns true' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 1][col + 3] = 'b'
        expect(king.hostile_pos_diag?(col + 1, row - 1)).to eq(true)
      end
    end

    context 'when the down left diag is not blocked' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'returns false' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row][col - 3] = 'Q'
        expect(king.hostile_neg_diag?(col - 1, row - 1)).to eq(false)
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
