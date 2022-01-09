# frozen_string_literal: true

require_relative '../board'

class Unit
  attr_reader :board, :start_pos, :moves

  def initialize(start_pos = nil)
    @board = Board.new
    @start_pos = start_pos
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

  def move_unit(start_pos, end_pos, piece)
    return unless valid_move?(start_pos, end_pos, piece)

    @board[x_pos(start_pos)][y_pos(start_pos)] = '0'
    capture(end_pos) if @board[x_pos(end_pos)][y_pos(end_pos)] != '0'
    @board[x_pos(end_pos)][y_pos(end_pos)] = piece
    @turn += 1
    @turn %= 2
  end

  def valid_move?(end_pos)
    return false if end_pos[0].negative? || end_pos[0] > 7 ||
                    end_pos[1].negative? || end_pos[1] > 7

    true
  end
end

# unit = Unit.new
# unit.board.display_board
