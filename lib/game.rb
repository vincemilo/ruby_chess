# frozen_string_literal: true
require_relative 'units/pawn'

class Game
  attr_reader :board, :captured, :turn

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

  def move_unit(start_pos, end_pos, piece)
    return unless valid_move?(start_pos, end_pos, piece)

    @board[x_pos(start_pos)][y_pos(start_pos)] = '0'
    capture(end_pos) if @board[x_pos(end_pos)][y_pos(end_pos)] != '0'
    @board[x_pos(end_pos)][y_pos(end_pos)] = piece
    @turn += 1
    @turn %= 2
  end

  def x_pos(pos)
    # extracts x coordinate (reversed)
    pos[1]
  end

  def y_pos(pos)
    # extracts y coordinate (reversed)
    pos[0]
  end

  def capture(pos)
    piece = @board[x_pos(pos)][y_pos(pos)]
    if @turn.zero?
      @captured[0] << piece
    else
      @captured[1] << piece
    end
    puts "Captured pieces: #{@captured}"
  end

  def valid_move?(start_pos, end_pos, piece)
    return false if end_pos[0].negative? || end_pos[0] > 7 ||
                    end_pos[1].negative? || end_pos[1] > 7

    piece = get_piece(piece, start_pos, end_pos)
    piece.moves.each do |move|
      puts move
    end
    # print "#{piece.moves} \n"
    print "#{start_pos} \n"
    print "#{end_pos} \n"
    true
  end

  def occupied?(square)
    return true unless square == '0'

    false
  end

  def get_piece(piece, start_pos, end_pos)
    if piece == 'P'
      # starting line
      one_ahead = @board[start_pos[1] + 1]
      two_ahead = @board[start_pos[1] + 2]
      if start_pos[1] == 1
        pawn = Pawn.new
        pawn.moves = [[0, 1], [0, 2]]
      end
      pawn
    # elsif piece.downcase == 'r'
    #   rook = Rook.new
    #   rook
    end
  end
end

# game = Game.new
# game.display_board
# game.move_unit([0, 1], [0, 3], 'P')
# puts ''
# game.display_board
# puts ''
# game.move_unit([6, 1], [4, 1], 'p')
# puts ''
# game.display_board
# puts ''
# game.move_unit([3, 0], [4, 1], 'P')
# puts ''
# game.display_board
# game.move_unit([6, 2], [4, 2], 'p')
# puts ''
# game.display_board
# game.move_unit([1, 0], [0, 0], 'P')
# puts ''
# game.display_board