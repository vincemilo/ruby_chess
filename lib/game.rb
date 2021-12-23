# frozen_string_literal: true

class Game
  attr_reader :board, :captured

  def initialize
    @board = Array.new(8) { Array.new(8, '0') }
    @captured = [[], []]
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
    @board[1].map! { '1' }
    @board[6].map! { '2' }
  end

  def move_unit(start_pos, end_pos, piece)
    return unless valid_move?

    @board[x_pos(start_pos)][y_pos(start_pos)] = '0'
    capture(end_pos) if @board[x_pos(end_pos)][y_pos(end_pos)] != '0'
    @board[x_pos(end_pos)][y_pos(end_pos)] = piece
  end

  def x_pos(pos)
    # extracts x coordinate
    pos[0]
  end

  def y_pos(pos)
    # extracts y coordinate
    pos[1]
  end

  def capture(_pos)
    true
  end

  def valid_move?
    true
  end
end

game = Game.new
game.display_board
game.move_unit([1, 0], [3, 0], '1')
puts ''
game.display_board
puts ''
game.move_unit([6, 1], [4, 1], '2')
puts ''
game.display_board
puts ''
p game.x_pos([1, 0])
p game.y_pos([1, 0])
