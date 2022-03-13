# frozen_string_literal: true

module KingCheck
  def r_u_diag_invalid?(row, col)
    return true if off_the_board?([row + 1, col + 1]) ||
                   hostile_r_col_diag?(col, row) ||
                   hostile_u_row_diag?(col, row) ||
                   hostile_neg_diag?(col, row)

    false
  end

  def r_d_diag_invalid?(row, col)
    return true if off_the_board?([row - 1, col + 1]) ||
                   hostile_r_col_diag?(col, row) ||
                   hostile_d_row_diag?(col, row) ||
                   hostile_pos_diag?(col, row)

    false
  end

  def l_d_diag_invalid?(row, col)
    return true if off_the_board?([row - 1, col - 1]) ||
                   hostile_l_col_diag?(col, row) ||
                   hostile_d_row_diag?(col, row) ||
                   hostile_neg_diag?(col, row)

    false
  end

  def l_u_diag_invalid?(row, col)
    return true if off_the_board?([row + 1, col - 1]) ||
                   hostile_l_col_diag?(col, row) ||
                   hostile_u_row_diag?(col, row) ||
                   hostile_pos_diag?(col, row)

    false
  end

  def hostile_col?(col, row)
    trans = @board.data.transpose[col]
    # add/subtract 1 to row to not count King itself
    return true if hostile_u?(row + 1, trans) || hostile_d?(row - 1, trans)

    false
  end

  def hostile_r_col?(col, row)
    trans_r = @board.data.transpose[col + 1]
    return false if trans_r.nil?
    return true if hostile_u?(row, trans_r) || hostile_d?(row, trans_r)

    false
  end

  def hostile_r_col_diag?(col, row)
    trans_r = @board.data.transpose[col + 1]
    return false if trans_r.nil?
    return true if hostile_u?(row + 1, trans_r) || hostile_d?(row - 1, trans_r)

    false
  end

  def hostile_l_col?(col, row)
    trans_l = @board.data.transpose[col - 1]
    return false if trans_l.nil?
    return true if hostile_u?(row, trans_l) || hostile_d?(row, trans_l)

    false
  end

  def hostile_l_col_diag?(col, row)
    trans_l = @board.data.transpose[col - 1]
    return false if trans_l.nil?
    return true if hostile_u?(row + 1, trans_l) || hostile_d?(row - 1, trans_l)

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

  def hostile_row?(col, row)
    trans = @board.data[row]
    # add/subtract 1 to row to not count King itself
    return true if hostile_u?(col + 1, trans) || hostile_d?(col - 1, trans)

    false
  end

  def hostile_u_row?(col, row)
    u_row = @board.data[row + 1]
    return false if u_row.nil?
    return true if hostile_u?(col, u_row) || hostile_d?(col, u_row)

    false
  end

  def hostile_u_row_diag?(col, row)
    u_row = @board.data[row + 1]
    return false if u_row.nil?
    return true if hostile_u?(col + 1, u_row) || hostile_d?(col - 1, u_row)

    false
  end

  def hostile_d_row?(col, row)
    d_row = @board.data[row - 1]
    return false if d_row.nil?
    return true if hostile_u?(col, d_row) || hostile_d?(col, d_row)

    false
  end

  def hostile_d_row_diag?(col, row)
    d_row = @board.data[row - 1]
    return false if d_row.nil?
    return true if hostile_u?(col + 1, d_row) || hostile_d?(col - 1, d_row)

    false
  end

  def hostile_neg_diag?(col, row)
    return true if hostile_neg_diag_d?(col, row) ||
                   hostile_neg_diag_u?(col, row)

    false
  end

  def hostile_neg_diag_d?(col, row)
    while ((row - 1).positive? && (col + 1) <= 7) &&
          (@board.get_unit([col + 1, row - 1]) == '0' ||
          q_b_check?(@board.get_unit([col + 1, row - 1])))
      return true if q_b_check?(@board.data[row - 1][col + 1])

      col += 1
      row -= 1
    end
    false
  end

  def hostile_neg_diag_u?(col, row)
    while ((row + 1) <= 7 && (col - 1).positive?) &&
          (@board.get_unit([col - 1, row + 1]) == '0' ||
          q_b_check?(@board.get_unit([col - 1, row + 1])))
      return true if q_b_check?(@board.data[row + 1][col - 1])

      col -= 1
      row += 1
    end
    false
  end

  def hostile_pos_diag?(col, row)
    return true if hostile_pos_diag_d?(col, row) ||
                   hostile_pos_diag_u?(col, row)

    false
  end

  def hostile_pos_diag_d?(col, row)
    while ((col - 1).positive? && (row - 1).positive?) &&
          (@board.get_unit([col - 1, row - 1]) == '0' ||
          q_b_check?(@board.get_unit([col - 1, row - 1])))
      return true if q_b_check?(@board.data[row - 1][col - 1])

      col -= 1
      row -= 1
    end
    false
  end

  def hostile_pos_diag_u?(col, row)
    while ((col + 1) <= 7 && (row + 1) <= 7) &&
          (@board.get_unit([col + 1, row + 1]) == '0' ||
          q_b_check?(@board.get_unit([col + 1, row + 1])))
      return true if q_b_check?(@board.data[row + 1][col + 1])

      col += 1
      row += 1
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

  def enemy_pawns?(col, row)
    return true if @board.turn.zero? && hostile_b_pawns?(col, row)
    return true if @board.turn.positive? && hostile_w_pawns?(col, row)

    false
  end

  def hostile_b_pawns?(col, row)
    r_u_diag = @board.data[row + 1][col + 1]
    l_u_diag = @board.data[row + 1][col - 1]
    return true if r_u_diag == 'p' || l_u_diag == 'p'

    false
  end

  def hostile_w_pawns?(col, row)
    r_d_diag = @board.data[row - 1][col - 1]
    l_d_diag = @board.data[row - 1][col + 1]
    return true if r_d_diag == 'P' || l_d_diag == 'P'

    false
  end

  def hostile_pawns?(col, row)
    return true if (@board.turn.zero? && hostile_b_pawns?(col, row)) ||
                   (@board.turn.positive? && hostile_w_pawns?(col, row))

    false
  end
end
