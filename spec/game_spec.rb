# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/units/pawn'
require_relative '../lib/units/rook'
require_relative '../lib/units/king'
require_relative '../lib/units/bishop'
require_relative '../lib/units/knight'

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

  describe '#select_unit' do
    context 'when a black rook has no units vertical or horizontal' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:game) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(false)
      end

      it 'displays the correct available moves' do
        row = 6
        col = 7
        board.data[row][col] = 'r'
        b_rook = game.select_unit([col, row], 'r')
        rook_moves = [[0, 1], [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6],
                      [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0]]
        expect(b_rook.moves).to eq(rook_moves)
      end
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

  describe '#create_options' do
    arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { instance_double(Board, data: arr, turn: 0) }
    subject(:game) { described_class.new(board) }

    it 'combines the coords to create grid plot points' do
      moves = [[0, 1], [0, 2]]
      expect(game.create_options([0, 0], moves)).to eq([[0, 1], [0, 2]])
    end
  end

  describe '#move_pieces' do
    context 'when a white king castles right' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:game) { described_class.new(board) }

      it 'displays the correct results' do
        row = 0
        col = 4
        game.board.data[row][col] = 'K'
        game.board.data[row][col + 3] = 'R'
        king = King.new(board)
        game.move_pieces([col, row], [col + 2, row], king)
        expect(game.board.data[row][col + 2]).to eq('K')
        expect(game.board.data[row][col + 1]).to eq('R')
      end
    end
  end

  describe '#comp_activate' do
    context 'when a black king is threatened via col' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 1) }
      subject(:comp_ai) { described_class.new(board) }

      before do
        board.update_turn
        board.update_b_king_check([4, 0])
      end

      xit 'moves a piece to block check' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row][col + 1] = 'p'
        board.data[row][col - 1] = 'p'
        board.data[row - 1][col + 1] = 'r'
        board.data[row - 1][col - 1] = 'r'
        board.data[row - 7][col] = 'R'
        # board.data[row - 7][col - 1] = 'b'
        # board.data[row - 7][col + 1] = 'n'
        comp_ai.comp_activate
        expect(board.data[row - 1][col]).to eq('r')
      end
    end

    context 'when a black king is threatened via row' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 1) }
      subject(:comp_ai) { described_class.new(board) }

      before do
        board.update_turn
        board.update_b_king_check([1, 7])
        board.update_b_king_pos([3, 7])
      end

      it 'moves a piece to block check' do
        row = 7
        col = 3
        board.data[row][col] = 'k'
        board.data[row - 1][col] = 'p'
        board.data[row - 1][col + 1] = 'p'
        #board.data[row][col - 3] = 'r'
        board.data[row][col - 2] = 'Q'
        
        # board.data[row - 7][col - 1] = 'b'
        # board.data[row - 7][col + 1] = 'n'
        comp_ai.comp_activate
        display_board
        #expect(board.data[row - 1][col]).to eq('r')
      end
    end
  end
end
