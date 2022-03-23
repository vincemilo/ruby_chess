# frozen_string_literal: true

require_relative 'board'
require 'yaml'
# require_relative 'units/pawn'
# require_relative 'units/rook'
# require_relative 'units/knight'
# require_relative 'units/bishop'
# require_relative 'units/queen'
# require_relative 'units/king'
# require_relative 'mods/game_check'

class SaveLoad
  attr_reader :board, :game_over

  def initialize(board = Board.new)
    @board = board
    @game_over = false
  end

  def to_yaml
    @board.display_board
    yaml = YAML.dump(self)
    File.open('save_game.yaml', 'w+') { |e| e.write yaml }
    puts 'Game saved'
    abort
  end

  def from_yaml
    save_game = File.open('save_game.yaml')
    @load = YAML.load(save_game)
    puts 'Game loaded'
    p @load
  end
end

save_load = SaveLoad.new
#save_load.to_yaml
save_load.from_yaml
