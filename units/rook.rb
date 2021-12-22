class Rook
  attr_reader :moves
  
  def initialize
    @moves = [[0, 1], [1, 0], [0, -1], [-1, 0]]
  end
end
  