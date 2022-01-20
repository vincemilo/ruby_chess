# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/units/pawn'

describe Game do
  def display_board
    print "#{('a'..'h').to_a} \n"
    board.data.reverse.each do |row|
      puts row.to_s
    end
    print "#{('a'..'h').to_a} \n"
  end

  describe '#move_translator' do
    subject(:game) { described_class.new }

    before do
      allow(game).to receive(:puts)
      allow(game).to receive(:gets)
    end

    it 'returns the coords for the board' do
      expect(game.move_translator('e4')).to eq([5, 4])
    end
  end

  describe '#display_moves' do
    context 'when a unit is selected' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      let(:pawn) { instance_double(Pawn, moves: [[0, 1], [0, 2]]) }
      subject(:game) { described_class.new(board) }

      before do
        # allow(board).to receive(:get_unit).and_return('P')
        # allow(board).to receive(:en_passant)
        # allow(game).to receive(:get_unit_obj).and_return(pawn)
        # allow(pawn).to receive(:assign_moves)
        allow(board).to receive(:display_board)
      end

      it 'displays the move options' do
        row = 1
        col = 4
        game.board.data[row][col] = 'P'
        game.display_moves([col, row], [[0, 1], [0, 2]])
        expect(game.board.data[row + 1][col]).to eq('1')
        expect(game.board.data[row + 2][col]).to eq('1')
      end
    end
  end
end
