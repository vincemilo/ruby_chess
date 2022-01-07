# frozen_string_literal: true

require_relative 'unit'

class Pawn < Unit
  attr_accessor :start_pos, :end_pos, :board, :moves

  def initialize(start_pos = nil, end_pos = nil)
    super
    @moves = [[0, 1]]
  end

  def starting_line(start_pos, pawn)
    if !occupied?(one_ahead(start_pos)) && !occupied?(two_ahead(start_pos))
      pawn.moves << [0, 2]
    elsif occupied?(one_ahead(start_pos))
      pawn.moves = []
    end
  end

  def check_diags(start_pos, pawn)
    if enemy_occupied?(r_diag(start_pos)) && enemy_occupied?(l_diag(start_pos))
      [[1, 1], [-1, 1]].each { |move| pawn.moves << move }
    elsif enemy_occupied?(r_diag(start_pos))
      pawn.moves << [1, 1]
    elsif enemy_occupied?(l_diag(start_pos))
      pawn.moves << [-1, 1]
    end
  end

  def white_pawn(start_pos, end_pos, pawn)

    if start_pos[1] == 1
      starting_line(start_pos, pawn)
    elsif end_pos[1] == 7
      promote(end_pos)
    end

    check_diags(start_pos, pawn)

    pawn
  end
end

# pawn = Pawn.new
# p pawn
# pawn.board.display_board
# pawn2 = Pawn.new([1, 1], [1, 3])
# p pawn2
