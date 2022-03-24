# frozen_string_literal: true

require_relative 'game'

class CompAI < Game
  attr_reader :board

  def initialize(board)
    super
  end

  def comp_activate
    pieces = activation(@board.turn).shuffle
    piece = get_piece(pieces)
    start_pos = piece.start_pos
    moves = piece.moves
    options = create_options(start_pos, moves).shuffle
    end_pos = options[0]
    select_dest(end_pos, start_pos, piece, options)
  end

  def get_piece(pieces)
    piece = pieces.shift
    piece = pieces.shift while piece.moves.empty?
    piece
  end
end

# comp_ai = CompAI.new
# comp_ai.comp_activate
