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
    #@board.place_pawns
    #@board.place_rooks
    #@board.place_knights
    #@board.place_bishops
    #@board.place_queens
    #@board.place_kings
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
    unit = select_unit(start_pos, piece)
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
    options = []
    moves.each do |set|
      options << [coords[0] + set[0], coords[1] + set[1]]
    end
    mark_options(options)
    @board.display_board
    options
  end

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
    if unit.class == Pawn
      unit.move_pawn(start_pos, end_pos)
    elsif unit.class == King
      unit.move_king(start_pos, end_pos)
    elsif unit.class == Rook
      unit.move_rook(start_pos, end_pos)
    else
      @board.move_unit(start_pos, end_pos)
    end
    check(end_pos, unit) if check?(end_pos, unit)
    @board.update_turn
  end

  def check?(end_pos, unit)
    return true if (@board.turn.zero? && b_king_check?(end_pos, unit)) ||
                   (@board.turn.positive? && w_king_check?(end_pos, unit))

    false
  end

  def in_check?
    return true if (@board.turn.zero? && @board.w_king_check.positive?) ||
                   (@board.turn.positive? && @board.w_king_check.positive?)

    false
  end

  def b_king_check?(end_pos, unit)
    unit.update_moves([])
    unit.assign_moves(end_pos, unit)
    unit.moves.each do |set|
      if @board.data[set[1] + end_pos[1]][set[0] + end_pos[0]] == 'k'
        return true
      end
    end
    false
  end

  def w_king_check?(end_pos, unit)
    unit.update_moves([])
    unit.assign_moves(end_pos, unit)
    unit.moves.each do |set|
      if @board.data[set[1] + end_pos[1]][set[0] + end_pos[0]] == 'K'
        return true
      end
    end
    false
  end

  def check(end_pos, unit)
    if @board.turn.zero? && b_king_check?(end_pos, unit)
      @board.update_b_king_check(end_pos, unit)
    elsif @board.turn.zero? && b_king_check?(end_pos, unit)
      @board.update_w_king_check(end_pos, unit)
    end
  end

  def remove_check?(coords)
    if @board.turn.zero? && @board.w_king_check.positive?
      return true if w_remove?(coords)
    end

    return true if b_remove?(coords)

    false
  end

  def b_remove?(coords)
    while @board.b_king_check? == true
      b_activate
    end
  end

  def b_activate

    @board.data.each_with_index do |row, i|
      p i
      row.each_with_index do |square, j|
        p square
        p j
      end
    end

  end
end

# game = Game.new
# game.intro
# row = 1
# col = 4
# game.board.data[row][col] = 'P'
# game.select_unit([col, row])
# game.board.display_board
