# frozen_string_literal: true

require_relative 'unit'
require_relative '../../lib/board'
require_relative 'mods/king_check'

class King < Unit
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

    return king if hostile_l_col?(col, row)

    dest = @board.data[row][col - 1]
    @moves << [-1, 0] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_r(row, col, king)
    return king if (col + 1) > 7

    return king if hostile_r_col?(col, row)

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

    return king if hostile_u_row?(col, row)

    dest = @board.data[row + 1][col]
    @moves << [0, 1] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_d(row, col, king)
    return king if (row - 1).negative?

    return king if hostile_d_row?(col, row)

    dest = @board.data[row - 1][col]
    @moves << [0, -1] if dest == '0' || @board.enemy_occupied?(dest)
    king
  end

  def check_castle(king)
    return king if rooks_moved?

    assign_castle_moves if castle?
    king
  end

  def rooks_moved?
    return true if (@board.turn.zero? && w_rooks_moved?) ||
                   (@board.turn.positive? && b_rooks_moved?)

    false
  end

  def w_rooks_moved?
    return true if w_r_rook_moved? && w_l_rook_moved?

    false
  end

  def w_r_rook_moved?
    return true if @board.data[0][7] != 'R' ||
                   @board.castle[:w_r_rook].positive?

    false
  end

  def w_l_rook_moved?
    return true if @board.data[0][0] != 'R' ||
                   @board.castle[:w_l_rook].positive?

    false
  end

  def b_rooks_moved?
    return true if b_r_rook_moved? && b_l_rook_moved?

    false
  end

  def b_r_rook_moved?
    return true if @board.data[7][7] != 'r' ||
                   @board.castle[:b_r_rook].positive?

    false
  end

  def b_l_rook_moved?
    return true if @board.data[7][0] != 'r' ||
                   @board.castle[:b_l_rook].positive?

    false
  end

  def w_king_moved?
    return true if @board.data[0][4] != 'K' || @board.castle[:w_king].positive?

    false
  end

  def b_king_moved?
    return true if @board.data[7][4] != 'k' || @board.castle[:b_king].positive?

    false
  end

  def castle?
    return true if w_valid_castle? || b_valid_castle?

    false
  end

  def w_valid_castle?
    return true if @board.turn.zero? && (w_r_castle? || w_l_castle?)

    false
  end

  def b_valid_castle?
    return true if @board.turn.positive? && (b_r_castle? || b_l_castle?)

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

  def b_l_castle?
    return true if @board.data[7][1] == '0' && @board.data[7][2] == '0' &&
                   @board.data[7][3] == '0'

    false
  end

  def move_king(start_pos, end_pos)
    first_move if first_move?
    @board.move_unit(start_pos, end_pos)
    castle(end_pos) if (start_pos[0] - end_pos[0]).abs == 2
  end

  def first_move?
    return true if (@board.turn.zero? && !w_king_moved?) ||
                   (@board.turn.positive? && !b_king_moved?)

    false
  end

  def first_move
    @board.update_w_king if @board.turn.zero?
    @board.update_b_king if @board.turn.positive?
  end

  def castle(end_pos)
    if end_pos == [6, 0]
      w_r_castle
    elsif end_pos == [2, 0]
      w_l_castle
    elsif end_pos == [2, 7]
      b_l_castle
    elsif end_pos == [6, 7]
      b_r_castle
    end
  end

  def w_r_castle
    @board.data[0][5] = 'R'
    @board.data[0][7] = '0'
  end

  def w_l_castle
    @board.data[0][3] = 'R'
    @board.data[0][0] = '0'
  end

  def b_l_castle
    @board.data[7][3] = 'r'
    @board.data[7][0] = '0'
  end

  def b_r_castle
    @board.data[7][5] = 'r'
    @board.data[7][7] = '0'
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

  def hostile_r_col?(col, row)
    trans_r = @board.data.transpose[col + 1]
    return true if hostile_u?(row, trans_r) || hostile_d?(row, trans_r)

    false
  end

  def hostile_l_col?(col, row)
    trans_l = @board.data.transpose[col - 1]
    return true if hostile_u?(row, trans_l) || hostile_d?(row, trans_l)

    false
  end

  def q_r_check?(trans, row, moves)
    # checks if an enemy queen or rook is in the row
    w_hostile_pieces = %w[R Q]
    b_hostile_pieces = %w[r q]
    piece = trans[row + moves]
    return true if @board.turn.zero? &&
                   b_hostile_pieces.any? { |hostile| hostile == piece }

    return true if @board.turn.positive? &&
                   w_hostile_pieces.any? { |hostile| hostile == piece }

    false
  end

  def hostile_u?(row, trans)
    moves = 0
    while trans[row + moves] == '0' || q_r_check?(trans, row, moves)
      return true if q_r_check?(trans, row, moves)

      moves += 1
    end

    false
  end

  def hostile_d?(row, trans)
    moves = 0
    while trans[row + moves] == '0' || q_r_check?(trans, row, moves)
      return true if q_r_check?(trans, row, moves)

      moves -= 1
    end

    false
  end

  def hostile_u_row?(col, row)
    u_row = @board.data[row + 1]
    return true if hostile_u?(col, u_row) || hostile_d?(col, u_row)

    false
  end

  def hostile_d_row?(col, row)
    d_row = @board.data[row - 1]
    return true if hostile_u?(col, d_row) || hostile_d?(col, d_row)

    false
  end

  def hostile_neg_diag?(col, row)
    return true if hostile_r_neg_diag?(col, row)

    false
  end

  def hostile_r_neg_diag?(col, row)
    while ((row - 1).positive? && (col + 1) <= 7) &&
          (@board.get_unit([col + 1, row - 1]) == '0' ||
          q_b_check?(@board.get_unit([col + 1, row - 1])))
      return true if q_b_check?(@board.data[row - 1][col + 1])

      col += 1
      row -= 1
    end
    false
  end

  def q_b_check?(piece)
    # checks if an enemy queen or rook is in the row
    w_hostile_pieces = %w[B Q]
    b_hostile_pieces = %w[b q]
    return true if @board.turn.zero? &&
                   b_hostile_pieces.any? { |hostile| hostile == piece }

    return true if @board.turn.positive? &&
                   w_hostile_pieces.any? { |hostile| hostile == piece }

    false
  end

end

# arr = Array.new(8) { Array.new(8, '0') }
# king = King.new(arr)
# king.test