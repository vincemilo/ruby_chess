# frozen_string_literal: true

require_relative '../board'

class Unit
  attr_reader :board, :start_pos, :moves

  def initialize(board = Board.new, start_pos = [], moves = [])
    @board = board
    @start_pos = start_pos
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

  def occupied?(square)
    return true unless square == '0'

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

  def check_diags(start_pos, unit)
    right = @board.enemy_occupied?(r_diag(start_pos))
    left = @board.enemy_occupied?(l_diag(start_pos))

    if right && left
      [[1, 1], [-1, 1]].each { |move| unit.moves << move }
    elsif r_diag_occupied?(right, left)
      unit.moves << [1, 1]
    elsif l_diag_occupied?(right, left)
      unit.moves << [-1, 1]
    end
    unit
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

  def move_validator(start_pos, end_pos, piece)
    x = end_pos[0] - start_pos[0]
    y = end_pos[1] - start_pos[1]
    return true if piece.moves.any? { |move| move == [x, y] }

    false
  end
end

# unit = Unit.new
