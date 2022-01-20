# frozen_string_literal: true

require_relative 'board'
require_relative 'units/pawn'

class Game
  attr_reader :turn

  def initialize
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

  def select_unit

  end
end

# game = Game.new
# game.intro