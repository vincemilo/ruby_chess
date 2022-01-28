# frozen_string_literal: true

def check_d(row, col, _trans)
  options = []
  moves = -1
  while row + moves >= 0
    options << [row + moves, col]
    # return options if enemy_check?(trans, row, moves)

    moves -= 1
  end
  options
end

row = 0
col = 0
trans = %w[R 0 P 0 0 0 p r]
p check_d(col, row, trans)
