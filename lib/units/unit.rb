# frozen_string_literal: true

require_relative '../board'

class Unit
  attr_reader :board, :start_pos, :moves

  def initialize(board = Board.new, start_pos = [], moves = [])
    @board = board
    @start_pos = start_pos
    @moves = moves
  end

  def update_start_pos(start_pos)
    @start_pos = start_pos
  end

  def update_moves(moves)
    @moves = moves
  end

  def x_pos(pos)
    # extracts x coordinate
    pos[0]
  end

  def y_pos(pos)
    # extracts y coordinate
    pos[1]
  end

  def occupied?(coords)
    return true unless coords == '0'

    false
  end

  def move_validator(start_pos, end_pos, piece)
    x = end_pos[0] - start_pos[0]
    y = end_pos[1] - start_pos[1]
    return true if piece.moves.any? { |move| move == [x, y] }

    false
  end

  def off_the_board?(end_pos)
    return true if end_pos[0].negative? || end_pos[0] > 7 ||
                   end_pos[1].negative? || end_pos[1] > 7

    false
  end

  def one_ahead(start_pos)
    if @board.turn.zero?
      @board.data[y_pos(start_pos) + 1][x_pos(start_pos)]
    else
      @board.data[y_pos(start_pos) - 1][x_pos(start_pos)]
    end
  end

  def two_ahead(start_pos)
    if @board.turn.zero?
      @board.data[y_pos(start_pos) + 2][x_pos(start_pos)]
    else
      @board.data[y_pos(start_pos) - 2][x_pos(start_pos)]
    end
  end

  def r_diag(start_pos)
    if @board.turn.zero?
      @board.data[y_pos(start_pos) + 1][x_pos(start_pos) + 1]
    else
      @board.data[y_pos(start_pos) - 1][x_pos(start_pos) + 1]
    end
  end

  def l_diag(start_pos)
    if @board.turn.zero?
      @board.data[y_pos(start_pos) + 1][x_pos(start_pos) - 1]
    else
      @board.data[y_pos(start_pos) - 1][x_pos(start_pos) - 1]
    end
  end

  def r_diag_occupied?(right, left)
    return true if right && @board.turn.zero? || left && @board.turn.positive?

    false
  end

  def l_diag_occupied?(right, left)
    return true if left && @board.turn.zero? || right && @board.turn.positive?

    false
  end

  def l_adj(start_pos)
    @board.data[y_pos(start_pos)][x_pos(start_pos) - 1]
  end

  def r_adj(start_pos)
    @board.data[y_pos(start_pos)][x_pos(start_pos) + 1]
  end

  # rook methods

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

  def check_vert(start_pos, unit)
    row = start_pos[0]
    col = start_pos[1]
    trans = @board.data.transpose[col]
    u_moves = check_u(row, trans)
    d_moves = check_d(row, trans)
    @moves += u_moves + d_moves
    unit
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

# unit = Unit.new
