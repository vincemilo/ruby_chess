# frozen_string_literal: true

require_relative 'unit'
require_relative '../../lib/board'

class Pawn < Unit
  attr_reader :board

  def initialize(board)
    super
  end

  def assign_moves(start_pos, pawn)
    @start_pos = start_pos
    check_one_ahead(start_pos, pawn)
    check_diags(start_pos, pawn)
    assign_en_passant(start_pos, pawn) unless @board.en_passant.empty?

    if @board.turn.positive? # inverse moves for black
      pawn.moves.each do |set|
        set.map! { |move| move * -1 }
      end
    end
    pawn
  end
end

# pawn = Pawn.new(Board.new, [0, 5])
# pawn.move_pawn([0, 6], [0, 7])
# pawn.board.display_board
# puts '♔'
