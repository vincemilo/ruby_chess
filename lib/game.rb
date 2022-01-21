# frozen_string_literal: true

require_relative 'board'
require_relative 'units/pawn'

class Game
  attr_reader :turn, :board, :game_over

  def initialize(board = Board.new)
    @board = board
    @game_over = false
  end

  def intro
    puts 'Welcome to Chess!'
    while @game_over == false
      @board.display_board
      puts "Player #{@board.turn + 1} please select your piece (i.e. e2):"
      start_pos = move_translator(gets.chomp)
      piece = @board.get_unit(start_pos)

      next unless valid_start?(start_pos, piece)

      unit = select_unit(start_pos, piece)
      options = display_moves(start_pos, unit.moves)
      puts 'Please select their destination (i.e. e4):'
      end_pos = move_translator(gets.chomp)

      next unless valid_end?(end_pos, options)

      select_dest(end_pos, start_pos, unit, options)
    end
  end

  def valid_start?(start_pos, piece)
    return true if valid_selection?(start_pos) && piece != '0' &&
                   !@board.enemy_occupied?(piece)

    invalid_selection
  end

  def invalid_selection
    puts 'Invalid selection, please try again.'
    false
  end

  def valid_end?(end_pos, options)
    return true if valid_selection?(end_pos) && !options.empty?

    invalid_selection
  end

  def valid_selection?(coords)
    return false if coords.length != 2 || @board.off_the_board?(coords)

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
    options.each do |set|
      @board.data[set[1]][set[0]] += '*'
    end
    @board.display_board
    options
  end

  def get_unit_obj(unit)
    if unit.downcase == 'p'
      unit = Pawn.new(@board)
    else
      p 'no'
      @board.display_board
    end
    unit
  end

  def select_dest(end_pos, start_pos, unit, options)
    options.each do |option|
      @board.update_board(option, @board.get_unit(option)[0])
    end
    if unit.class == Pawn
      unit.move_pawn(start_pos, end_pos)
    else
      unit.move_unit(start_pos, end_pos)
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