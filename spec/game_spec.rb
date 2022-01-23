# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

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
      expect(game.move_translator('e2')).to eq([4, 1])
    end
  end

  describe '#display_moves' do
    context 'when a white pawn at the starting line is selected' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:game) { described_class.new(board) }

      before do
        allow(board).to receive(:display_board)
      end

      it 'displays the correct move options' do
        row = 1
        col = 4
        game.board.data[row][col] = 'P'
        game.display_moves([col, row], [[0, 1], [0, 2]])
        expect(game.board.data[row + 1][col]).to eq('0*')
        expect(game.board.data[row + 2][col]).to eq('0*')
      end
    end

    context 'when a white pawn with capture options is selected' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:game) { described_class.new(board) }

      before do
        allow(board).to receive(:display_board)
      end

      it 'displays the correct move options' do
        row = 3
        col = 4
        game.board.data[row][col] = 'P'
        game.board.data[row + 1][col + 1] = 'p'
        game.display_moves([col, row], [[0, 1], [1, 1]])
        expect(game.board.data[row + 1][col + 1]).to eq('p*')
        expect(game.board.data[row + 1][col]).to eq('0*')
      end
    end

    context 'when a black pawn with capture options is selected' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:game) { described_class.new(board) }

      before do
        allow(board).to receive(:display_board)
      end

      it 'displays the correct move options' do
        row = 4
        col = 4
        game.board.data[row][col] = 'p'
        game.board.data[row - 1][col - 1] = 'P'
        game.display_moves([col, row], [[0, -1], [-1, -1]])
        expect(game.board.data[row - 1][col - 1]).to eq('P*')
        expect(game.board.data[row - 1][col]).to eq('0*')
      end
    end
  end
end
