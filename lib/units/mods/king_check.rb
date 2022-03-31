# frozen_string_literal: true

module KingCheck
  def r_u_diag_invalid?(row, col)
    return true if off_the_board?([row + 1, col + 1]) ||
                   hostile_r_col_diag?(col, row) ||
                   hostile_u_row_diag?(col, row) ||
                   hostile_neg_diag?(col + 1, row + 1)

    false
  end

  def r_d_diag_invalid?(row, col)
    return true if off_the_board?([row - 1, col + 1]) ||
                   hostile_r_col_diag?(col, row) ||
                   hostile_d_row_diag?(col, row) ||
                   hostile_pos_diag?(col + 1, row - 1)

    false
  end

  def l_d_diag_invalid?(row, col)
    return true if off_the_board?([row - 1, col - 1]) ||
                   hostile_l_col_diag?(col, row) ||
                   hostile_d_row_diag?(col, row) ||
                   hostile_neg_diag?(col - 1, row - 1)

    false
  end

  def l_u_diag_invalid?(row, col)
    return true if off_the_board?([row + 1, col - 1]) ||
                   hostile_l_col_diag?(col, row) ||
                   hostile_u_row_diag?(col, row) ||
                   hostile_pos_diag?(col - 1, row + 1)

    false
  end

  def hostile_col?(col, row, board = @board)
    trans = board.data.transpose[col]
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
    piece = trans[row + moves]
    return true if @board.turn.zero? && %w[r q].include?(piece)
    return true if @board.turn.positive? && %w[R Q].include?(piece)

    false
  end

  def hostile_u?(row, trans)
    return false if (row + 1) > 7

    moves = 0
    while empty_check?(trans[row + moves]) || q_r_check?(trans, row, moves)
      return true if q_r_check?(trans, row, moves)

      moves += 1
    end

    false
  end

  def hostile_d?(row, trans)
    return false if (row - 1).negative?

    moves = 0
    while empty_check?(trans[row + moves]) || q_r_check?(trans, row, moves)
      return true if q_r_check?(trans, row, moves)

      moves -= 1
    end

    false
  end

  def hostile_row?(col, row, board = @board)
    trans = board.data[row]
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

  def hostile_neg_diag?(col, row, board = @board)
    return true if hostile_neg_diag_d?(col, row, board) ||
                   hostile_neg_diag_u?(col, row, board)

    false
  end

  def hostile_neg_diag_d?(col, row, board = @board)
    while ((row - 1).positive? && (col + 1) <= 7) &&
          (empty_check?(board.get_unit([col + 1, row - 1])) ||
          q_b_check?(board.get_unit([col + 1, row - 1])))
      return true if q_b_check?(board.data[row - 1][col + 1])

      col += 1
      row -= 1
    end
    false
  end

  def hostile_neg_diag_u?(col, row, board = @board)
    while ((row + 1) <= 7 && (col - 1).positive?) &&
          (empty_check?(board.get_unit([col - 1, row + 1])) ||
          q_b_check?(board.get_unit([col - 1, row + 1])))
      return true if q_b_check?(board.data[row + 1][col - 1])

      col -= 1
      row += 1
    end
    false
  end

  def hostile_pos_diag?(col, row, board = @board)
    return true if hostile_pos_diag_d?(col, row, board) ||
                   hostile_pos_diag_u?(col, row, board)

    false
  end

  def hostile_pos_diag_d?(col, row, board = @board)
    while ((col - 1).positive? && (row - 1).positive?) &&
          (empty_check?(board.get_unit([col - 1, row - 1])) ||
          q_b_check?(board.get_unit([col - 1, row - 1])))
      return true if q_b_check?(board.data[row - 1][col - 1])

      col -= 1
      row -= 1
    end
    false
  end

  def hostile_pos_diag_u?(col, row, board = @board)
    while ((col + 1) <= 7 && (row + 1) <= 7) &&
          (empty_check?(board.get_unit([col + 1, row + 1])) ||
          q_b_check?(board.get_unit([col + 1, row + 1])))
      return true if q_b_check?(board.data[row + 1][col + 1])

      col += 1
      row += 1
    end
    false
  end

  def empty_check?(piece)
    return true if piece == '0'

    false
  end

  def q_b_check?(piece)
    # checks if an enemy queen or rook is in the row
    return true if @board.turn.zero? && %w[b q].include?(piece)
    return true if @board.turn.positive? && %w[B Q].include?(piece)

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

  def hostile_king?(col, row)
    king = if @board.turn.zero?
             'k'
           else
             'K'
           end
    return true if hostile_king_diag?(col, row, king)
    return true if hostile_king_orthog?(col, row, king)

    false
  end

  def hostile_king_diag?(col, row, king)
    return true if h_k_r_u(col, row) == king
    return true if h_k_l_u(col, row) == king
    return true if h_k_r_d(col, row) == king
    return true if h_k_l_d(col, row) == king

    false
  end

  def hostile_king_orthog?(col, row, king)
    return true if h_k_up(col, row) == king
    return true if h_k_down(col, row) == king
    return true if h_k_left(col, row) == king
    return true if h_k_right(col, row) == king

    false
  end

  def h_k_r_u(col, row)
    return if (row + 1) > 7 || (col + 1) > 7

    @board.data[row + 1][col + 1]
  end

  def h_k_l_u(col, row)
    return if (row + 1) > 7 || (col - 1).negative?

    @board.data[row + 1][col - 1]
  end

  def h_k_r_d(col, row)
    return if (row - 1).negative? || (col + 1) > 7

    @board.data[row - 1][col + 1]
  end

  def h_k_l_d(col, row)
    return if (row - 1).negative? || (col - 1).negative?

    @board.data[row - 1][col - 1]
  end

  def h_k_up(col, row)
    return if (row + 1) > 7

    @board.data[row + 1][col]
  end

  def h_k_down(col, row)
    return if (row - 1).negative?

    @board.data[row - 1][col]
  end

  def h_k_left(col, row)
    return if (col - 1).negative?

    @board.data[row][col - 1]
  end

  def h_k_right(col, row)
    return if (col + 1) > 7

    @board.data[row][col + 1]
  end

  def hostile_pawns_kings_knights?(col, row)
    return true if hostile_pawns?(col, row)
    return true if hostile_king?(col, row)
    return true if hostile_knights?(col, row)

    false
  end

  def hostile_knights?(col, row)
    knight = if @board.turn.zero?
               'n'
             else
               'N'
             end

    return true if h_n_check?(col, row, knight)

    false
  end

  def h_n_check?(col, row, knight)
    return true if h_n_1(row, col) == knight
    return true if h_n_2(row, col) == knight
    return true if h_n_3(row, col) == knight
    return true if h_n_4(row, col) == knight
    return true if h_n_check_2?(col, row, knight)

    false
  end

  # broke these up to reduce complexity not sure if that actually does anything

  def h_n_check_2?(col, row, knight)
    return true if h_n_5(row, col) == knight
    return true if h_n_6(row, col) == knight
    return true if h_n_7(row, col) == knight
    return true if h_n_8(row, col) == knight

    false
  end

  def h_n_1(row, col)
    return if (row + 2) > 7 || (col + 1) > 7

    @board.data[row + 2][col + 1]
  end

  def h_n_2(row, col)
    return if (row + 1) > 7 || (col + 2) > 7

    @board.data[row + 1][col + 2]
  end

  def h_n_3(row, col)
    return if (row + 2) > 7 || (col - 1).negative?

    @board.data[row + 2][col - 1]
  end

  def h_n_4(row, col)
    return if (row + 1) > 7 || (col - 2).negative?

    @board.data[row + 1][col - 2]
  end

  def h_n_5(row, col)
    return if (row - 1).negative? || (col - 2).negative?

    @board.data[row - 1][col - 2]
  end

  def h_n_6(row, col)
    return if (row - 2).negative? || (col - 1).negative?

    @board.data[row - 2][col - 1]
  end

  def h_n_7(row, col)
    return if (row - 2).negative? || (col + 1) > 7

    @board.data[row - 2][col + 1]
  end

  def h_n_8(row, col)
    return if (row - 1).negative? || (col + 2) > 7

    @board.data[row - 1][col + 2]
  end
end
