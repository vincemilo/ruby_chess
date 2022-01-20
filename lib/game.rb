# frozen_string_literal: true

require_relative 'board'
require_relative 'units/pawn'

class Game
  attr_reader :turn, :board

  def initialize(board = Board.new)
    @board = board
    @turn = 0
  end

  def intro
    puts 'Welcome to Chess!'
    puts "Player #{@turn + 1} please select your piece (i.e. e4):"
    p_select = gets.chomp
    move_translator(p_select)
  end

  def move_translator(coords)
    row = coords[0]
    column = coords[1]
    row_num = row.ord - 96
    [row_num.ord, column.to_i]
  end

  def select_unit(coords)
    unit = get_unit_obj(@board.get_unit(coords))
    unit.assign_moves(coords, unit)
    display_moves(coords, unit.moves)
  end

  def display_moves(coords, moves)
    options = []
    moves.each do |set|
      options << [coords[0] + set[0], coords[1] + set[1]]
    end
    options.each do |set|
      @board.data[set[1]][set[0]] = '1'
    end
    @board.display_board
  end

  def get_unit_obj(unit)
    if unit.downcase == 'p'
      unit = Pawn.new(@board)
    end
    unit
  end
end

game = Game.new
row = 1
col = 4
game.board.data[row][col] = 'P'
game.select_unit([col, row])
# game.board.display_board