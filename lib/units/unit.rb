# frozen_string_literal: true

require_relative '../board'

class Unit
  attr_reader :board, :start_pos, :end_pos, :moves

  def initialize(start_pos = nil, end_pos = nil)
    @board = Board.new
    @start_pos = start_pos
    @end_pos = end_pos
    @moves = []
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

  def enemy_occupied?(piece)
    white_pieces = %w[P R N B Q K]
    black_pieces = white_pieces.map(&:downcase)

    return true if @board.turn.zero? && black_pieces.any?(piece)

    return true if @board.turn.positive? && white_pieces.any?(piece)

    false
  end

  def get_piece(square)
    @board.data[y_pos(square)][x_pos(square)]
  end

  def one_ahead(start_pos)
    @board.data[y_pos(start_pos) + 1][x_pos(start_pos)]
  end

  def two_ahead(start_pos)
    @board.data[y_pos(start_pos) + 2][x_pos(start_pos)]
  end

  def r_diag(start_pos)
    @board.data[y_pos(start_pos) + 1][x_pos(start_pos) + 1]
  end

  def l_diag(start_pos)
    @board.data[y_pos(start_pos) + 1][x_pos(start_pos) - 1]
  end
end

# unit = Unit.new
# unit.board.display_board