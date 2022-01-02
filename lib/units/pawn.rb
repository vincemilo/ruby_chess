# frozen_string_literal: true

class Pawn
  attr_accessor :start_pos, :end_pos, :board, :moves

  def initialize(board, start_pos = nil, end_pos = nil)
    @board = board
    @start_pos = start_pos
    @end_pos = end_pos
    @moves = [[0, 1]]
  end

  def x_pos(pos)
    # extracts x coordinate
    pos[0]
  end

  def y_pos(pos)
    # extracts y coordinate
    pos[1]
  end

  def one_ahead(start_pos)
    @board[y_pos(start_pos) + 1][x_pos(start_pos)]
  end

  def two_ahead(start_pos)
    @board[y_pos(start_pos) + 2][x_pos(start_pos)]
  end

  def r_diag(start_pos)
    @board[y_pos(start_pos) + 1][x_pos(start_pos) + 1]
  end

  def l_diag(start_pos)
    @board[y_pos(start_pos) + 1][x_pos(start_pos) - 1]
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

  # def white_pawn(start_pos, end_pos)
  #   pawn = Pawn.new

  #   if start_pos[1] == 1
  #     starting_line(start_pos, pawn)
  #   elsif end_pos[1] == 7
  #     promote(end_pos)
  #   end

  #   check_diags(start_pos, pawn)

  #   pawn
  # end

end
