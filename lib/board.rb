# frozen_string_literal: true

class Board
  attr_reader :data, :turn, :captured, :en_passant

  def initialize
    @data = Array.new(8) { Array.new(8, '0') }
    @turn = 0
    @en_passant = nil
    @captured = [[], []]
  end

  def display_board
    print "#{('a'..'h').to_a} \n"
    @data.reverse.each do |row|
      puts row.to_s
    end
    print "#{('a'..'h').to_a} \n"
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
end

# board = Board.new
# board.display_board
# board.update_turn
# p board.turn
