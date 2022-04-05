# frozen_string_literal: true

require_relative 'game'

class GameStart
  def intro
    game = Game.new
    game.place_pieces
    puts '♘  Welcome to Chess! ♞'
    selection = 0
    while selection != 1 || selection != 2
      puts 'Press 1 to play vs a human or 2 to play vs the computer:'
      selection = gets.chomp.to_i
      if [1, 2].include?(selection)
        game.update_game_type(selection)
        return game.play_select(selection)
      end

      game.invalid_selection
    end
  end
end

game_start = GameStart.new
game_start.intro
