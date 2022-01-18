# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../lib/units/pawn'

describe Pawn do
  subject(:pawn) { described_class.new }

  describe '#assign_moves' do
    context 'when a white pawn is in its starting position
             with no units ahead and no diagonal captures' do
      it 'has 1 move or 2 move ahead options' do
        start_pos = [1, 1]
        w_pawn = pawn.assign_moves(start_pos, pawn)
        expect(w_pawn.moves).to eq [[0, 1], [0, 2]]
      end
    end

    context 'when a white pawn is in its starting position
             with no units ahead and has two diagonal captures' do
      before do
        x = 3
        y = 2
        pawn.board.data[y][x] = 'p'
        pawn.board.data[y][x - 2] = 'p'
      end

      it 'has all move options' do
        start_pos = [2, 1]
        w_pawn = pawn.assign_moves(start_pos, pawn)
        expect(w_pawn.moves).to eq [[0, 1], [0, 2], [1, 1], [-1, 1]]
      end
    end

    context 'when a white pawn is two spaces in front and no diagonal
             captures available' do
      before do
        x = 1
        y = 3
        pawn.board.data[y][x] = 'p'
      end

      it 'should have one move ahead' do
        start_pos = [1, 1]
        w_pawn = pawn.assign_moves(start_pos, pawn)
        expect(w_pawn.moves).to eq [[0, 1]]
      end
    end

    context 'when a white pawn is one space in front and no diagonal
             captures available' do
      before do
        x = 1
        y = 2
        pawn.board.data[y][x] = 'p'
      end

      it 'should have no legal moves' do
        start_pos = [1, 1]
        w_pawn = pawn.assign_moves(start_pos, pawn)
        expect(w_pawn.moves).to eq []
      end
    end

    context 'when a white pawn is one space in front but pawn has diagonal
             captures available' do
      before do
        x = 1
        y = 2
        pawn.board.data[y][x] = 'p'
        pawn.board.data[y][x + 1] = 'p'
        pawn.board.data[y][x - 1] = 'p'
      end

      it 'should have diagonal moves' do
        start_pos = [1, 1]
        w_pawn = pawn.assign_moves(start_pos, pawn)
        expect(w_pawn.moves).to eq [[1, 1], [-1, 1]]
      end
    end

    context 'when a black pawn is in its starting position
             with no units ahead and no diagonal captures' do
      before do
        pawn.board.turn = 1
      end

      it 'has 1 move or 2 move ahead options' do
        start_pos = [1, 6]
        b_pawn = pawn.assign_moves(start_pos, pawn)
        expect(b_pawn.moves).to eq [[0, -1], [0, -2]]
      end
    end

    context 'when a black pawn is in its starting position
             with no units ahead and has two diagonal captures' do
      before do
        pawn.board.turn = 1
        x = 3
        y = 5
        pawn.board.data[y][x] = 'P'
        pawn.board.data[y][x - 2] = 'P'
      end

      it 'has all move options' do
        start_pos = [2, 6]
        b_pawn = pawn.assign_moves(start_pos, pawn)
        expect(b_pawn.moves).to eq [[0, -1], [0, -2], [-1, -1], [1, -1]]
      end
    end

    context 'when a black pawn is two spaces in front and no diagonal
             captures available' do
      before do
        pawn.board.turn = 1
        x = 1
        y = 4
        pawn.board.data[y][x] = 'P'
      end

      it 'should have one move ahead' do
        start_pos = [1, 6]
        b_pawn = pawn.assign_moves(start_pos, pawn)
        expect(b_pawn.moves).to eq [[0, -1]]
      end
    end

    context 'when a black pawn is one space in front and no diagonal
             captures available' do
      before do
        pawn.board.turn = 1
        x = 1
        y = 5
        pawn.board.data[y][x] = 'P'
      end

      it 'should have no legal moves' do
        start_pos = [1, 6]
        b_pawn = pawn.assign_moves(start_pos, pawn)
        expect(b_pawn.moves).to eq []
      end
    end

    context 'when a black pawn is one space in front but pawn has diagonal
             captures available' do
      before do
        pawn.board.turn = 1
        x = 1
        y = 5
        pawn.board.data[y][x] = 'P'
        pawn.board.data[y][x + 1] = 'P'
        pawn.board.data[y][x - 1] = 'P'
      end

      it 'should have diagonal moves' do
        start_pos = [1, 6]
        b_pawn = pawn.assign_moves(start_pos, pawn)
        expect(b_pawn.moves).to eq [[-1, -1], [1, -1]]
      end
    end
  end

  describe '#en_passant?' do
    context 'when a black pawn moves two squares past a white pawn' do
      before do
        pawn.board.turn = 1
      end

      it 'returns true' do
        x = 1
        y = 4
        pawn.board.data[y][x] = 'p'
        pawn.board.data[y][x + 1] = 'P'
        expect(pawn.en_passant?([x, y])).to be true
      end
    end

    context 'when a white pawn moves two squares past a black pawn' do
      it 'returns true' do
        x = 1
        y = 3
        pawn.board.data[y][x] = 'p'
        pawn.board.data[y][x + 1] = 'p'
        expect(pawn.en_passant?([x, y])).to be true
      end
    end
  end

  describe '#move_pawn' do
    context 'when it\'s black\'s turn and a white pawn
             is right adjacent to their 2 step pawn' do
      before do
        pawn.board.turn = 1
        x = 1
        y = 6
        pawn.board.data[y][x] = 'p'
        pawn.board.data[y - 2][x + 1] = 'P'
        pawn.move_pawn([x, y], [x, y - 2])
      end

      it 'stores the coords of the 2 step pawn' do
        expect(pawn.board.en_passant).to eq [1, 4]
      end
    end

    context 'when it\'s black\'s turn and a white pawn
             is left adjacent to their 2 step pawn' do
      before do
        pawn.board.turn = 1
        x = 1
        y = 6
        pawn.board.data[y][x] = 'p'
        pawn.board.data[y - 2][x - 1] = 'P'
        pawn.move_pawn([x, y], [x, y - 2])
      end

      it 'stores the coords of the 2 step pawn' do
        expect(pawn.board.en_passant).to eq [1, 4]
      end
    end

    context 'when it\'s white\'s turn and a black pawn
             is right adjacent to their 2 step pawn' do
      before do
        x = 1
        y = 1
        pawn.board.data[y][x] = 'P'
        pawn.board.data[y + 2][x + 1] = 'p'
        pawn.move_pawn([x, y], [x, y + 2])
      end

      it 'stores the coords on the right side of the 2 step pawn' do
        expect(pawn.board.en_passant).to eq [1, 3]
      end
    end

    context 'when it\'s white\'s turn and one pawn
             is left adjacent to a 2 step pawn' do
      before do
        x = 1
        y = 1
        pawn.board.data[y][x] = 'P'
        pawn.board.data[y + 2][x - 1] = 'p'
        pawn.move_pawn([x, y], [x, y + 2])
      end

      it 'stores the coords on the left side of the 2 step pawn' do
        expect(pawn.board.en_passant).to eq [1, 3]
      end
    end
  end

  describe '#assign_en_passant' do
    context 'when it\'s white\'s turn and there is a valid en_passant
             target on the left' do
      before do
        pawn.board.en_passant = [0, 4]
        x = 1
        y = 4
        pawn.board.data[y][x] = 'P'
        pawn.board.data[y][x - 1] = 'p'
      end

      it 'assigns the correct number of moves' do
        w_pawn = pawn.assign_en_passant([1, 4], pawn)
        expect(w_pawn.moves).to eq [[0, 1], [-1, 1]]
      end
    end

    context 'when it\'s white\'s turn and there is a valid en_passant
             target on the right' do
      before do
        pawn.board.en_passant = [2, 4]
        x = 1
        y = 4
        pawn.board.data[y][x] = 'P'
        pawn.board.data[y][x + 1] = 'p'
      end

      it 'assigns the correct number of moves' do
        w_pawn = pawn.assign_en_passant([1, 4], pawn)
        expect(w_pawn.moves).to eq [[0, 1], [1, 1]]
      end
    end

    context 'when it\'s black\'s turn and there is a valid en_passant
             target on the left' do
      before do
        pawn.board.turn = 1
        pawn.board.en_passant = [0, 3]
        x = 1
        y = 3
        pawn.board.data[y][x] = 'p'
        pawn.board.data[y][x - 1] = 'P'
      end

      it 'assigns the correct number of moves' do
        b_pawn = pawn.assign_en_passant([1, 3], pawn)
        b_pawn.moves.each do |set|
          set.map! { |move| move * -1 }
        end
        expect(b_pawn.moves).to eq [[0, -1], [-1, -1]]
      end
    end

    context 'when it\'s black\'s turn and there is a valid en_passant
             target on the right' do
      before do
        pawn.board.turn = 1
        pawn.board.en_passant = [2, 3]
        x = 1
        y = 3
        pawn.board.data[y][x] = 'p'
        pawn.board.data[y][x + 1] = 'P'
      end

      it 'assigns the correct number of moves' do
        b_pawn = pawn.assign_en_passant([1, 3], pawn)
        b_pawn.moves.each do |set|
          set.map! { |move| move * -1 }
        end
        expect(b_pawn.moves).to eq [[0, -1], [1, -1]]
      end
    end
  end

  describe '#promote?' do
    context 'when a white pawn reaches the last row' do
      it 'returns true' do
        x = 1
        y = 7
        pawn.board.data[y][x] = 'P'
        expect(pawn.promote?([x, y])).to be true
      end
    end

    context 'when a black pawn reaches the last row' do
      before do
        pawn.board.turn = 1
      end

      it 'returns true' do
        x = 1
        y = 0
        pawn.board.data[y][x] = 'p'
        expect(pawn.promote?([x, y])).to be true
      end
    end
  end
end
