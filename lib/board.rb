# frozen_string_literal: true

class Board
  attr_reader :data, :turn, :captured, :en_passant, :w_king,
              :b_king, :w_r_rook, :w_l_rook, :b_r_rook, :b_l_rook

  def initialize
    @data = Array.new(8) { Array.new(8, '0') }
    @turn = 0
    @en_passant = nil
    @captured = [[], []]
    @w_king = 0
    @b_king = 0
    @w_r_rook = 0
    @w_l_rook = 0
    @b_r_rook = 0
    @b_l_rook = 0
  end

  def display_board
    display_cols
    display_rows
    display_cols
  end

  def display_cols
    cols = ('a'..'h').to_a.to_s
    puts ' ' + cols
  end

  def display_rows
    nums = (1..8).to_a.reverse
    @data.reverse.each do |row|
      letter = nums.shift.to_s
      puts letter + row.to_s + letter
    end
  end

  def update_board(coords, value)
    row = coords[0]
    col = coords[1]
    @data[col][row] = value
  end

  def update_turn
    @turn += 1
    @turn %= 2
  end

  def update_en_passant(coords)
    @en_passant = coords
  end

  def place_pawns
    @data[1].map! { 'P' }
    @data[6].map! { 'p' }
  end

  def place_rooks
    @data[0][0] = 'R'
    @data[0][7] = 'R'
    @data[7][0] = 'r'
    @data[7][7] = 'r'
  end

  def place_knights
    @data[0][1] = 'N'
    @data[0][6] = 'N'
    @data[7][1] = 'n'
    @data[7][6] = 'n'
  end

  def place_bishops
    @data[0][2] = 'B'
    @data[0][5] = 'B'
    @data[7][2] = 'b'
    @data[7][5] = 'b'
  end

  def place_queens
    @data[0][3] = 'Q'
    @data[7][3] = 'q'
  end

  def place_kings
    @data[0][4] = 'K'
    @data[7][4] = 'k'
  end

  def x_pos(pos)
    # extracts x coordinate
    pos[0]
  end

  def y_pos(pos)
    # extracts y coordinate
    pos[1]
  end

  def get_unit(coords)
    @data[y_pos(coords)][x_pos(coords)]
  end

  def off_the_board?(end_pos)
    return true if end_pos[0].negative? || end_pos[0] > 7 ||
                   end_pos[1].negative? || end_pos[1] > 7

    false
  end

  def enemy_occupied?(piece)
    white_pieces = %w[P R N B Q K]
    black_pieces = white_pieces.map(&:downcase)

    return true if @turn.zero? && black_pieces.any?(piece)

    return true if @turn.positive? && white_pieces.any?(piece)

    false
  end

  def move_unit(start_pos, end_pos)
    return if off_the_board?(end_pos)

    piece = get_unit(start_pos)
    @data[y_pos(start_pos)][x_pos(start_pos)] = '0'
    capture(end_pos) if get_unit(end_pos) != '0'
    @data[y_pos(end_pos)][x_pos(end_pos)] = piece
  end

  def capture(coords)
    piece = get_unit(coords)
    if @turn.zero?
      @captured[0] << piece
    else
      @captured[1] << piece
    end
    puts "Captured pieces: #{@captured}"
  end

  def en_passant_capture
    capture(@en_passant)
    @data[y_pos(@en_passant)][x_pos(@en_passant)] = '0'
    update_en_passant(nil)
  end

  def update_w_king
    return if @w_king.positive?

    @w_king = 1
  end

  def update_b_king
    return if @b_king.positive?

    @b_king = 1
  end

  def update_w_rook(rook)
    if rook == 1
      return if @w_l_rook.positive?

      @w_l_rook = 1
    elsif rook == 2
      return if @w_r_rook.positive?

      @w_r_rook = 1
    end
  end

  def update_b_rook(rook)
    if rook == 1
      return if @b_l_rook.positive?

      @w_l_rook = 1
    elsif rook == 2
      return if @b_r_rook.positive?

      @w_r_rook = 1
    end
  end
end

# board = Board.new
# board.place_queens
# board.display_board
# board.update_turn
# p board.turn
