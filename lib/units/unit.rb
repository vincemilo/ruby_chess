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

  def check_diags(start_pos, pawn)
    right = r_diag(start_pos)
    left = l_diag(start_pos)
    if enemy_occupied?(right) && enemy_occupied?(left)
      [[1, 1], [-1, 1]].each { |move| pawn.moves << move }
    elsif enemy_occupied?(right)
      pawn.moves << [1, 1]
    elsif enemy_occupied?(left)
      pawn.moves << [-1, 1]
    end
  end

  def l_adj(start_pos)
    @board.data[y_pos(start_pos)][x_pos(start_pos) - 1]
  end

  def r_adj(start_pos)
    @board.data[y_pos(start_pos)][x_pos(start_pos) + 1]
  end

  def move_unit(start_pos, end_pos)
    piece = get_unit(start_pos)
    p piece
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
