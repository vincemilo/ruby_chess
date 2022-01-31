# frozen_string_literal: true

require_relative '../board'

class Unit
  attr_reader :board, :start_pos, :moves

  def initialize(board = Board.new, start_pos = [], moves = [])
    @board = board
    @start_pos = start_pos
    @moves = moves
  end

  def update_moves(*moves)
    @moves += moves
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
end

# unit = Unit.new
