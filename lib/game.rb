# frozen_string_literal: true

require_relative 'board'
require_relative 'units/pawn'
require_relative 'units/rook'
require_relative 'units/knight'
require_relative 'units/bishop'
require_relative 'units/queen'
require_relative 'units/king'
require_relative 'mods/game_check'
require_relative 'mods/comp_ai'

class Game
  include GameCheck
  include CompAI
  attr_reader :board, :game_over

  def initialize(board = Board.new)
    @board = board
    @game_over = false
  end

  def intro
    place_pieces
    puts 'Welcome to Chess!'
    selection = nil
    while selection != 1 || selection != 2
      puts 'Press 1 to play vs a human or 2 to play vs the computer:'
      selection = gets.chomp.to_i
      return play_select(1) if selection == 1
      return play_select(2) if selection == 2

      invalid_selection
    end
  end

  def play_select(selection)
    while @game_over == false
      @board.display_board
      puts "Player #{@board.turn + 1} please select your piece (e.g. e2):"
      start_pos = gets.chomp
      next unless check_alpha?(start_pos)

      start_pos = move_translator(start_pos)
      piece = @board.get_unit(start_pos)
      next unless valid_start?(start_pos, piece)

      valid_move = get_end?(start_pos, piece)
      comp_activate if selection == 2 && valid_move
    end
  end

  def check_alpha?(coords)
    return true if ('a'..'h').to_a.include?(coords[0])

    invalid_selection
    false
  end

  def place_pieces
    #@board.place_pawns
    @board.place_rooks
    #@board.place_knights
    #@board.place_bishops
    #@board.place_queens
    @board.place_kings
  end

  def get_end?(start_pos, piece)
    unit = check_unit(start_pos, piece)
    options = display_moves(start_pos, unit.moves)
    end_pos = get_end(options)
    return invalid_selection unless check_alpha?(end_pos)

    end_pos = move_translator(end_pos)
    return invalid_selection if put_into_check?(start_pos, end_pos)
    return false unless valid_end?(end_pos, options)

    select_dest(end_pos, start_pos, unit)
    true
  end

  def get_end(options)
    puts 'Please select their destination (e.g. e4):'
    end_pos = gets.chomp
    unmark_options(options)
    end_pos
  end

  def check_unit(start_pos, piece)
    if in_check?
      select_unit_check(start_pos, piece)
    else
      select_unit(start_pos, piece)
    end
  end

  def valid_start?(start_pos, piece)
    return true if valid_selection?(start_pos) && piece != '0' &&
                   !@board.enemy_occupied?(piece) &&
                   !select_unit(start_pos, piece).moves.empty?

    invalid_selection
    false
  end

  def valid_end?(end_pos, options)
    remove_check if in_check?
    return true if valid_selection?(end_pos) && options.include?(end_pos)

    invalid_selection
    false
  end

  def invalid_selection
    puts 'Invalid selection, please try again.'
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
    unit = if unit.downcase == 'p'
             Pawn.new(@board)
           elsif unit.downcase == 'r'
             Rook.new(@board)
           elsif unit.downcase == 'n'
             Knight.new(@board)
           else
             get_unit_obj_2(unit) # break method up
           end
    unit
  end

  def get_unit_obj_2(unit)
    if unit.downcase == 'b'
      unit = Bishop.new(@board)
    elsif unit.downcase == 'q'
      unit = Queen.new(@board)
    elsif unit.downcase == 'k'
      unit = King.new(@board)
    end
    unit
  end

  def select_dest(end_pos, start_pos, unit)
    move_pieces(start_pos, end_pos, unit)
    move_log(unit.class, coord_translator(end_pos))
    unit = promote(end_pos) if promote?(end_pos, unit.class)
    check(end_pos, unit) if check?(end_pos, unit)
    @board.update_turn
    return unless in_check? && checkmate?(get_moves(activation(@board.turn)))

    checkmate(@board.turn)
  end

  def move_log(unit, end_pos)
    puts "Player #{@board.turn + 1} moves #{unit} to #{end_pos}."
  end

  def coord_translator(coords)
    col = coords[0]
    row = coords[1]
    col_char = (col + 97).chr
    [col_char, row + 1]
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

  def promote?(end_pos, unit)
    return false unless unit == Pawn
    return true if @board.turn.zero? && end_pos[1] == 7 ||
                   @board.turn.positive? && end_pos[1].zero?

    false
  end

  def promote(end_pos)
    col = end_pos[0]
    row = end_pos[1]
    promotion = 0
    promotion = promote_prompt while promotion < 1 || promotion > 4
    activate_promotion(row, col, promotion)
  end

  def promote_prompt
    puts 'Enter promotion number: 1 - Queen, 2 - Rook, 3 - Bishop, 4 - Knight'
    promotion = gets.chomp.to_i
    puts 'Invalid entry, please try again.' if promotion < 1 || promotion > 4
    promotion
  end

  def activate_promotion(row, col, promotion)
    piece = get_promotion(promotion)
    piece = piece.downcase if @board.turn.positive?
    @board.data[row][col] = piece
    get_unit_obj(piece)
  end

  def get_promotion(promotion)
    return 'Q' if promotion == 1
    return 'R' if promotion == 2
    return 'B' if promotion == 3

    'N'
  end
end

game = Game.new
game.intro
# row = 1
# col = 4
# game.board.data[row][col] = 'P'
# game.select_unit([col, row])
# game.board.display_board
