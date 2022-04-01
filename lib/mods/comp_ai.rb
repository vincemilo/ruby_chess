# frozen_string_literal: true

module CompAI
  def comp_activate
    return if @game_over == true

    p in_check?
    # p @board.w_king_check
    # p @board.b_king_check
    pieces = activation(@board.turn).shuffle
    # hash = {}
    # pieces.each { |piece| hash[piece.start_pos] = piece.moves }
    # p hash
    piece = get_piece(pieces)
    start_pos = piece.start_pos
    moves = piece.moves
    options = create_options(start_pos, moves).shuffle
    end_pos = options[0]
    select_dest(end_pos, start_pos, piece)
  end

  def get_piece(pieces)
    piece = pieces.shift
    piece = pieces.shift while piece.moves.empty?
    piece
  end
end
