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

 

  # def capture(pos)
  #   piece = @board[x_pos(pos)][y_pos(pos)]
  #   if @turn.zero?
  #     @captured[0] << piece
  #   else
  #     @captured[1] << piece
  #   end
  #   puts "Captured pieces: #{@captured}"
  # end

end

# board = Board.new
# board.display_board
