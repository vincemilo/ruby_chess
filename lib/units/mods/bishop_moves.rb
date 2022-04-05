# frozen_string_literal: true

module BishopMoves
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
end
