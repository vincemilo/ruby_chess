# frozen_string_literal: true

module Unit
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
end
