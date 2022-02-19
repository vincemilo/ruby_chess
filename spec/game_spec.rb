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

  describe '#king_check?' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
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
      expect(game.king_check?([col, row - 7], rook, 'k')).to eq(true)
    end
  end

  describe '#activation' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
    subject(:game) { described_class.new(board) }

    before do
      board.update_turn
      board.instance_variable_set(:@b_king_check,
                                  { check: 1, king_pos: [4, 7], attk_pos: [4, 0] })
    end

    it 'only returns moves that take the black king out of check' do
      row = 7
      col = 4
      board.data[row][col] = 'k'
      board.data[row - 1][col + 3] = 'r'
      board.data[row - 7][col] = 'R'
      board.data[row - 7][col - 1] = 'b'
      board.data[row - 7][col + 1] = 'n'
      units = game.activation(1)
      unit_moves = {}
      units.each { |unit| unit_moves[unit.class] = unit.moves }
      expect(unit_moves).to eq({ Bishop => [[1, 1]],
                                 Knight => [[-1, 2]],
                                 Rook => [[-3, 0]],
                                 King => [[1, -1], [-1, -1], [1, 0], [-1, 0]] })
    end
  end

  describe '#remove?' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
    subject(:game) { described_class.new(board) }

    before do
      board.update_turn
      board.instance_variable_set(:@b_king_check,
                                  { check: 1, king_pos: [4, 7], attk_pos: [4, 0] })
    end

    it 'only allows selection of unit that take the black king out of check' do
      row = 7
      col = 4
      board.data[row][col] = 'k'
      board.data[row - 1][col + 3] = 'r'
      board.data[row - 7][col] = 'R'
      board.data[row - 7][col - 1] = 'b'
      board.data[row - 7][col + 1] = 'n'
      # #remove_check leads here, must be a piece
      friendly_rook = [col + 3, row - 1]
      expect(game.remove?(friendly_rook, 1)).to eq(true)
    end
  end

  describe '#col_attk' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
    subject(:game) { described_class.new(board) }

    it 'displays the squares that need to be moved into to prevent check' do
      row = 7
      col = 4
      board.data[row][col] = 'k'
      board.data[row - 7][col] = 'R'
      block_moves = [[4, 0], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6]]
      expect(game.col_attk([col, row], [col, row - 7])).to eq(block_moves)
    end
  end

  describe '#row_attk' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
    subject(:game) { described_class.new(board) }

    it 'displays the squares that need to be moved into to prevent check' do
      row = 7
      col = 4
      board.data[row][col] = 'k'
      board.data[row][col - 4] = 'R'
      block_moves = [[0, 7], [1, 7], [2, 7], [3, 7]]
      expect(game.row_attk([col, row], [col - 4, row])).to eq(block_moves)
    end
  end

  describe '#r_pos_diag' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
    subject(:game) { described_class.new(board) }

    it 'displays the squares that need to be moved into to prevent check' do
      row = 7
      col = 4
      board.data[row][col] = 'k'
      board.data[row - 4][col - 4] = 'B'
      block_moves = [[0, 3], [1, 4], [2, 5], [3, 6]]
      expect(game.r_pos_diag([col, row], [col - 4, row - 4])).to eq(block_moves)
    end
  end

  describe '#l_pos_diag' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
    subject(:game) { described_class.new(board) }

    it 'displays the squares that need to be moved into to prevent check' do
      row = 7
      col = 4
      board.data[row][col] = 'k'
      board.data[row - 3][col + 3] = 'B'
      block_moves = [[5, 6], [6, 5], [7, 4]]
      expect(game.l_pos_diag([col, row], [col + 3, row - 3])).to eq(block_moves)
    end
  end

  describe '#l_neg_diag' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
    subject(:game) { described_class.new(board) }

    it 'displays the squares that need to be moved into to prevent check' do
      row = 0
      col = 4
      board.data[row][col] = 'K'
      board.data[row + 3][col + 3] = 'b'
      block_moves = [[5, 1], [6, 2], [7, 3]]
      expect(game.l_neg_diag([col, row], [col + 3, row + 3])).to eq(block_moves)
    end
  end

  describe '#r_neg_diag' do
    # arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
    subject(:game) { described_class.new(board) }

    it 'displays the squares that need to be moved into to prevent check' do
      row = 0
      col = 4
      board.data[row][col] = 'K'
      board.data[row + 4][col - 4] = 'b'
      block_moves = [[0, 4], [1, 3], [2, 2], [3, 1]]
      expect(game.r_neg_diag([col, row], [col - 4, row + 4])).to eq(block_moves)
    end
  end
end
