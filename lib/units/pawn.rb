# frozen_string_literal: true

require_relative 'unit'

class Pawn < Unit
  attr_accessor :start_pos, :end_pos, :board, :moves

  def initialize(start_pos = nil, end_pos = nil)
    super
  end

  def starting_line(start_pos, pawn)
    if !occupied?(one_ahead(start_pos)) && !occupied?(two_ahead(start_pos))
      pawn.moves << [0, 2]
    elsif occupied?(one_ahead(start_pos))
      pawn.moves = []
    end
  end

  def check_diags(start_pos, pawn)
    if enemy_occupied?(r_diag(start_pos)) && enemy_occupied?(l_diag(start_pos))
      [[1, 1], [-1, 1]].each { |move| pawn.moves << move }
    elsif enemy_occupied?(r_diag(start_pos))
      pawn.moves << [1, 1]
    elsif enemy_occupied?(l_diag(start_pos))
      pawn.moves << [-1, 1]
    end
  end

  def white_pawn(start_pos, end_pos, pawn)
    pawn.moves << [0, 1]
    if start_pos[1] == 1 || start_pos[1] == 6
      starting_line(start_pos, pawn)
    elsif end_pos[1] == 7 || end_pos[1].zero?
      promote(end_pos)
    end

    check_diags(start_pos, pawn)

    pawn
  end

  def black_pawn(start_pos, end_pos, pawn)
    b_pawn = white_pawn(end_pos, start_pos, pawn)
    b_pawn.moves.each do |set|
      set.map! { |move| move * -1 }
    end
    b_pawn
  end

  def promote(end_pos)
    promotion = 0
    while promotion < 1 || promotion > 4
      puts 'Enter promotion number: 1 - Queen, 2 - Rook, 3 - Bishop, 4 - Knight'
      promotion = gets.chomp.to_i
      puts 'Invalid entry, please try again.' if promotion < 1 || promotion > 4
    end
    # temp
    @board.data[y_pos(end_pos)][x_pos(end_pos)] = promotion.to_s
  end
end

pawn = Pawn.new
pawn.black_pawn([0, 6], [0, 4], pawn)
p pawn.moves
