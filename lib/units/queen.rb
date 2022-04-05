# frozen_string_literal: true

require_relative 'unit'
require_relative '../../lib/board'

class Queen < Unit
  attr_reader :board

  def initialize(board)
    super
  end

  def assign_moves(start_pos, queen)
    @start_pos = start_pos
    start_pos = start_pos.reverse # reversed for array
    check_vert(start_pos, queen)
    check_horiz(start_pos, queen)
    row = start_pos[0]
    col = start_pos[1]
    check_1(row, col, queen)
    check_2(row, col, queen)
    check_3(row, col, queen)
    check_4(row, col, queen)
    queen
  end
end
