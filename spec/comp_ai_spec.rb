# frozen_string_literal: true

require_relative '../lib/comp_ai'

describe CompAI do
  def display_board
    print "#{('a'..'h').to_a} \n"
    board.data.reverse.each do |row|
      puts row.to_s
    end
    print "#{('a'..'h').to_a} \n"
  end

  describe '#comp_activate' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 1) }
    subject(:comp_ai) { described_class.new(board) }

    before do
      board.update_turn
      board.update_b_king_check([4, 0])
    end

    it 'moves the rook to block check' do
      row = 7
      col = 4
      board.data[row][col] = 'k'
      board.data[row - 1][col + 3] = 'r'
      board.data[row - 7][col] = 'R'
      # board.data[row - 7][col - 1] = 'b'
      # board.data[row - 7][col + 1] = 'n'
      comp_ai.comp_activate
      display_board
      expect(board.data[row - 1][col]).to eq('r')
    end
  end
end
