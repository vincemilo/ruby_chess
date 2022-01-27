# frozen_string_literal: true

require_relative 'unit'
require_relative '../../lib/board'

class Rook < Unit
  attr_reader :board

  def initialize(board)
    super
  end

  def assign_moves(start_pos, rook)
    check_vert(start_pos, rook)
    check_horiz(start_pos, rook)
    rook
  end

  def check_vert(start_pos, rook)
    row = start_pos[0]
    col = start_pos[1]
    trans = @board.data.transpose[col]
    u_moves = check_u(row, col, trans)
    d_moves = check_d(row, col, trans)
    @moves += u_moves + d_moves
    rook
  end

  def enemy_check?(trans, row, moves)
    return true if @board.enemy_occupied?(trans[row + moves])

    false
  end

  def enemy_check(row, col, moves, options)
    options << [row + moves, col]
    options
  end

  def check_u(row, col, trans)
    options = []
    moves = 1
    while trans[row + moves] == '0' || @board.enemy_occupied?(trans[row + moves])
      options << [row + moves, col]
      if enemy_check?(trans, row, moves)
        return enemy_check(row, col, moves, options)
      end

      moves += 1
    end
    options
  end

  def check_d(row, col, trans)
    options = []
    moves = -1
    while row + moves >= 0 && trans[row + moves] == '0' ||
          @board.enemy_occupied?(trans[row + moves])
      options << [row + moves, col]
      if enemy_check?(trans, row, moves)
        return enemy_check(row, col, moves, options)
      end

      moves -= 1
    end
    options
  end

  def check_horiz(start_pos, rook)
    row = start_pos[0]
    col = start_pos[1]
    trans = @board.data[row]
    r_moves = check_r(row, col, trans)
    l_moves = check_l(row, col, trans)
    @moves += r_moves + l_moves
    rook
  end

  def check_r(row, col, trans)
    options = []
    moves = 1
    while trans[col + moves] == '0' || @board.enemy_occupied?(trans[row + moves])
      options << [row, col + moves]
      if enemy_check?(trans, col, moves)
        return enemy_check(row, col, moves, options)
      end

      moves += 1
    end
    options
  end

  def check_l(row, col, trans)
    options = []
    moves = -1
    while col + moves >= 0 && trans[col + moves] == '0' ||
          @board.enemy_occupied?(trans[row + moves])
      options << [row, col + moves]
      if enemy_check?(trans, row, moves)
        return enemy_check(row, col, moves, options)
      end

      moves -= 1
    end
    options
  end
end
