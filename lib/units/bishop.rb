# frozen_string_literal: true

require_relative 'unit'
require_relative '../../lib/board'

class Bishop < Unit
  attr_reader :board

  def initialize(board)
    super
  end

  def assign_moves(start_pos, bishop)
    @start_pos = start_pos
    start_pos = start_pos.reverse # reversed for array
    row = start_pos[0]
    col = start_pos[1]
    check_1(row, col, bishop)
    check_2(row, col, bishop)
    check_3(row, col, bishop)
    check_4(row, col, bishop)
    bishop
  end
end

# bishop = Bishop.new
# p bishop.moves
