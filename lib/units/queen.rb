# frozen_string_literal: true

require_relative 'unit'
require_relative '../../lib/board'

class Queen < Unit
  attr_reader :board

  def initialize(board)
    super
  end

  # rook moves

  def check_vert(start_pos, rook)
    row = start_pos[0]
    col = start_pos[1]
    trans = @board.data.transpose[col]
    u_moves = check_u(row, trans)
    d_moves = check_d(row, trans)
    @moves += u_moves + d_moves
    rook
  end

  def enemy_check?(trans, row, moves)
    return true if @board.enemy_occupied?(trans[row + moves])

    false
  end

  def check_u(row, trans)
    options = []
    moves = 1
    while trans[row + moves] == '0' || @board.enemy_occupied?(trans[row + moves])
      options << [0, moves]
      return options if enemy_check?(trans, row, moves)

      moves += 1
    end
    options
  end

  def check_d(row, trans)
    options = []
    moves = -1
    while row + moves >= 0 && (trans[row + moves] == '0' ||
          @board.enemy_occupied?(trans[row + moves]))
      options << [0, moves]
      return options if enemy_check?(trans, row, moves)

      moves -= 1
    end
    options
  end

  def check_horiz(start_pos, rook)
    row = start_pos[0]
    col = start_pos[1]
    trans = @board.data[row]
    r_moves = check_r(col, trans)
    l_moves = check_l(col, trans)
    @moves += r_moves + l_moves
    rook
  end

  def check_r(col, trans)
    options = []
    moves = 1
    while trans[col + moves] == '0' || @board.enemy_occupied?(trans[col + moves])
      options << [moves, 0]
      return options if enemy_check?(trans, col, moves)

      moves += 1
    end
    options
  end

  def check_l(col, trans)
    options = []
    moves = -1
    while col + moves >= 0 && (trans[col + moves] == '0' ||
          @board.enemy_occupied?(trans[col + moves]))
      options << [moves, 0]
      return options if enemy_check?(trans, col, moves)

      moves -= 1
    end
    options
  end

  # bishop moves

  def check_1(row, col, bishop)
    i = 1

    while !off_the_board?([row + i, col + i]) &&
          (@board.data[row + i][col + i] == '0' ||
           enemy_check_1?(row, col, i))
      @moves << [i, i]
      return bishop if enemy_check_1?(row, col, i)

      i += 1
    end
    bishop
  end

  def enemy_check_1?(row, col, i)
    return true if @board.enemy_occupied?(@board.data[row + i][col + i])

    false
  end

  def check_2(row, col, bishop)
    i = 1

    while !off_the_board?([row - i, col + i]) &&
          (@board.data[row - i][col + i] == '0' ||
           enemy_check_2?(row, col, i))
      @moves << [i, -i]
      return bishop if enemy_check_2?(row, col, i)

      i += 1
    end
    bishop
  end

  def enemy_check_2?(row, col, i)
    return true if @board.enemy_occupied?(@board.data[row - i][col + i])

    false
  end

  def check_3(row, col, bishop)
    i = 1

    while !off_the_board?([row - i, col - i]) &&
          (@board.data[row - i][col - i] == '0' ||
           enemy_check_3?(row, col, i))
      @moves << [-i, -i]
      return bishop if enemy_check_3?(row, col, i)

      i += 1
    end
    bishop
  end

  def enemy_check_3?(row, col, i)
    return true if @board.enemy_occupied?(@board.data[row - i][col - i])

    false
  end

  def check_4(row, col, bishop)
    i = 1

    while !off_the_board?([row + i, col - i]) &&
          (@board.data[row + i][col - i] == '0' ||
           enemy_check_4?(row, col, i))
      @moves << [-i, i]
      return bishop if enemy_check_4?(row, col, i)

      i += 1
    end
    bishop
  end

  def enemy_check_4?(row, col, i)
    return true if @board.enemy_occupied?(@board.data[row + i][col - i])

    false
  end

  def assign_moves(start_pos, queen)
    start_pos = start_pos.reverse # reversed for array
    check_vert(start_pos, queen)
    check_horiz(start_pos, queen)
    row = start_pos[0]
    col = start_pos[1]
    check_1(row, col, queen)
    check_2(row, col, queen)
    check_3(row, col, queen)
    check_4(row, col, queen)
    @start_pos = start_pos
    queen
  end
end
