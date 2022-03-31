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

  describe '#castle' do
    context 'when a white king castles right' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      before do
        allow(board).to receive(:update_w_rook)
      end

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

      before do
        allow(board).to receive(:update_w_rook)
      end

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

      before do
        allow(board).to receive(:update_b_rook)
      end

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
      before do
        allow(board).to receive(:update_b_rook)
      end

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

  describe '#hostile_squares?' do
    context 'when a white king is protected to castle right' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 1][col + 1] = 'P'
        board.data[row + 7][col - 1] = 'k'
        board.data[row + 7][col + 1] = 'r'
        board.data[row][col + 3] = 'R'
        expect(king.hostile_squares?(col + 1, row)).to eq(false)
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
        expect(king.w_l_castle?).to eq(true)
      end
    end
  end

  describe '#b_r_castle?' do
    context 'when a black king castling right would put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 7][col + 1] = 'R'
        board.data[row][col + 3] = 'r'
        expect(king.b_r_castle?).to eq(false)
      end
    end

    context 'when a black king castling right would put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 7][col + 2] = 'R'
        board.data[row][col + 3] = 'r'
        expect(king.b_r_castle?).to eq(false)
      end
    end

    context 'when a black king castling right would put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 2][col - 1] = 'B'
        board.data[row][col + 3] = 'r'
        expect(king.b_r_castle?).to eq(false)
      end
    end

    context 'when a black king castling right would put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 2][col + 3] = 'Q'
        board.data[row][col + 3] = 'r'
        expect(king.b_r_castle?).to eq(false)
      end
    end

    context 'when a black king castling right would not put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 7][col + 3] = 'R'
        board.data[row][col + 3] = 'r'
        expect(king.b_r_castle?).to eq(true)
      end
    end
  end

  describe '#b_l_castle?' do
    context 'when a black king castling left would put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 7][col - 1] = 'R'
        board.data[row][col - 4] = 'r'
        expect(king.b_l_castle?).to eq(false)
      end
    end

    context 'when a black king castling left would put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 7][col - 2] = 'R'
        board.data[row][col - 4] = 'r'
        expect(king.b_l_castle?).to eq(false)
      end
    end

    context 'when a black king castling left would put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 2][col] = 'B'
        board.data[row][col - 4] = 'r'
        expect(king.b_l_castle?).to eq(false)
      end
    end

    context 'when a black king castling left would put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 2][col - 3] = 'Q'
        board.data[row][col - 4] = 'r'
        expect(king.b_l_castle?).to eq(false)
      end
    end

    context 'when a black king castling left would not put it in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:king) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 7][col - 3] = 'R'
        board.data[row][col - 4] = 'r'
        expect(king.b_r_castle?).to eq(true)
      end
    end
  end

  describe '#assign_castle_moves' do
    context 'when a white king castles right' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
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
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 1) }
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
end
