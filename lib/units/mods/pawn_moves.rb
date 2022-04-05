# frozen_string_literal: true

module PawnMoves

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

  def r_diag_occupied?(right, left)
    return true if right && @board.turn.zero? || left && @board.turn.positive?

    false
  end

  def l_diag_occupied?(right, left)
    return true if left && @board.turn.zero? || right && @board.turn.positive?

    false
  end

  def l_adj(start_pos)
    @board.data[y_pos(start_pos)][x_pos(start_pos) - 1]
  end

  def r_adj(start_pos)
    @board.data[y_pos(start_pos)][x_pos(start_pos) + 1]
  end

  def check_diags(start_pos, unit)
    right = @board.enemy_occupied?(r_diag(start_pos))
    left = @board.enemy_occupied?(l_diag(start_pos))

    if right && left
      [[1, 1], [-1, 1]].each { |move| unit.moves << move }
    elsif r_diag_occupied?(right, left)
      unit.moves << [1, 1]
    elsif l_diag_occupied?(right, left)
      unit.moves << [-1, 1]
    end
    unit
  end

  def double_step?(start_pos, end_pos)
    return true if (y_pos(start_pos) - y_pos(end_pos)).abs == 2

    false
  end

  def enemy_pawn?(square)
    return true if @board.enemy_occupied?(square) && square.downcase == 'p'

    false
  end

  def move_pawn(start_pos, end_pos)
    if double_step?(start_pos, end_pos) && en_passant?(end_pos)
      @board.update_en_passant(end_pos)
    end
    @board.move_unit(start_pos, end_pos)
    en_passant_capture?(end_pos) unless @board.en_passant.empty?
  end

  def en_passant?(end_pos)
    return true if enemy_pawn?(l_adj(end_pos)) || enemy_pawn?(r_adj(end_pos))

    false
  end

  def first_move?(start_pos)
    return true if @board.turn.zero? && start_pos[1] == 1 ||
                   @board.turn.positive? && start_pos[1] == 6

    false
  end

  def get_x_factor(start_pos)
    p start_pos
    if @board.turn.zero?
      @board.en_passant[0] - start_pos[0]
    else
      start_pos[0] - @board.en_passant[0]
    end
  end

  def assign_en_passant(start_pos, pawn)
    x_factor = get_x_factor(start_pos)

    @moves << if x_factor == -1
                [-1, 1]
              else
                [1, 1]
              end
    pawn
  end

  def en_passant_capture?(end_pos)
    row = @board.en_passant[0] - end_pos[0]
    col = @board.en_passant[1] - end_pos[1]

    unless row.zero? && col.abs == 1
      @board.update_en_passant([])
      return false
    end

    @board.en_passant_capture
    true
  end

  def starting_line(start_pos, pawn)
    if !occupied?(one_ahead(start_pos)) && !occupied?(two_ahead(start_pos))
      @moves << [0, 2]
    end
    pawn
  end

  def check_one_ahead(start_pos, pawn)
    unless occupied?(one_ahead(start_pos))
      @moves << [0, 1]
      starting_line(start_pos, pawn) if first_move?(start_pos)
    end
    pawn
  end
end
