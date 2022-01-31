# frozen_string_literal: true

require_relative 'unit'
require_relative '../../lib/board'

class King < Unit
  attr_reader :board

  def initialize(board)
    super
  end

  def assign_moves(start_pos, king)
    start_pos = start_pos.reverse # temp until Pawn coords are fixed
    row = start_pos[0]
    col = start_pos[1]
    check_diags(row, col, king)
    check_horiz(row, col, king)
    check_vert(row, col, king)
    check_castle(king)
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
    return king if off_the_board?([row + 1, col + 1])

    dest = @board.data[row + 1][col + 1]
    @moves << [1, 1] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_2(row, col, king)
    return king if off_the_board?([row - 1, col + 1])

    dest = @board.data[row - 1][col + 1]
    @moves << [1, -1] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_3(row, col, king)
    return king if off_the_board?([row - 1, col - 1])

    dest = @board.data[row - 1][col - 1]
    @moves << [-1, -1] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_4(row, col, king)
    return king if off_the_board?([row + 1, col - 1])

    dest = @board.data[row - 1][col - 1]
    @moves << [-1, 1] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_horiz(row, col, king)
    check_r(row, col, king)
    check_l(row, col, king)
    king
  end

  def check_l(row, col, king)
    return king if off_the_board?([row, col - 1])

    dest = @board.data[row][col - 1]
    @moves << [-1, 0] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_r(row, col, king)
    return king if off_the_board?([row, col + 1])

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
    return king if off_the_board?([row + 1, col])

    dest = @board.data[row + 1][col]
    @moves << [0, 1] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_d(row, col, king)
    return king if off_the_board?([row - 1, col])

    dest = @board.data[row][col + 1]
    @moves << [0, -1] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_castle(king)
    return king if w_king_moved? || b_king_moved? || rooks_moved?

    assign_castle_moves if castle?
    king
  end

  def w_king_moved?
    return true if @board.turn.zero? && @board.w_king.positive?

    false
  end

  def b_king_moved?
    return true if @board.turn.zero? && @board.b_king.positive?

    false
  end

  def rooks_moved?
    return true if w_rooks_moved? && b_rooks_moved?

    false
  end

  def w_rooks_moved?
    return true if @board.turn.zero && w_r_rook_moved? && w_l_rook_moved?

    false
  end

  def w_r_rook_moved?
    return true if @board.w_r_rook.positive?

    false
  end

  def w_l_rook_moved?
    return true if @board.w_l_rook.positive?

    false
  end

  def b_rooks_moved?
    return true if @board.turn.zero && w_r_rook_moved? && w_l_rook_moved?

    false
  end

  def b_r_rook_moved?
    return true if @board.b_r_rook.positive?

    false
  end

  def b_l_rook_moved?
    return true if @board.b_l_rook.positive?

    false
  end

  def castle?
    if @board.turn.zero?
      return true if w_r_castle? || w_l_castle?

    elsif @board.turn.positive?
      return true if b_r_castle? || b_l_castle?

    end
    false
  end

  def w_r_castle?
    return true if @board.data[0][5] == '0' && @board.data[0][6] == '0'

    false
  end

  def w_l_castle?
    return true if @board.data[0][1] == '0' && @board.data[0][2] == '0' &&
                   @board.data[0][3] == '0'

    false
  end

  def b_r_castle?
    return true if @board.data[7][5] == '0' && @board.data[7][6] == '0'

    false
  end

  def l_castle?
    return true if @board.data[7][1] == '0' && @board.data[7][2] == '0' &&
                   @board.data[7][3] == '0'

    false
  end

  def assign_castle_moves
    if @board.turn.zero?
      @moves << [2, 0] if w_r_castle?
      @moves << [-2, 0] if w_l_castle?
    else
      @moves << [2, 0] if b_r_castle?
      @moves << [-2, 0] if b_l_castle?
    end
  end
end