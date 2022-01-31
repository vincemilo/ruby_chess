# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../lib/units/knight'
require_relative '../../lib/board'

describe Knight do
  def display_board
    print "#{('a'..'h').to_a} \n"
    board.data.reverse.each do |row|
      puts row.to_s
    end
    print "#{('a'..'h').to_a} \n"
  end

  describe '#check_1' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr) }
    subject(:knight) { described_class.new(board) }

    context 'when there is an open space or enemy at destination' do
      before do
        allow(board).to receive(:enemy_occupied?).and_return(false)
      end

      it 'has the correct move options' do
        row = 4
        col = 3
        board.data[row][col] = 'N'
        w_knight = knight.check_1(row, col, knight)
        knight_moves = [[2, 1]]
        expect(w_knight.moves).to eq(knight_moves)
      end

      before do
        allow(board).to receive(:enemy_occupied?).and_return(true)
      end

      it 'has the correct move options' do
        row = 1
        col = 1
        board.data[row][col] = 'N'
        board.data[row + 2][col + 1] = 'n'
        w_knight = knight.check_1(row, col, knight)
        knight_moves = [[2, 1]]
        expect(w_knight.moves).to eq(knight_moves)
      end
    end

    context 'when a move would go off the board' do
      before do
        allow(board).to receive(:enemy_occupied?).and_return(false)
      end

      it 'has the correct move options' do
        row = 6
        col = 6
        board.data[row][col] = 'N'
        w_knight = knight.check_1(row, col, knight)
        knight_moves = []
        expect(w_knight.moves).to eq(knight_moves)
      end
    end
  end

  describe '#check_2' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr) }
    subject(:knight) { described_class.new(board) }

    context 'when there is an open space or enemy at destination' do
      before do
        allow(board).to receive(:enemy_occupied?).and_return(false)
      end

      it 'has the correct move options' do
        row = 4
        col = 3
        board.data[row][col] = 'N'
        w_knight = knight.check_2(row, col, knight)
        knight_moves = [[1, 2]]
        expect(w_knight.moves).to eq(knight_moves)
      end

      before do
        allow(board).to receive(:enemy_occupied?).and_return(true)
      end

      it 'has the correct move options' do
        row = 1
        col = 1
        board.data[row][col] = 'N'
        board.data[row + 2][col + 1] = 'n'
        w_knight = knight.check_2(row, col, knight)
        knight_moves = [[1, 2]]
        expect(w_knight.moves).to eq(knight_moves)
      end
    end
  end

  describe '#check_moves' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr) }
    subject(:knight) { described_class.new(board) }

    context 'when a knight is selected' do
      #   before do
      #     allow(board).to receive(:enemy_occupied?).and_return(false)
      #   end

      it 'displays the correct move options' do
        row = 0
        col = 1
        knight.board.data[row][col] = 'N'
        knight.board.data[row + 1][col + 2] = 'P'
        display_board
        w_knight = knight.check_moves(row, col, knight)
        knight_moves = [[1, 2]]
        p w_knight.moves
      end
    end
  end
end
