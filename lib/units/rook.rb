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
    start_pos = start_pos.reverse # reversed for array
    check_vert(start_pos, rook)
    check_horiz(start_pos, rook)
    @start_pos = start_pos
    rook
  end

  def move_rook(start_pos, end_pos)
    first_move if first_move?
    @board.move_unit(start_pos, end_pos)
  end

  def first_move?
    return true unless w_rooks_moved? && b_rooks_moved?

    false
  end

  def first_move
    rook = 0
    if start_pos == ([7, 0] || [7, 7])
      rook = 1
    elsif start_pos == ([0, 0] || [0, 7])
      rook = 2
    end
    @board.turn.zero? ? @board.update_w_rook(rook) : @board.update_b_rook(rook)
  end
end
