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

  describe '#b_king_check?' do
    arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { instance_double(Board, data: arr, turn: 1) }
    subject(:game) { described_class.new(board) }

    before do
      allow(board).to receive(:update_b_king_pos)
      board.instance_variable_set(:@b_king_check,
                                  { check: 1, king_pos: [4, 7], attk_pos: [4, 0] })
    end

    it 'displays true if the black king is in check' do
      row = 7
      col = 4
      board.data[row][col] = 'k'
      board.data[row][col + 3] = 'r'
      board.data[row - 7][col] = 'R'
      board.data[row - 7][col - 1] = 'b'
      board.data[row - 7][col + 1] = 'n'
      expect(game.b_king_check?(row, col)).to eq(true)
    end
  end

  describe '#select_unit_check' do
    context 'when a black king is in check but has moves' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 1) }
      subject(:game) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'returns the correct values' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row][col - 1] = 'q'
        board.data[row][col + 1] = 'b'
        board.data[row][col + 3] = 'r'
        board.data[row - 1][col - 4] = 'r'
        board.data[row - 7][col] = 'R'
        board.update_b_king_check([col, row - 7])
        expect(game.select_unit_check([col, row], 'k').moves).to eq([[1, -1], [-1, -1]])
        expect(game.select_unit_check([col + 3, row], 'r').moves).to eq([])
        expect(game.select_unit_check([col - 4, row - 1], 'r').moves).to eq([[4, 0]])
        expect(game.select_unit_check([col - 1, row], 'q').moves).to eq([[1, -1]])
        expect(game.select_unit_check([col + 1, row], 'b').moves).to eq([[-1, -1]])
      end
    end
  end

  describe '#activation' do
    context 'when a black king is put in check but has no units to defend it' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 1) }
      subject(:game) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'displays the correct results' do
        row = 5
        col = 6
        board.data[row][col] = 'k'
        board.data[row][col + 1] = 'n'
        board.data[row][col - 2] = 'Q'
        board.data[row + 2][col + 1] = 'r'
        board.data[row + 2][col - 6] = 'r'
        board.update_b_king_pos([col, row])
        board.update_b_king_check([col - 2, row])
        pieces = game.activation(1)
        activate = {}
        pieces.each { |piece| activate[piece.class] = piece.moves }
        moves = { King => [[1, 1], [1, -1], [0, 1], [0, -1]], Knight => [], Rook => [] }
        expect(activate).to eq(moves)
      end
    end

    context 'when a white king can escape check via row with units to defend it or via capture' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 1) }
      subject(:game) { described_class.new(board) }

      it 'displays the correct results' do
        row = 3
        col = 4
        board.data[row][col] = 'K'
        board.data[row - 2][col + 1] = 'Q'
        board.data[row + 1][col + 1] = 'r'
        board.data[row][col + 2] = 'r'
        board.data[row][col + 3] = 'R'
        board.update_w_king_pos([col, row])
        board.update_w_king_check([col + 2, row])
        pieces = game.activation(0)
        activate = {}
        pieces.each { |piece| activate[piece.class] = piece.moves }
        moves = { Queen => [[0, 2]], King => [[1, 1], [-1, -1], [0, -1]], Rook => [[-1, 0]] }
        expect(activate).to eq(moves)
      end
    end
  end

  describe '#get_moves' do
    context 'a black king has several units to defend it and can move away' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 1) }
      subject(:game) { described_class.new(board) }

      before do
        board.update_turn
        allow(board).to receive(:b_king_check).and_return({ check: 1,
                                                            king_pos: [7, 7],
                                                            attk_pos: [0, 7] })
      end

      it 'a black king is checkmated' do
        row = 7
        col = 7
        board.data[row][col] = 'k'
        board.data[row - 1][col - 1] = 'p'
        board.data[row - 1][col] = 'r'
        board.data[row - 7][col - 1] = 'R'
        board.data[row][col - 7] = 'R'
        units = game.activation(1)
        expect(game.get_moves(units)).to eq([])
      end
    end
  end

  describe 'insfuff_mat?' do
    context 'when there are just two kings left' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:game) { described_class.new(board) }

      it 'returns true' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 7][col] = 'k'
        display_board
        arr = []
        16.times { arr << '♟' }
        board.update_capture(0, arr)
        expect(game.insuff_mat?).to eq(true)
      end
    end

    context 'when there are just two kings left on opp sides' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:game) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'returns true' do
        row = 7
        col = 4
        board.data[row][col] = 'K'
        board.data[row - 7][col] = 'k'
        arr = []
        16.times { arr << '♟' }
        board.update_capture(0, arr)
        expect(game.insuff_mat?).to eq(true)
      end
    end

    context 'when there are just two kings and a knight or bishop left' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:game) { described_class.new(board) }

      it 'returns true' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 7][col] = 'k'
        board.data[row + 5][col] = 'n'
        arr = []
        16.times { arr << '♟' }
        board.update_capture(0, arr)
        expect(game.insuff_mat?).to eq(true)
      end
    end
  end

  describe '#col_attk' do
    context 'when a white king is threated by an enemy rook' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:game) { described_class.new(board) }

      it 'displays the squares that need to be moved into to prevent check' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 7][col] = 'r'
        block_moves = [[4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6], [4, 7]]
        expect(game.col_attk([col, row], [col, row + 7])).to eq(block_moves)
      end
    end

    context 'when a white king is threated by an enemy rook' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:game) { described_class.new(board) }

      it 'displays the squares that need to be moved into to prevent check' do
        row = 7
        col = 4
        board.data[row][col] = 'K'
        board.data[row - 7][col] = 'r'
        block_moves = [[4, 0], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6]]
        expect(game.col_attk([col, row], [col, row - 7])).to eq(block_moves)
      end
    end

    context 'when a black king is threated by an enemy rook' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
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
  end

  describe '#row_attk' do
    context 'when a white king is threatened by an enemy rook' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:game) { described_class.new(board) }

      it 'displays the squares that need to be moved into to prevent check' do
        row = 2
        col = 3
        board.data[row][col] = 'K'
        board.data[row][col + 3] = 'r'
        block_moves = [[4, 2], [5, 2], [6, 2]]
        expect(game.row_attk([col, row], [col + 3, row])).to eq(block_moves)
      end
    end

    context 'when a black king is threatened by an enemy rook' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
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
  end

  describe '#r_pos_diag' do
    arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { instance_double(Board, data: arr, turn: 1) }
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
    arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { instance_double(Board, data: arr, turn: 1) }
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
    arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { instance_double(Board, data: arr, turn: 0) }
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
    arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { instance_double(Board, data: arr, turn: 0) }
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

  describe '#activate' do
    arr = Array.new(8) { Array.new(8, '0') }
    let(:board) { instance_double(Board, data: arr, turn: 0) }
    subject(:game) { described_class.new(board) }

    it 'displays a hash of the units that match the chars given' do
      row = 0
      col = 4
      board.data[row][col] = 'K'
      board.data[row + 4][col - 4] = 'b'
      expect(game.activate(['K'])).to eq({ [0, 4] => 'K' })
      expect(game.activate(['b'])).to eq({ [4, 0] => 'b' })
    end
  end

  describe '#block_check' do
    context 'a black king has a rook to defend it' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:game) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).with('0').and_return(false)
        allow(board).to receive(:enemy_occupied?).with(nil).and_return(false)
      end

      it 'only returns moves that take the black king out of check' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 1][col + 3] = 'r'
        board.data[row - 7][col] = 'R'
        b_rook = Rook.new(board)
        b_rook.assign_moves([col + 3, row - 1], b_rook)
        piece = [b_rook]
        b_king_check_data = { check: 1, king_pos: [col, row],
                              attk_pos: [col, row - 7] }
        units = game.block_check(piece, b_king_check_data)
        moves = units[0].moves
        expect(moves).to eq([[-3, 0]])
      end
    end

    context 'when a white king is not checkmated' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 0) }
      subject(:game) { described_class.new(board) }

      it 'returns the correct values' do
        row = 0
        col = 6
        board.data[row][col] = 'K'
        board.data[row][col - 1] = 'R'
        board.data[row + 6][col + 1] = 'r'
        board.data[row + 7][col] = 'r'
        king = King.new(board)
        king.assign_moves([col, row], king)
        w_king_check_data = { check: 1, king_pos: [col, row],
                              attk_pos: [col, row + 7] }
        moves = game.block_check([king], w_king_check_data)[0].moves
        expect(moves).to eq([[-1, 1]])
      end
    end

    context 'when a white king is checkmated' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:game) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).with('R').and_return(false)
      end

      it 'returns the correct values' do
        row = 0
        col = 7
        board.data[row][col] = 'K'
        board.data[row][col - 1] = 'R'
        board.data[row + 6][col - 1] = 'r'
        board.data[row + 7][col] = 'r'
        king = King.new(board)
        king.assign_moves([col, row], king)
        w_king_check_data = { check: 1, king_pos: [7, 0], attk_pos: [7, 7] }
        moves = game.block_check([king], w_king_check_data)[0].moves
        expect(moves).to eq([])
      end
    end

    context 'when a black king is checked by a knight' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new } # { instance_double(Board, data: arr, turn: 1) }
      subject(:game) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'matches available moves that block check to a king' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row - 2][col + 1] = 'N'
        board.data[row][col - 1] = 'r'
        board.update_b_king_check([col + 1, row - 2])
        check_data = board.b_king_check
        black_pieces = %w[p r n b q k]
        activate = game.activate(black_pieces)
        pieces = game.pieces(activate)
        units = game.block_check(pieces, check_data)
        rook_moves = units[0].moves
        king_moves = units[1].moves
        expect(rook_moves).to eq([])
        expect(king_moves).to eq([[1, -1], [1, 0], [0, -1]])
      end
    end
  end

  describe '#put_into_check?' do
    context 'when moving a unit would put a white king into check via col' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new }
      subject(:game) { described_class.new(board) }

      it 'returns the correct value' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 1][col] = 'R'
        board.data[row + 7][col] = 'r'
        rook_start = [col, row + 1]
        rook_end = [col + 1, row + 1]
        rook_end2 = [col, row + 7]
        expect(game.put_into_check?(rook_start, rook_end)).to eq(true)
        expect(game.put_into_check?(rook_start, rook_end2)).to eq(false)
      end
    end

    context 'when moving a unit would put a white king into check via row' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new }
      subject(:game) { described_class.new(board) }

      it 'returns the correct value' do
        row = 0
        col = 6
        board.data[row][col] = 'K'
        board.data[row][col - 1] = 'R'
        board.data[row][col - 6] = 'r'
        rook_start = [col - 1, row]
        rook_end = [col - 1, row + 1]
        rook_end2 = [col - 6, row]
        expect(game.put_into_check?(rook_start, rook_end)).to eq(true)
        expect(game.put_into_check?(rook_start, rook_end2)).to eq(false)
      end
    end

    context 'when moving a unit would put a white king into check via pos diag' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new }
      subject(:game) { described_class.new(board) }

      it 'returns the correct value' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 1][col + 1] = 'P'
        board.data[row + 3][col + 3] = 'b'
        pawn_start = [col + 1, row + 1]
        pawn_end = [col + 1, row + 2]
        expect(game.put_into_check?(pawn_start, pawn_end)).to eq(true)
      end
    end

    context 'when moving a unit would put a white king into check via neg diag' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new }
      subject(:game) { described_class.new(board) }

      it 'returns the correct value' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row + 1][col - 1] = 'P'
        board.data[row + 3][col - 3] = 'q'
        pawn_start = [col - 1, row + 1]
        pawn_end = [col - 1, row + 2]
        expect(game.put_into_check?(pawn_start, pawn_end)).to eq(true)
      end
    end

    context 'when moving a unit would not put a white king into check via neg diag' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new }
      subject(:game) { described_class.new(board) }

      it 'returns the correct value' do
        row = 0
        col = 4
        board.data[row][col] = 'K'
        board.data[row][col - 1] = 'P'
        board.data[row + 3][col - 3] = 'q'
        pawn_start = [col - 1, row]
        pawn_end = [col - 1, row + 1]
        expect(game.put_into_check?(pawn_start, pawn_end)).to eq(false)
      end
    end

    context 'when selecting a unit would not put a black king in check' do
      # arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { Board.new }
      subject(:game) { described_class.new(board) }

      before do
        board.update_turn
      end

      it 'returns the correct value' do
        row = 7
        col = 4
        board.data[row][col] = 'k'
        board.data[row][col + 3] = 'r'
        board.data[row - 7][col + 2] = 'K'
        board.data[row - 7][col + 1] = 'R'
        rook_start = [col + 3, row]
        rook_end = [col + 3, row - 1]
        expect(game.put_into_check?(rook_start, rook_end)).to eq(false)
      end
    end
  end
end
