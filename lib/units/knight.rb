# frozen_string_literal: true

require_relative 'unit'
require_relative '../../lib/board'

class Knight < Unit
  attr_reader :board

  def initialize(board)
    super
  end

  def check_1(row, col, knight)
    # check up 2 right 1
    return knight if @board.off_the_board?([row + 2, col + 1])

    dest = @board.data[row + 2][col + 1]
    @moves << [1, 2] if dest == '0' || @board.enemy_occupied?(dest)
    knight
  end

  def check_2(row, col, knight)
    # check up 1 right 2
    return knight if @board.off_the_board?([row + 1, col + 2])

    dest = @board.data[row + 1][col + 2]
    @moves << [2, 1] if dest == '0' || @board.enemy_occupied?(dest)
    knight
  end

  def check_3(row, col, knight)
    # check up 2 left 1
    return knight if @board.off_the_board?([row + 2, col - 1])

    dest = @board.data[row + 2][col - 1]
    @moves << [-1, 2] if dest == '0' || @board.enemy_occupied?(dest)
    knight
  end

  def check_4(row, col, knight)
    # check up 1 left 2
    return knight if @board.off_the_board?([row + 1, col - 2])

    dest = @board.data[row + 1][col - 2]
    @moves << [-2, 1] if dest == '0' || @board.enemy_occupied?(dest)
    knight
  end

  def check_5(row, col, knight)
    # check down 1 left 2
    return knight if @board.off_the_board?([row - 1, col - 2])

    dest = @board.data[row - 1][col - 2]
    @moves << [-2, -1] if dest == '0' || @board.enemy_occupied?(dest)
    knight
  end

  def check_6(row, col, knight)
    # check down 2 left 1
    return knight if @board.off_the_board?([row - 2, col - 1])

    dest = @board.data[row - 2][col - 1]
    @moves << [-1, -2] if dest == '0' || @board.enemy_occupied?(dest)
    knight
  end

  def check_7(row, col, knight)
    # check down 2 right 1
    return knight if @board.off_the_board?([row - 2, col + 1])

    dest = @board.data[row - 2][col + 1]
    @moves << [1, -2] if dest == '0' || @board.enemy_occupied?(dest)
    knight
  end

  def check_8(row, col, knight)
    # check up 1 right 2
    return knight if @board.off_the_board?([row - 1, col + 2])

    dest = @board.data[row - 1][col + 2]
    @moves << [2, -1] if dest == '0' || @board.enemy_occupied?(dest)
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
    @start_pos = start_pos
    col = start_pos[0]
    row = start_pos[1]
    check_moves(row, col, knight)
    knight
  end
end
