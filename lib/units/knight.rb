# frozen_string_literal: true

require_relative 'unit'
require_relative '../../lib/board'

class Knight < Unit
  attr_reader :board

  def initialize(board)
    super
  end

  def check_1(row, col, knight)
    return knight if @board.off_the_board?([row + 2, col + 1])

    dest = @board.data[row + 2][col + 1]
    @moves << [2, 1] if dest == '0' || @board.enemy_occupied?(dest)
    knight
  end

  def check_2(row, col, knight)
    return knight if @board.off_the_board?([row + 1, col + 2])

    dest = @board.data[row + 1][col + 2]
    @moves << [1, 2] if dest == '0' || @board.enemy_occupied?(dest)
    knight
  end

  def check_3(row, col, knight)
    return knight if @board.off_the_board?([row + 2, col - 1])

    dest = @board.data[row + 2][col - 1]
    @moves << [2, -1] if dest == '0' || @board.enemy_occupied?(dest)
    knight
  end

  def check_4(row, col, knight)
    return knight if @board.off_the_board?([row + 1, col - 2])

    dest = @board.data[row + 1][col - 2]
    @moves << [1, -2] if dest == '0' || @board.enemy_occupied?(dest)
    knight
  end

  def check_5(row, col, knight)
    return knight if @board.off_the_board?([row - 1, col - 2])

    dest = @board.data[row - 1][col - 2]
    @moves << [-1, -2] if dest == '0' || @board.enemy_occupied?(dest)
    knight
  end

  def check_6(row, col, knight)
    return knight if @board.off_the_board?([row - 2, col - 1])

    dest = @board.data[row - 2][col - 1]
    @moves << [-2, -1] if dest == '0' || @board.enemy_occupied?(dest)
    knight
  end

  def check_7(row, col, knight)
    return knight if @board.off_the_board?([row - 2, col + 1])

    dest = @board.data[row - 2][col + 1]
    @moves << [-2, 1] if dest == '0' || @board.enemy_occupied?(dest)
    knight
  end

  def check_8(row, col, knight)
    return knight if @board.off_the_board?([row - 1, col + 2])

    dest = @board.data[row - 1][col + 2]
    @moves << [-1, 2] if dest == '0' || @board.enemy_occupied?(dest)
    knight
  end

  def check_moves(row, col, knight)
    check_1(row, col, knight)
    check_2(row, col, knight)
    check_3(row, col, knight)
    check_4(row, col, knight)
    check_5(row, col, knight)
    check_6(row, col, knight)
    check_7(row, col, knight)
    check_8(row, col, knight)
    knight
  end

  def assign_moves(start_pos, knight)
    start_pos = start_pos.reverse # reversed for array
    row = start_pos[0]
    col = start_pos[1]
    check_moves(row, col, knight)
    @moves.map!(&:reverse) # reversed for array
    @start_pos = start_pos
    knight
  end
end
