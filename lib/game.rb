# frozen_string_literal: true

require_relative 'units/pawn'

class Game
  attr_accessor :board, :captured, :turn

  def initialize
    @board = Array.new(8) { Array.new(8, '0') }
    @captured = [[], []]
    @turn = 0
    place_pawns
  end

  def display_board
    print "#{('a'..'h').to_a} \n"
    @board.reverse.each do |row|
      puts row.to_s
    end
    print "#{('a'..'h').to_a} \n"
  end

  def place_pawns
    @board[1].map! { 'P' }
    @board[6].map! { 'p' }
  end

  # def move_unit(start_pos, end_pos, piece)
  #   return unless valid_move?(start_pos, end_pos, piece)

  #   @board[x_pos(start_pos)][y_pos(start_pos)] = '0'
  #   capture(end_pos) if @board[x_pos(end_pos)][y_pos(end_pos)] != '0'
  #   @board[x_pos(end_pos)][y_pos(end_pos)] = piece
  #   @turn += 1
  #   @turn %= 2
  # end

  def x_pos(pos)
    # extracts x coordinate
    pos[0]
  end

  def y_pos(pos)
    # extracts y coordinate
    pos[1]
  end

  # def capture(pos)
  #   piece = @board[x_pos(pos)][y_pos(pos)]
  #   if @turn.zero?
  #     @captured[0] << piece
  #   else
  #     @captured[1] << piece
  #   end
  #   puts "Captured pieces: #{@captured}"
  # end

  def valid_move?(_start_pos, end_pos, _piece)
    return false if end_pos[0].negative? || end_pos[0] > 7 ||
                    end_pos[1].negative? || end_pos[1] > 7

    # piece = get_piece(piece)
    # piece.moves.each do |move|
    #   puts move
    # end
    # # print "#{piece.moves} \n"
    # print "#{start_pos} \n"
    # print "#{end_pos} \n"
    true
  end

  def occupied?(square)
    return true unless square == '0'

    false
  end

  def enemy_occupied?(piece)
    white_pieces = %w[P R N B Q K]
    black_pieces = white_pieces.map(&:downcase)

    return true if @turn.zero? && black_pieces.any?(piece)

    return true if @turn.positive? && white_pieces.any?(piece)

    false
  end

  def get_piece(square)
    @board[y_pos(square)][x_pos(square)]
  end

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

  def starting_line(start_pos, pawn)
    if !occupied?(one_ahead(start_pos)) && !occupied?(two_ahead(start_pos))
      pawn.moves << [0, 2]
    elsif occupied?(one_ahead(start_pos))
      pawn.moves = []
    end
  end

  def check_diags(start_pos, pawn)
    if enemy_occupied?(r_diag(start_pos)) && enemy_occupied?(l_diag(start_pos))
      [[1, 1], [-1, 1]].each { |move| pawn.moves << move }
    elsif enemy_occupied?(r_diag(start_pos))
      pawn.moves << [1, 1]
    elsif enemy_occupied?(l_diag(start_pos))
      pawn.moves << [-1, 1]
    end
  end

  def white_pawn(start_pos, end_pos)
    pawn = Pawn.new

    if start_pos[1] == 1
      starting_line(start_pos, pawn)
    elsif end_pos[1] == 7
      promote(end_pos)
    end

    check_diags(start_pos, pawn)

    pawn
  end
end

# game = Game.new
# game.display_board
