class Game
  attr_reader :board

  def initialize
    @board = Array.new(8) { Array.new(8, '0') }
    place_pawns
  end

  def display_board
    print "#{('a'..'h').to_a} \n"
    @board.each do |row|
      puts row.to_s
    end
  end

  def place_pawns
    @board[6].map! { |tile| tile = '1' } 
  end
end

game = Game.new
game.display_board