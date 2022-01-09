# frozen_string_literal: true

class Board
  attr_accessor :data, :turn, :captured

  def initialize
    @data = Array.new(8) { Array.new(8, '0') }
    @turn = 0
    @captured = [[], []]
    place_pawns
  end

  def display_board
    print "#{('a'..'h').to_a} \n"
    @data.reverse.each do |row|
      puts row.to_s
    end
    print "#{('a'..'h').to_a} \n"
  end

  def place_pawns
    @data[1].map! { 'P' }
    @data[6].map! { 'p' }
  end

  # def move_unit(start_pos, end_pos, piece)
  #   return unless valid_move?(start_pos, end_pos, piece)

  #   @board[x_pos(start_pos)][y_pos(start_pos)] = '0'
  #   capture(end_pos) if @board[x_pos(end_pos)][y_pos(end_pos)] != '0'
  #   @board[x_pos(end_pos)][y_pos(end_pos)] = piece
  #   @turn += 1
  #   @turn %= 2
  # end

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
end

# board = Board.new
# board.display_board
