# frozen_string_literal: true

module RookMoves
  # rook methods

  def check_horiz(start_pos, rook)
    row = start_pos[0]
    col = start_pos[1]
    trans = @board.data[row]
    r_moves = check_r(col, trans)
    l_moves = check_l(col, trans)
    @moves += r_moves + l_moves
    rook
  end

  def check_vert(start_pos, unit)
    row = start_pos[0]
    col = start_pos[1]
    trans = @board.data.transpose[col]
    u_moves = check_u(row, trans)
    d_moves = check_d(row, trans)
    @moves += u_moves + d_moves
    unit
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

  def rooks_moved?
    return true if w_rooks_moved? && b_rooks_moved?

    false
  end

  def w_rooks_moved?
    return true if @board.turn.zero? && w_r_rook_moved? && w_l_rook_moved?

    false
  end

  def w_r_rook_moved?
    if @board.data[0][7] != 'R' || @board.castle[:w_r_rook].positive?
      return true
    end

    false
  end

  def w_l_rook_moved?
    if @board.data[0][0] != 'R' || @board.castle[:w_l_rook].positive?
      return true
    end

    false
  end

  def b_rooks_moved?
    return true if @board.turn.positive? && b_r_rook_moved? && b_l_rook_moved?

    false
  end

  def b_r_rook_moved?
    if @board.data[7][7] != 'r' || @board.castle[:b_r_rook].positive?
      return true
    end

    false
  end

  def b_l_rook_moved?
    if @board.data[7][0] != 'r' || @board.castle[:b_l_rook].positive?
      return true
    end

    false
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
end
