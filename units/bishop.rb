class Bishop
  attr_reader :moves
  
  def initialize
    @moves = [-1, 1].repeated_permutation(2).to_a
  end
end

bishop = Bishop.new
p bishop.moves