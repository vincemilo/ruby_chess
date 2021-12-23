# frozen_string_literal: true

class Queen
  attr_reader :moves

  def initialize
    @moves = [-1, 0, 1].repeated_permutation(2).to_a.reject { |pos| pos == [0, 0] }
  end
end

queen = Queen.new
p queen.moves
