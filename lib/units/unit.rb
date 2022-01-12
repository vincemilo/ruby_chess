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

  def get_unit(square)
    @board.data[y_pos(square)][x_pos(square)]
  end

  def move_unit(start_pos, end_pos)
    piece = get_unit(start_pos)
    return unless valid_move?(end_pos)

    @board.data[y_pos(start_pos)][x_pos(start_pos)] = '0'
    # capture(end_pos) if @board[x_pos(end_pos)][y_pos(end_pos)] != '0'
    @board.data[y_pos(end_pos)][x_pos(end_pos)] = piece
    @board.turn += 1
    @board.turn %= 2
  end

  def valid_move?(end_pos)
    return false if end_pos[0].negative? || end_pos[0] > 7 ||
                    end_pos[1].negative? || end_pos[1] > 7

    true
  end

  # def capture(pos)
  #   piece = @board[x_pos(pos)][y_pos(pos)]
  #   if @turn.zero?
  #     @captured[0] << piece
  #   else
  #     @captured[1] << piece
  #   end
  #   puts "Captured pieces: #{@captured}"
  # end
end

# unit = Unit.new
