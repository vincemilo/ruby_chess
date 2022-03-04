# frozen_string_literal: true

module KingCastle
  def check_castle(king)
    return king if rooks_moved?

    assign_castle_moves if castle?
    king
  end

  def rooks_moved?
    return true if (@board.turn.zero? && w_rooks_moved?) ||
                   (@board.turn.positive? && b_rooks_moved?)

    false
  end

  def w_rooks_moved?
    return true if w_r_rook_moved? && w_l_rook_moved?

    false
  end

  def w_r_rook_moved?
    return true if @board.data[0][7] != 'R' ||
                   @board.castle[:w_r_rook].positive?

    false
  end

  def w_l_rook_moved?
    return true if @board.data[0][0] != 'R' ||
                   @board.castle[:w_l_rook].positive?

    false
  end

  def b_rooks_moved?
    return true if b_r_rook_moved? && b_l_rook_moved?

    false
  end

  def b_r_rook_moved?
    return true if @board.data[7][7] != 'r' ||
                   @board.castle[:b_r_rook].positive?

    false
  end

  def b_l_rook_moved?
    return true if @board.data[7][0] != 'r' ||
                   @board.castle[:b_l_rook].positive?

    false
  end

  def w_king_moved?
    return true if @board.data[0][4] != 'K' || @board.castle[:w_king].positive?

    false
  end

  def b_king_moved?
    return true if @board.data[7][4] != 'k' || @board.castle[:b_king].positive?

    false
  end

  def castle?
    return true if w_valid_castle? || b_valid_castle?

    false
  end

  def w_valid_castle?
    return true if @board.turn.zero? && (w_r_castle? || w_l_castle?)

    false
  end

  def b_valid_castle?
    return true if @board.turn.positive? && (b_r_castle? || b_l_castle?)

    false
  end

  def w_r_castle?
    return true if @board.data[0][5] == '0' && @board.data[0][6] == '0'

    false
  end

  def w_l_castle?
    return true if @board.data[0][1] == '0' && @board.data[0][2] == '0' &&
                   @board.data[0][3] == '0'

    false
  end

  def b_r_castle?
    return true if @board.data[7][5] == '0' && @board.data[7][6] == '0'

    false
  end

  def b_l_castle?
    return true if @board.data[7][1] == '0' && @board.data[7][2] == '0' &&
                   @board.data[7][3] == '0'

    false
  end

  def first_move?
    return true if (@board.turn.zero? && !w_king_moved?) ||
                   (@board.turn.positive? && !b_king_moved?)

    false
  end

  def first_move
    @board.update_w_king if @board.turn.zero?
    @board.update_b_king if @board.turn.positive?
  end

  def castle(end_pos)
    if end_pos == [6, 0]
      w_r_castle
    elsif end_pos == [2, 0]
      w_l_castle
    elsif end_pos == [2, 7]
      b_l_castle
    elsif end_pos == [6, 7]
      b_r_castle
    end
  end

  def w_r_castle
    @board.data[0][5] = 'R'
    @board.data[0][7] = '0'
  end

  def w_l_castle
    @board.data[0][3] = 'R'
    @board.data[0][0] = '0'
  end

  def b_l_castle
    @board.data[7][3] = 'r'
    @board.data[7][0] = '0'
  end

  def b_r_castle
    @board.data[7][5] = 'r'
    @board.data[7][7] = '0'
  end

  def assign_castle_moves
    if @board.turn.zero?
      @moves << [2, 0] if w_r_castle?
      @moves << [-2, 0] if w_l_castle?
    else
      @moves << [2, 0] if b_r_castle?
      @moves << [-2, 0] if b_l_castle?
    end
  end
end
