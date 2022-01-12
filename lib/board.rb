# frozen_string_literal: true

class Board
  attr_accessor :data, :turn, :captured, :en_passant

  def initialize
    @data = Array.new(8) { Array.new(8, '0') }
    @turn = 0
    @captured = [[], []]
    @en_passant = []
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
end

# board = Board.new
# board.display_board
