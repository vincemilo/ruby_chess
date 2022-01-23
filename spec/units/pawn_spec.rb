# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../lib/units/pawn'
require_relative '../../lib/board'

describe Pawn do
  def display_board
    print "#{('a'..'h').to_a} \n"
    board.data.reverse.each do |row|
      puts row.to_s
    end
    print "#{('a'..'h').to_a} \n"
  end

  describe '#assign_moves' do
    before do
      allow(board).to receive(:en_passant).and_return(nil)
    end

    context 'when a white pawn is in its starting position
             with no units ahead and no diagonal captures' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(false)
      end

      it 'has 1 move or 2 move ahead options' do
        start_pos = [1, 1]
        w_pawn = pawn.assign_moves(start_pos, pawn)
        expect(w_pawn.moves).to eq [[0, 1], [0, 2]]
      end
    end

    context 'when a white pawn is in its starting position
             with no units ahead and has two diagonal captures' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(true)
        row = 3
        col = 2
        pawn.board.data[col][row] = 'p'
        pawn.board.data[col][row - 2] = 'p'
      end

      it 'has all move options' do
        start_pos = [2, 1]
        w_pawn = pawn.assign_moves(start_pos, pawn)
        expect(w_pawn.moves).to eq [[0, 1], [0, 2], [1, 1], [-1, 1]]
      end
    end

    context 'when a white pawn is two spaces in front and no diagonal
             captures available' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(false)
        row = 3
        col = 1
        pawn.board.data[row][col] = 'p'
      end

      it 'should have one move ahead' do
        start_pos = [1, 1]
        w_pawn = pawn.assign_moves(start_pos, pawn)
        expect(w_pawn.moves).to eq [[0, 1]]
      end
    end

    context 'when a white pawn is one space in front and no diagonal
             captures available' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(false)
        row = 1
        col = 2
        pawn.board.data[col][row] = 'p'
      end

      it 'should have no legal moves' do
        start_pos = [1, 1]
        w_pawn = pawn.assign_moves(start_pos, pawn)
        expect(w_pawn.moves).to eq []
      end
    end

    context 'when a white pawn is one space in front but pawn has diagonal
             captures available' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(true)
        row = 1
        col = 2
        pawn.board.data[col][row] = 'p'
        pawn.board.data[col][row + 1] = 'p'
        pawn.board.data[col][row - 1] = 'p'
      end

      it 'should have diagonal moves' do
        start_pos = [1, 1]
        w_pawn = pawn.assign_moves(start_pos, pawn)
        expect(w_pawn.moves).to eq [[1, 1], [-1, 1]]
      end
    end

    context 'when a black pawn is in its starting position
             with no units ahead and no diagonal captures' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(false)
      end

      it 'has 1 move or 2 move ahead options' do
        start_pos = [1, 6]
        b_pawn = pawn.assign_moves(start_pos, pawn)
        expect(b_pawn.moves).to eq [[0, -1], [0, -2]]
      end
    end

    context 'when a black pawn is in its starting position
             with no units ahead and has two diagonal captures' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(true)
        row = 3
        col = 5
        pawn.board.data[col][row] = 'P'
        pawn.board.data[col][row - 2] = 'P'
      end

      it 'has all move options' do
        start_pos = [2, 6]
        b_pawn = pawn.assign_moves(start_pos, pawn)
        expect(b_pawn.moves).to eq [[0, -1], [0, -2], [-1, -1], [1, -1]]
      end
    end

    context 'when a white pawn is two spaces in front and no diagonal
             captures available' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(false)
        row = 1
        col = 4
        pawn.board.data[col][row] = 'P'
      end

      it 'should have one move ahead' do
        start_pos = [1, 6]
        b_pawn = pawn.assign_moves(start_pos, pawn)
        expect(b_pawn.moves).to eq [[0, -1]]
      end
    end

    context 'when a white pawn is one space in front and no diagonal
             captures available' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(false)
        row = 1
        col = 5
        pawn.board.data[col][row] = 'P'
      end

      it 'should have no legal moves' do
        start_pos = [1, 6]
        b_pawn = pawn.assign_moves(start_pos, pawn)
        expect(b_pawn.moves).to eq []
      end
    end

    context 'when a white pawn is one space in front but diagonal
             captures are available' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(true)
        row = 1
        col = 5
        pawn.board.data[col][row] = 'P'
        pawn.board.data[col][row + 1] = 'P'
        pawn.board.data[col][row - 1] = 'P'
      end

      it 'should have diagonal moves' do
        start_pos = [1, 6]
        b_pawn = pawn.assign_moves(start_pos, pawn)
        expect(b_pawn.moves).to eq [[-1, -1], [1, -1]]
      end
    end

    context 'when a white pawn is one space in front but a diagonal
             capture is available' do
      arr = Array.new(8) { Array.new(8, '0') }
      # let(:board) { instance_double(Board, data: arr, turn: 1) }
      let(:board) { Board.new }
      subject(:pawn) { described_class.new(board) }

      before do
        board.update_turn
        #allow(board).to receive(:enemy_occupied?).and_return(true)
      end

      it 'should have diagonal moves' do
        row = 4
        col = 4
        pawn.board.data[row][col] = 'p'
        pawn.board.data[row - 1][col] = 'P'
        pawn.board.data[row - 1][col - 1] = 'P'
        display_board
        start_pos = [row, col]
        b_pawn = pawn.assign_moves(start_pos, pawn)
        expect(b_pawn.moves).to eq [[-1, -1]]
      end
    end
  end

  describe '#en_passant?' do
    context 'when a black pawn moves two squares past a white pawn' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:pawn) { described_class.new(board) }

      it 'returns true' do
        allow(board).to receive(:enemy_occupied?).and_return(true)
        row = 1
        col = 4
        pawn.board.data[col][row] = 'p'
        pawn.board.data[col][row + 1] = 'P'
        expect(pawn.en_passant?([row, col])).to be true
      end
    end

    context 'when a white pawn moves two squares past a black pawn' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:pawn) { described_class.new(board) }

      it 'returns true' do
        allow(board).to receive(:enemy_occupied?).and_return(true)
        row = 1
        col = 3
        pawn.board.data[col][row] = 'p'
        pawn.board.data[col][row + 1] = 'p'
        expect(pawn.en_passant?([row, col])).to be true
      end
    end
  end

  describe '#move_pawn' do
    before do
      allow(board).to receive(:update_en_passant)
      allow(pawn).to receive(:move_unit)
    end

    context 'when it\'s black\'s turn and a white pawn
             is right adjacent to their 2 step pawn' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1, en_passant: [1, 4]) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(true)
      end

      it 'stores the coords of the 2 step pawn' do
        row = 1
        col = 6
        pawn.board.data[col][row] = 'p'
        pawn.board.data[col - 2][row + 1] = 'P'
        pawn.move_pawn([row, col], [row, col - 2])
        expect(pawn.board.en_passant).to eq [row, col - 2]
      end
    end

    context 'when it\'s black\'s turn and a white pawn
             is left adjacent to their 2 step pawn' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1, en_passant: [1, 4]) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(true)
      end

      it 'stores the coords of the 2 step pawn' do
        row = 1
        col = 6
        pawn.board.data[col][row] = 'p'
        pawn.board.data[col - 2][row - 1] = 'P'
        pawn.move_pawn([row, col], [row, col - 2])
        expect(pawn.board.en_passant).to eq [row, col - 2]
      end
    end

    context 'when it\'s white\'s turn and a black pawn
             is right adjacent to their 2 step pawn' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0, en_passant: [1, 3]) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(true)
      end

      it 'stores the coords on the right side of the 2 step pawn' do
        row = 1
        col = 1
        pawn.board.data[col][row] = 'P'
        pawn.board.data[col + 2][row + 1] = 'p'
        pawn.move_pawn([row, col], [row, col + 2])
        expect(pawn.board.en_passant).to eq [1, 3]
      end
    end

    context 'when it\'s white\'s turn and one pawn
             is left adjacent to a 2 step pawn' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0, en_passant: [1, 3]) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:enemy_occupied?).and_return(true)
      end

      it 'stores the coords on the left side of the 2 step pawn' do
        row = 1
        col = 1
        pawn.board.data[col][row] = 'P'
        pawn.board.data[col + 2][row - 1] = 'p'
        pawn.move_pawn([row, col], [row, col + 2])
        expect(pawn.board.en_passant).to eq [1, 3]
      end
    end
  end

  describe '#assign_en_passant' do
    context 'when it\'s white\'s turn and there is a valid en_passant
             target on the left' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0, en_passant: [0, 4]) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:update_en_passant)
        allow(pawn).to receive(:get_x_factor).and_return(-1)
      end

      it 'assigns the correct number of moves' do
        row = 1
        col = 4
        pawn.board.data[col][row] = 'P'
        pawn.board.data[col][row - 1] = 'p'
        w_pawn = pawn.assign_en_passant([row, col], pawn)
        expect(w_pawn.moves).to eq [[-1, 1]]
      end
    end

    context 'when it\'s white\'s turn and there is a valid en_passant
             target on the right' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0, en_passant: [2, 4]) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:update_en_passant)
        allow(pawn).to receive(:get_x_factor).and_return(1)
      end

      it 'assigns the correct number of moves' do
        row = 1
        col = 4
        pawn.board.data[col][row] = 'P'
        pawn.board.data[col][row + 1] = 'p'
        w_pawn = pawn.assign_en_passant([1, 4], pawn)
        expect(w_pawn.moves).to eq [[1, 1]]
      end
    end

    context 'when it\'s black\'s turn and there is a valid en_passant
             target on the left' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1, en_passant: [0, 3]) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:update_en_passant)
        allow(pawn).to receive(:get_x_factor).and_return(1)
      end

      it 'assigns the correct number of moves' do
        row = 1
        col = 3
        pawn.board.data[col][row] = 'p'
        pawn.board.data[col][row - 1] = 'P'
        b_pawn = pawn.assign_en_passant([1, 3], pawn)
        b_pawn.moves.each do |set|
          set.map! { |move| move * -1 }
        end
        expect(b_pawn.moves).to eq [[-1, -1]]
      end
    end

    context 'when it\'s black\'s turn and there is a valid en_passant
             target on the right' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1, en_passant: [2, 3]) }
      subject(:pawn) { described_class.new(board) }

      before do
        allow(board).to receive(:update_en_passant)
        allow(pawn).to receive(:get_x_factor).and_return(-1)
      end

      it 'assigns the correct number of moves' do
        row = 1
        col = 3
        pawn.board.data[col][row] = 'p'
        pawn.board.data[col][row + 1] = 'P'
        b_pawn = pawn.assign_en_passant([row, col], pawn)
        b_pawn.moves.each do |set|
          set.map! { |move| move * -1 }
        end
        expect(b_pawn.moves).to eq [[1, -1]]
      end
    end
  end

  describe '#promote?' do
    context 'when a white pawn reaches the last row' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 0) }
      subject(:pawn) { described_class.new(board) }

      it 'returns true' do
        row = 1
        col = 7
        pawn.board.data[col][row] = 'P'
        expect(pawn.promote?([row, col])).to be true
      end
    end

    context 'when a black pawn reaches the last row' do
      arr = Array.new(8) { Array.new(8, '0') }
      let(:board) { instance_double(Board, data: arr, turn: 1) }
      subject(:pawn) { described_class.new(board) }

      it 'returns true' do
        row = 1
        col = 0
        pawn.board.data[col][row] = 'p'
        expect(pawn.promote?([row, col])).to be true
      end
    end
  end
end
