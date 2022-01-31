# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../lib/units/bishop'
require_relative '../../lib/board'

describe Bishop do
  def display_board
    print "#{('a'..'h').to_a} \n"
    board.data.reverse.each do |row|
      puts row.to_s
    end
    print "#{('a'..'h').to_a} \n"
  end

  describe '#check_1' do
    context 'when a bishop has no units right up diagonal' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:bishop) { described_class.new(board) }

      #   before do
      #     allow(board).to receive(:enemy_occupied?).and_return(false)
      #   end

      it 'returns the correct move options' do
        row = 4
        col = 3
        board.data[row][col] = 'B'
        w_bishop = bishop.check_1(row, col, bishop)
        bishop_moves = [[1, 1], [2, 2], [3, 3]]
        expect(w_bishop.moves).to eq(bishop_moves)
      end
    end

    context 'when there is an enemy unit right up diagonal' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:bishop) { described_class.new(board) }

      #   before do
      #     allow(board).to receive(:enemy_occupied?).and_return(false)
      #   end

      it 'returns the correct move options' do
        row = 4
        col = 3
        board.data[row][col] = 'B'
        board.data[row + 2][col + 2] = 'b'
        w_bishop = bishop.check_1(row, col, bishop)
        bishop_moves = [[1, 1], [2, 2]]
        expect(w_bishop.moves).to eq(bishop_moves)
      end
    end
  end

  context 'when there is a friendly unit right up diagonal' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr) }
    subject(:bishop) { described_class.new(board) }

    #   before do
    #     allow(board).to receive(:enemy_occupied?).and_return(false)
    #   end

    it 'returns the correct move options' do
      row = 4
      col = 3
      board.data[row][col] = 'B'
      board.data[row + 2][col + 2] = 'B'
      w_bishop = bishop.check_1(row, col, bishop)
      bishop_moves = [[1, 1]]
      expect(w_bishop.moves).to eq(bishop_moves)
    end
  end

  describe '#check_2' do
    context 'when a bishop has no units right down diagonal' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:bishop) { described_class.new(board) }

      #   before do
      #     allow(board).to receive(:enemy_occupied?).and_return(false)
      #   end

      it 'returns the correct move options' do
        row = 4
        col = 3
        board.data[row][col] = 'B'
        w_bishop = bishop.check_2(row, col, bishop)
        bishop_moves = [[1, -1], [2, -2], [3, -3], [4, -4]]
        expect(w_bishop.moves).to eq(bishop_moves)
      end
    end

    context 'when there is an enemy unit right up diagonal' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:bishop) { described_class.new(board) }

      #   before do
      #     allow(board).to receive(:enemy_occupied?).and_return(false)
      #   end

      it 'returns the correct move options' do
        row = 4
        col = 3
        board.data[row][col] = 'B'
        board.data[row - 2][col + 2] = 'b'
        w_bishop = bishop.check_2(row, col, bishop)
        bishop_moves = [[1, -1], [2, -2]]
        expect(w_bishop.moves).to eq(bishop_moves)
      end
    end
  end

  context 'when there is a friendly unit right up diagonal' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr) }
    subject(:bishop) { described_class.new(board) }

    #   before do
    #     allow(board).to receive(:enemy_occupied?).and_return(false)
    #   end

    it 'returns the correct move options' do
      row = 4
      col = 3
      board.data[row][col] = 'B'
      board.data[row - 2][col + 2] = 'B'
      w_bishop = bishop.check_2(row, col, bishop)
      bishop_moves = [[1, -1]]
      expect(w_bishop.moves).to eq(bishop_moves)
    end
  end

  describe '#assign_moves' do
    context 'when a bishop is selected' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:bishop) { described_class.new(board) }

      # before do
      #     allow(board).to receive(:enemy_occupied?).and_return(false)
      #   end
      it 'assigns the correct moves' do
        row = 4
        col = 3
        board.data[row][col] = 'B'
        board.data[row + 2][col + 2] = 'B'
        board.data[row - 2][col + 2] = 'b'
        w_bishop = bishop.assign_moves([col, row], bishop)
        bishop_moves = [[1, 1], [1, -1], [2, -2], [-1, -1], [-2, -2],
                        [-3, -3], [-1, 1], [-2, 2], [-3, 3]]
        expect(w_bishop.moves).to eq(bishop_moves)
      end
    end
  end
end
