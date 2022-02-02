# frozen_string_literal: true

require_relative 'unit'
require_relative '../../lib/board'

class Rook < Unit
  attr_reader :board

  def initialize(board)
    super
  end

  def check_vert(start_pos, rook)
    row = start_pos[0]
    col = start_pos[1]
    trans = @board.data.transpose[col]
    u_moves = check_u(row, trans)
    d_moves = check_d(row, trans)
    @moves += u_moves + d_moves
    rook
  end

  def enemy_check?(trans, row, moves)
    return true if @board.enemy_occupied?(trans[row + moves])

    false
  end

  def check_u(row, trans)
    options = []
    moves = 1
    while trans[row + moves] == '0' || @board.enemy_occupied?(trans[row + moves])
      options << [0, moves]
      return options if enemy_check?(trans, row, moves)

      moves += 1
    end
    options
  end

  def check_d(row, trans)
    options = []
    moves = -1
    while row + moves >= 0 && (trans[row + moves] == '0' ||
          @board.enemy_occupied?(trans[row + moves]))
      options << [0, moves]
      return options if enemy_check?(trans, row, moves)

      moves -= 1
    end
    options
  end

  def check_horiz(start_pos, rook)
    row = start_pos[0]
    col = start_pos[1]
    trans = @board.data[row]
    r_moves = check_r(col, trans)
    l_moves = check_l(col, trans)
    @moves += r_moves + l_moves
    rook
  end

  def check_r(col, trans)
    options = []
    moves = 1
    while trans[col + moves] == '0' || @board.enemy_occupied?(trans[col + moves])
      options << [moves, 0]
      return options if enemy_check?(trans, col, moves)

      moves += 1
    end
    options
  end

  def check_l(col, trans)
    options = []
    moves = -1
    while col + moves >= 0 && (trans[col + moves] == '0' ||
          @board.enemy_occupied?(trans[col + moves]))
      options << [moves, 0]
      return options if enemy_check?(trans, col, moves)

      moves -= 1
    end
    options
  end

  def assign_moves(start_pos, rook)
    start_pos = start_pos.reverse # temp until Pawn coords are fixed
    check_vert(start_pos, rook)
    check_horiz(start_pos, rook)
    rook
  end

  def move_rook(start_pos, end_pos)
    rook = 0
    if start_pos == [7, 0] || [7, 7]
      rook = 1
    elsif start_pos == [0, 0] || [0, 7]
      rook = 2
    end
    @board.turn.zero? ? @board.update_w_rook(rook) : @board.update_b_rook(rook)
    @board.move_unit(start_pos, end_pos)
  end
end

def move_king(start_pos, end_pos)
  first_move(1) unless w_king_moved?
  first_move(2) unless b_king_moved?
  @board.move_unit(start_pos, end_pos)
  castle(end_pos) if (start_pos[0] - end_pos[0]).abs == 2
end

def first_move(turn)
  turn == 1 ? @board.update_w_king : @board.update_b_king
end

def w_r_rook_moved?
  return true if @board.data[0][7] != 'R' || @board.w_r_rook.positive?

  false
end

def w_l_rook_moved?
  return true if @board.data[0][0] != 'R' || @board.w_l_rook.positive?

  false
end

def b_rooks_moved?
  return true if @board.turn.zero && w_r_rook_moved? && w_l_rook_moved?

  false
end

def b_r_rook_moved?
  return true if @board.data[7][7] != 'r' || @board.b_r_rook.positive?

  false
end

def b_l_rook_moved?
  return true if @board.data[7][0] != 'r' || @board.b_l_rook.positive?