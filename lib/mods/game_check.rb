# frozen_string_literal: true

module GameCheck
  def check?(end_pos, unit)
    return true if (@board.turn.zero? && king_check?(end_pos, unit)) ||
                   (@board.turn.positive? && king_check?(end_pos, unit))

    false
  end

  def in_check?
    return true if (@board.turn.zero? && @board.w_king_check[:check].positive?) ||
                   (@board.turn.positive? && @board.b_king_check[:check].positive?)

    false
  end

  def king_check?(end_pos, unit)
    unit.update_moves([])
    unit.assign_moves(end_pos, unit)
    unit.moves.each do |set|
      row = set[1] + end_pos[1]
      col = set[0] + end_pos[0]
      return true if w_king_check?(row, col)

      return true if b_king_check?(row, col)
    end
    false
  end

  def w_king_check?(row, col)
    if @board.data[row][col] == 'K'
      @board.update_w_king_pos([col, row])
      return true
    end

    false
  end

  def b_king_check?(row, col)
    if @board.data[row][col] == 'k'
      @board.update_b_king_pos([col, row])
      return true
    end

    false
  end

  def check(end_pos, unit)
    if @board.turn.zero? && king_check?(end_pos, unit)
      @board.update_b_king_check(end_pos)
    elsif @board.turn.positive? && king_check?(end_pos, unit)
      @board.update_w_king_check(end_pos)
    end
    puts 'Check!'
  end

  def remove_check
    return @board.update_w_king_check([]) if @board.turn.zero?

    @board.update_b_king_check([])
  end

  def select_unit_check(start_pos, piece)
    activate = { start_pos.reverse => piece } # reversed due to #pieces
    piece = pieces(activate)
    mod_unit = filter_moves(piece)
    mod_unit[0] # return only the single unit obj
  end

  def remove_check?(coords)
    if @board.turn.zero? && @board.w_king_check[:check].positive?
      return true if remove?(coords, 0)
    end
    return true if remove?(coords, 1)

    false
  end

  def remove?(coords, turn)
    units = activation(turn)
    piece = nil
    units.any? do |unit|
      piece = unit if unit.start_pos == coords && !unit.moves.empty?
    end
    return true if piece

    false
  end

  def activate(pieces)
    activate = {}
    @board.data.each_with_index do |row, i|
      row.each_with_index do |square, j|
        pieces.any? do |piece|
          activate[[i, j]] = piece if square == piece
        end
      end
    end
    activate
  end

  def pieces(activate)
    # runs #select_unit on activated pieces to assign moves
    pieces = []
    activate.each do |coords, piece|
      coords = coords.reverse # reverse for array input
      pieces << select_unit(coords, piece)
    end
    pieces
  end

  def activation(turn)
    white_pieces = %w[P R N B Q K]
    black_pieces = %w[p r n b q k]
    activate = if turn.zero?
                 activate(white_pieces)
               else
                 activate(black_pieces)
               end
    pieces = pieces(activate)
    pieces = filter_moves(pieces) if in_check?
    pieces
  end

  def get_moves(unit_objs)
    unit_moves = []
    unit_objs.each { |unit| unit_moves << unit.moves }
    flat_arr = unit_moves.flatten
    flat_arr
  end

  def checkmate?(moves)
    return true if moves.empty?

    false
  end

  def checkmate(turn)
    if turn.positive?
      puts 'Black is checkmated, White wins!'
    else
      puts 'White is checkmated, Black wins!'
    end
    @game_over = true
  end

  def filter_moves(pieces)
    if @board.turn.zero?
      block_check(pieces, @board.w_king_check)
    else
      block_check(pieces, @board.b_king_check)
    end
  end

  def block_check(pieces, check_data)
    # checks which squares would intercept check to king and matches them with
    # available moves
    units = []
    block_moves = attack_direction(check_data[:king_pos], check_data[:attk_pos])
    pieces.each do |piece|
      options = create_options(piece.start_pos, piece.moves)
      piece.update_moves(block_match(piece, options, block_moves))
      units << piece
    end
    units
  end

  def block_match(piece, options, block_moves)
    new_moves = []
    options.each_with_index do |val, i|
      return piece.moves if piece.class == King

      new_moves << piece.moves[i] if block_moves.any?(val)
    end
    new_moves
  end

  def attack_direction(king_pos, attk_pos)
    col = (king_pos[0] - attk_pos[0]).abs
    row = (king_pos[1] - attk_pos[1]).abs
    return col_attk(king_pos, attk_pos) if col.zero?

    return row_attk(king_pos, attk_pos) if row.zero?

    diag_attk(king_pos, attk_pos) if row == col
  end

  def col_attk(king_pos, attk_pos)
    block_moves = []
    diff = [king_pos[1], attk_pos[1]].sort
    block_range = (diff[0]...diff[1]).to_a
    block_range.each { |coord| block_moves << [king_pos[0], coord] }
    block_moves
  end

  def row_attk(king_pos, attk_pos)
    block_moves = []
    diff = [king_pos[0], attk_pos[0]].sort
    block_range = (diff[0]...diff[1]).to_a
    block_range.each { |coord| block_moves << [coord, king_pos[1]] }
    block_moves
  end

  def diag_attk(king_pos, attk_pos)
    row_diff = king_pos[1] - attk_pos[1]
    col_diff = king_pos[0] - attk_pos[0]
    if row_diff.positive? && col_diff.positive?
      return r_pos_diag(king_pos, attk_pos)
    end

    if row_diff.positive? && col_diff.negative?
      return l_pos_diag(king_pos, attk_pos)
    end

    if row_diff.negative? && col_diff.negative?
      return l_neg_diag(king_pos, attk_pos)
    end

    r_neg_diag(king_pos, attk_pos) if row_diff.negative? && col_diff.positive?
  end

  def r_pos_diag(king_pos, attk_pos)
    block_moves = []
    until king_pos == attk_pos
      king_pos = [king_pos[0] - 1, king_pos[1] - 1]
      block_moves << king_pos
    end
    block_moves.sort
  end

  def l_pos_diag(king_pos, attk_pos)
    block_moves = []
    until king_pos == attk_pos
      king_pos = [king_pos[0] + 1, king_pos[1] - 1]
      block_moves << king_pos
    end
    block_moves.sort
  end

  def l_neg_diag(king_pos, attk_pos)
    block_moves = []
    until king_pos == attk_pos
      king_pos = [king_pos[0] + 1, king_pos[1] + 1]
      block_moves << king_pos
    end
    block_moves.sort
  end

  def r_neg_diag(king_pos, attk_pos)
    block_moves = []
    until king_pos == attk_pos
      king_pos = [king_pos[0] - 1, king_pos[1] + 1]
      block_moves << king_pos
    end
    block_moves.sort
  end

  def put_into_check?(start_pos, end_pos)
    board_copy = board_copy(start_pos, end_pos)
    king = King.new(board_copy)
    king_start_pos = @board.w_king_check[:king_pos]
    king_col = king_start_pos[0]
    king_row = king_start_pos[1]
    return true if king.hostile_col?(king_col, king_row, board_copy)
    return true if king.hostile_row?(king_col, king_row, board_copy)
    return true if king.hostile_pos_diag?(king_col, king_row, board_copy)
    return true if king.hostile_neg_diag?(king_col, king_row, board_copy)

    false
  end

  def board_copy(start_pos, end_pos)
    # creates a modified Board instance to see if check would occur
    col = start_pos[0]
    row = start_pos[1]
    new_col = end_pos[0]
    new_row = end_pos[1]
    unit = @board.get_unit(start_pos)
    board_copy = Board.new(@board.data)
    board_copy.data[row][col] = '0'
    board_copy.data[new_row][new_col] = unit
    board_copy
  end
end
