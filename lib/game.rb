# frozen_string_literal: true

require_relative 'board'
require_relative 'units/pawn'

class Game
  attr_accessor :turn, :captured

  def initialize
    @turn = 0
    @captured = [[], []]
  end

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
