# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/units/pawn'
require_relative '../lib/units/rook'

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

  describe '#b_king_check?' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } #{ instance_double(Board, data: arr, turn: 0) }
    subject(:game) { described_class.new(board) }

    it 'displays true if the black king is in check' do
      row = 7
      col = 4
      board.data[row][col] = 'k'
      board.data[row][col + 3] = 'r'
      board.data[row - 7][col] = 'R'
      board.data[row - 7][col - 1] = 'b'
      board.data[row - 7][col + 1] = 'n'
      rook = Rook.new(board)
      expect(game.b_king_check?([col, row - 7], rook)).to eq(true)
    end
  end

  describe '#b_activate' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } #{ instance_double(Board, data: arr, turn: 0) }
    subject(:game) { described_class.new(board) }

    before do
      board.update_turn
      board.instance_variable_set(:@b_king_check,
                                  { check: 1, king_pos: [4, 7], attk_pos: [4, 0] })
    end

    it 'only allows moves that take the black king out of check' do
      row = 7
      col = 4
      board.data[row][col] = 'k'
      board.data[row - 1][col + 3] = 'r'
      board.data[row - 7][col] = 'R'
      board.data[row - 7][col - 1] = 'b'
      board.data[row - 7][col + 1] = 'n'
      display_board
      game.b_activate
      

      # expect(game.b_king_check?([col, row - 7], rook)).to eq(true)
    end
  end

  describe '#b_remove?' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } #{ instance_double(Board, data: arr, turn: 0) }
    subject(:game) { described_class.new(board) }

    before do
      board.instance_variable_set(:@b_king_check, [1, [4, 0], 'R'])
    end

    xit 'only allows moves that take the black king out of check' do
      row = 7
      col = 4
      board.data[row][col] = 'k'
      board.data[row][col + 3] = 'r'
      board.data[row - 7][col] = 'R'
      board.data[row - 7][col - 1] = 'b'
      board.data[row - 7][col + 1] = 'n'
      rook = Rook.new(board)
      display_board
      game.b_remove

      # expect(game.b_king_check?([col, row - 7], rook)).to eq(true)
    end
  end

  describe '#attack_direction' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } #{ instance_double(Board, data: arr, turn: 0) }
    subject(:game) { described_class.new(board) }

    it 'displays the squares that need to be moved into to prevent check' do
      row = 7
      col = 4
      board.data[row][col] = 'k'
      board.data[row][col + 3] = 'r'
      board.data[row - 7][col] = 'R'
      board.data[row - 7][col - 1] = 'b'
      board.data[row - 7][col + 1] = 'n'
      block_moves = [[4, 0], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6]]
      expect(game.attack_direction([col, row], [col, row - 7])).to eq(block_moves)
    end
  end
end
