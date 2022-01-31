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
    context 'when a king is selected' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr) }
      subject(:king) { described_class.new(board) }

      # before do
      #     allow(board).to receive(:enemy_occupied?).and_return(false)
      #   end
      it 'assigns the correct moves' do
        row = 4
        col = 3
        board.data[row][col] = 'K'
        board.data[row + 1][col + 1] = 'P'
        board.data[row - 1][col + 1] = 'b'
        board.data[row][col + 1] = 'n'
        board.data[row][col - 1] = 'R'
        board.data[row + 1][col] = 'n'
        board.data[row - 1][col] = 'R'
        w_king = king.assign_moves([col, row], king)
        king_moves = [[1, -1], [-1, -1], [-1, 1], [1, 0], [0, 1], [0, -1]]
        expect(w_king.moves).to eq(king_moves)
      end
    end
  end
end