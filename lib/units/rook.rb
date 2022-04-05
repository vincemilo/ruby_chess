# frozen_string_literal: true

require_relative 'unit'
require_relative '../../lib/board'

class Rook < Unit
  attr_reader :board

  def initialize(board)
    super
  end

  def assign_moves(start_pos, rook)
    @start_pos = start_pos
    start_pos = start_pos.reverse # reversed for array
    check_vert(start_pos, rook)
    check_horiz(start_pos, rook)
    rook
  end

  def move_rook(start_pos, end_pos)
    first_move(start_pos) if first_move?
    @board.move_unit(start_pos, end_pos)
  end

  def first_move?
    return true unless w_rooks_moved? && b_rooks_moved?

    false
  end

  def first_move(start_pos)
    rook = if [[7, 0], [7, 7]].include?(start_pos)
             1 # right side rooks
           elsif [[0, 0], [0, 7]].include?(start_pos)
             2 # left side rooks
           end
    return if rook.nil?

    @board.turn.zero? ? @board.update_w_rook(rook) : @board.update_b_rook(rook)
  end
end
