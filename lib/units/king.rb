# frozen_string_literal: true

require_relative 'unit'
require_relative '../../lib/board'
require_relative 'mods/king_castle'
require_relative 'mods/king_check'

class King < Unit
  include KingCastle
  include KingCheck
  attr_reader :board

  def initialize(board)
    super
  end

  def assign_moves(start_pos, king)
    @start_pos = start_pos
    row = start_pos[1] # reverse due to array
    col = start_pos[0] # reverse due to array
    check_diags(row, col, king)
    check_horiz(row, col, king)
    check_vert(row, col, king)
    check_castle(king) if first_move?
    king
  end

  def check_diags(row, col, king)
    check_1(row, col, king)
    check_2(row, col, king)
    check_3(row, col, king)
    check_4(row, col, king)
    king
  end

  def check_1(row, col, king)
    return king if r_u_diag_invalid?(row, col) ||
                   hostile_pawns_kings?(col + 1, row + 1)

    dest = @board.data[row + 1][col + 1]
    @moves << [1, 1] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_2(row, col, king)
    return king if r_d_diag_invalid?(row, col) ||
                   hostile_pawns_kings?(col + 1, row - 1)

    dest = @board.data[row - 1][col + 1]
    @moves << [1, -1] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_3(row, col, king)
    return king if l_d_diag_invalid?(row, col) ||
                   hostile_pawns_kings?(col - 1, row - 1)

    dest = @board.data[row - 1][col - 1]
    @moves << [-1, -1] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_4(row, col, king)
    return king if l_u_diag_invalid?(row, col) ||
                   hostile_pawns_kings?(col - 1, row + 1)

    dest = @board.data[row + 1][col - 1]
    @moves << [-1, 1] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_horiz(row, col, king)
    check_r(row, col, king)
    check_l(row, col, king)
    king
  end

  def check_l(row, col, king)
    return king if (col - 1).negative?
    return king if hostile_row?(col, row)
    return king if hostile_l_col?(col, row)
    return king if hostile_pawns_kings?(col - 1, row)

    dest = @board.data[row][col - 1]
    @moves << [-1, 0] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_r(row, col, king)
    return king if (col + 1) > 7
    return king if hostile_row?(col, row)
    return king if hostile_r_col?(col, row)
    return king if hostile_pawns_kings?(col + 1, row)

    dest = @board.data[row][col + 1]
    @moves << [1, 0] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_vert(row, col, king)
    check_u(row, col, king)
    check_d(row, col, king)
    king
  end

  def check_u(row, col, king)
    return king if (row + 1) > 7
    return king if hostile_col?(col, row)
    return king if hostile_u_row?(col, row)
    return king if hostile_pawns_kings?(col, row + 1)

    dest = @board.data[row + 1][col]
    @moves << [0, 1] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_d(row, col, king)
    return king if (row - 1).negative?
    return king if hostile_col?(col, row)
    return king if hostile_d_row?(col, row)
    return king if hostile_pawns_kings?(col, row - 1)

    dest = @board.data[row - 1][col]
    @moves << [0, -1] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def move_king(start_pos, end_pos)
    first_move if first_move?
    @board.move_unit(start_pos, end_pos)
    if @board.turn.zero?
      @board.update_w_king_pos(end_pos)
    else
      @board.update_b_king_pos(end_pos)
    end
    castle(end_pos) if (start_pos[0] - end_pos[0]).abs == 2
  end
end

# arr = Array.new(8) { Array.new(8, '0') }
# king = King.new(arr)
# king.test
