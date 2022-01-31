# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../lib/units/queen'
require_relative '../../lib/board'

describe Queen do
  def display_board
    print "#{('a'..'h').to_a} \n"
    board.data.reverse.each do |row|
      puts row.to_s
    end
    print "#{('a'..'h').to_a} \n"
  end

  describe '#assign_moves' do
    context 'when a queen is selected' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:queen) { described_class.new(board) }

      # before do
      #     allow(board).to receive(:enemy_occupied?).and_return(false)
      #   end
      it 'assigns the correct moves' do
        row = 4
        col = 3
        board.data[row][col] = 'Q'
        board.data[row + 2][col + 2] = 'P'
        board.data[row - 2][col + 2] = 'b'
        board.data[row][col + 3] = 'n'
        board.data[row][col - 2] = 'R'
        board.data[row + 3][col] = 'n'
        board.data[row - 1][col] = 'R'
        w_queen = queen.assign_moves([col, row], queen)
        queen_moves = [[0, 1], [0, 2], [0, 3], [1, 0],
                       [2, 0], [3, 0], [-1, 0], [1, 1],
                       [1, -1], [2, -2], [-1, -1], [-2, -2],
                       [-3, -3], [-1, 1], [-2, 2], [-3, 3]]
        expect(w_queen.moves).to eq(queen_moves)
      end
    end
  end
end
