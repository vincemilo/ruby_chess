# frozen_string_literal: true

require_relative 'board'
require_relative 'units/pawn'
require_relative 'units/rook'
require_relative 'units/knight'
require_relative 'units/bishop'
require_relative 'units/queen'
require_relative 'units/king'

class Game
  attr_reader :board, :game_over

  def initialize(board = Board.new)
    @board = board
    @game_over = false
    # disable below for testing until fully decoupled
    # @board.place_pawns
    @board.place_rooks
    # @board.place_knights
    # @board.place_bishops
    # @board.place_queens
    @board.place_kings
  end

  def intro
    puts 'Welcome to Chess!'
    while @game_over == false
      @board.display_board
      puts "Player #{@board.turn + 1} please select your piece (i.e. e2):"
      start_pos = move_translator(gets.chomp)
      piece = @board.get_unit(start_pos)
      next unless valid_start?(start_pos, piece)

      get_end(start_pos, piece)
    end
  end

  def get_end(start_pos, piece)
    unit = if in_check?
             select_unit_check(start_pos, piece)
           else
             select_unit(start_pos, piece)
           end
    options = display_moves(start_pos, unit.moves)
    puts 'Please select their destination (i.e. e4):'
    end_pos = move_translator(gets.chomp)
    return unless valid_end?(end_pos, options)

    select_dest(end_pos, start_pos, unit, options)
  end

  def valid_start?(start_pos, piece)
    return true if valid_selection?(start_pos) && piece != '0' &&
                   !@board.enemy_occupied?(piece)

    invalid_selection
  end

  def valid_end?(end_pos, options)
    remove_check if in_check?
    if valid_selection?(end_pos) && options.any? { |moves| moves == end_pos }
      return true
    end

    unmark_options(options)
    invalid_selection
  end

  def invalid_selection
    puts 'Invalid selection, please try again.'
    false
  end

  def valid_selection?(coords)
    return false if coords.length != 2 || @board.off_the_board?(coords)

    return false if in_check? && !remove_check?(coords)

    true
  end

  def move_translator(coords)
    row = coords[1]
    col = coords[0]
    col_num = col.ord - 96
    # subtract nums to accomodate array
    [col_num - 1, row.to_i - 1]
  end

  def select_unit(coords, piece)
    unit = get_unit_obj(piece)
    unit.assign_moves(coords, unit)
    unit
  end

  def display_moves(coords, moves)
    options = create_options(coords, moves)
    mark_options(options)
    @board.display_board
    options
  end

  def create_options(coords, moves)
    options = []
    moves.each do |set|
      options << [coords[0] + set[0], coords[1] + set[1]]
    end
    options
  end

  # potentially add the following 2 to Board
  def mark_options(options)
    options.each do |set|
      @board.data[set[1]][set[0]] += '*'
    end
  end

  def unmark_options(options)
    options.each do |option|
      @board.update_board(option, @board.get_unit(option)[0])
    end
  end

  def get_unit_obj(unit)
    if unit.downcase == 'p'
      unit = Pawn.new(@board)
    elsif unit.downcase == 'r'
      unit = Rook.new(@board)
    elsif unit.downcase == 'n'
      unit = Knight.new(@board)
    elsif unit.downcase == 'b'
      unit = Bishop.new(@board)
    elsif unit.downcase == 'q'
      unit = Queen.new(@board)
    elsif unit.downcase == 'k'
      unit = King.new(@board)
    end
    unit
  end

  def select_dest(end_pos, start_pos, unit, options)
    unmark_options(options)
    move_pieces(start_pos, end_pos, unit)
    check(end_pos, unit) if check?(end_pos, unit)
    @board.update_turn
    return unless in_check? && checkmate?(get_moves(activation(@board.turn)))

    checkmate(@board.turn)
  end

  def move_pieces(start_pos, end_pos, unit)
    if unit.class == Pawn
      unit.move_pawn(start_pos, end_pos)
    elsif unit.class == King
      unit.move_king(start_pos, end_pos)
    elsif unit.class == Rook
      unit.move_rook(start_pos, end_pos)
    else
      @board.move_unit(start_pos, end_pos)
    end
    unit
  end

  def check?(end_pos, unit)
    return true if (@board.turn.zero? && king_check?(end_pos, unit)) ||
                   (@board.turn.positive? && king_check?(end_pos, unit))

    false
  end

  def in_check?
    return true if (@board.turn.zero? && @board.w_king_check[:check].positive?) ||
                   (@board.turn.positive? && @board.b_king_check[:check].positive?)

    false
  end

  def king_check?(end_pos, unit)
    unit.update_moves([])
    unit.assign_moves(end_pos, unit)
    unit.moves.each do |set|
      row = set[1] + end_pos[1]
      col = set[0] + end_pos[0]
      return true if w_king_check?(row, col)

      return true if b_king_check?(row, col)
    end
    false
  end

  def w_king_check?(row, col)
    if @board.data[row][col] == 'K'
      @board.update_w_king_pos([col, row])
      return true
    end

    false
  end

  def b_king_check?(row, col)
    if @board.data[row][col] == 'k'
      @board.update_b_king_pos([col, row])
      return true
    end

    false
  end

  def check(end_pos, unit)
    if @board.turn.zero? && king_check?(end_pos, unit)
      @board.update_b_king_check(end_pos)
    elsif @board.turn.positive? && king_check?(end_pos, unit)
      @board.update_w_king_check(end_pos)
    end
    puts 'Check!'
  end

  def remove_check
    return @board.update_w_king_check([]) if @board.turn.zero?

    @board.update_b_king_check([])
  end

  def select_unit_check(start_pos, piece)
    activate = { start_pos.reverse => piece } # reversed due to #pieces
    piece = pieces(activate)
    mod_unit = filter_moves(piece)
    mod_unit[0] # return only the single unit obj
  end

  def remove_check?(coords)
    if @board.turn.zero? && @board.w_king_check[:check].positive?
      return true if remove?(coords, 0)
    end

    return true if remove?(coords, 1)

    false
  end

  def remove?(coords, turn)
    units = activation(turn)
    piece = nil
    units.any? do |unit|
      piece = unit if unit.start_pos == coords && !unit.moves.empty?
    end
    return true if piece

    false
  end

  def activate(pieces)
    activate = {}
    @board.data.each_with_index do |row, i|
      row.each_with_index do |square, j|
        pieces.any? do |piece|
          activate[[i, j]] = piece if square == piece
        end
      end
    end
    activate
  end

  def pieces(activate)
    pieces = []
    activate.each do |coords, piece|
      coords = coords.reverse # reverse for array input
      pieces << select_unit(coords, piece)
    end
    pieces
  end

  def activation(turn)
    white_pieces = %w[P R N B Q K]
    black_pieces = %w[p r n b q k]
    activate = if turn.zero?
                 activate(white_pieces)
               else
                 activate(black_pieces)
               end
    pieces = pieces(activate)
    p pieces
    pieces = filter_moves(pieces) if in_check?
    p pieces
    pieces
  end

  def get_moves(unit_objs)
    unit_moves = []
    unit_objs.each { |unit| unit_moves << unit.moves }
    flat_arr = unit_moves.flatten
    flat_arr
  end

  def checkmate?(moves)
    return true if moves.empty?

    false
  end

  def checkmate(turn)
    if turn.positive?
      puts 'Black is checkmated, White wins!'
    else
      puts 'White is checkmated, Black wins!'
    end
    @game_over = true
  end

  def filter_moves(pieces)
    if @board.turn.zero?
      block_check(pieces, @board.w_king_check)
    else
      block_check(pieces, @board.b_king_check)
    end
  end

  def block_check(pieces, check_data)
    units = []
    block_moves = attack_direction(check_data[:king_pos], check_data[:attk_pos])
    pieces.each do |piece|
      options = create_options(piece.start_pos, piece.moves)
      piece.update_moves(block_match(piece, options, block_moves))
      units << piece
    end
    units
  end

  def block_match(piece, options, block_moves)
    new_moves = []
    options.each_with_index do |val, i|
      if piece.class == King && block_moves.any?(val)
        piece.moves.delete_at(i)
        return piece.moves
      end

      new_moves << piece.moves[i] if block_moves.any?(val)
    end
    new_moves
  end

  # def put_in_check?(moves)
  #   p moves.sort
  #   p col_attk([5, 0], [5, 7])
  # end

  def attack_direction(king_pos, attk_pos)
    col = (king_pos[0] - attk_pos[0]).abs
    row = (king_pos[1] - attk_pos[1]).abs
    return col_attk(king_pos, attk_pos) if col.zero?

    return row_attk(king_pos, attk_pos) if row.zero?

    diag_attk(king_pos, attk_pos) if row == col
  end

  def col_attk(king_pos, attk_pos)
    block_moves = []
    diff = [king_pos[1], attk_pos[1]].sort
    block_range = (diff[0]...diff[1]).to_a
    block_range.each { |coord| block_moves << [king_pos[0], coord] }
    block_moves
  end

  def row_attk(king_pos, attk_pos)
    block_moves = []
    diff = [king_pos[0], attk_pos[0]].sort
    block_range = (diff[0]...diff[1]).to_a
    block_range.each { |coord| block_moves << [coord, king_pos[1]] }
    block_moves
  end

  def diag_attk(king_pos, attk_pos)
    row_diff = king_pos[1] - attk_pos[1]
    col_diff = king_pos[0] - attk_pos[0]
    if row_diff.positive? && col_diff.positive?
      return r_pos_diag(king_pos, attk_pos)
    end

    if row_diff.positive? && col_diff.negative?
      return l_pos_diag(king_pos, attk_pos)
    end

    if row_diff.negative? && col_diff.negative?
      return l_neg_diag(king_pos, attk_pos)
    end

    r_neg_diag(king_pos, attk_pos) if row_diff.negative? && col_diff.positive?
  end

  def r_pos_diag(king_pos, attk_pos)
    block_moves = []
    until king_pos == attk_pos
      king_pos = [king_pos[0] - 1, king_pos[1] - 1]
      block_moves << king_pos
    end
    block_moves.sort
  end

  def l_pos_diag(king_pos, attk_pos)
    block_moves = []
    until king_pos == attk_pos
      king_pos = [king_pos[0] + 1, king_pos[1] - 1]
      block_moves << king_pos
    end
    block_moves.sort
  end

  def l_neg_diag(king_pos, attk_pos)
    block_moves = []
    until king_pos == attk_pos
      king_pos = [king_pos[0] + 1, king_pos[1] + 1]
      block_moves << king_pos
    end
    block_moves.sort
  end

  def r_neg_diag(king_pos, attk_pos)
    block_moves = []
    until king_pos == attk_pos
      king_pos = [king_pos[0] - 1, king_pos[1] + 1]
      block_moves << king_pos
    end
    block_moves.sort
  end
end

game = Game.new
game.intro
# row = 1
# col = 4
# game.board.data[row][col] = 'P'
# game.select_unit([col, row])
# game.board.display_board
