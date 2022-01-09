# frozen_string_literal: true

require_relative 'unit'

class Pawn < Unit
  attr_accessor :start_pos, :board, :moves

  def initialize(start_pos = nil)
    super
    @moves = [[0, 1]]
  end

  def one_ahead(start_pos)
    if @board.turn.zero?
      @board.data[y_pos(start_pos) + 1][x_pos(start_pos)]
    else
      @board.data[y_pos(start_pos) - 1][x_pos(start_pos)]
    end
  end

  def two_ahead(start_pos)
    if @board.turn.zero?
      @board.data[y_pos(start_pos) + 2][x_pos(start_pos)]
    else
      @board.data[y_pos(start_pos) - 2][x_pos(start_pos)]
    end
  end

  def r_diag(start_pos)
    if @board.turn.zero?
      @board.data[y_pos(start_pos) + 1][x_pos(start_pos) + 1]
    else
      @board.data[y_pos(start_pos) - 1][x_pos(start_pos) + 1]
    end
  end

  def l_diag(start_pos)
    if @board.turn.zero?
      @board.data[y_pos(start_pos) + 1][x_pos(start_pos) - 1]
    else
      @board.data[y_pos(start_pos) - 1][x_pos(start_pos) - 1]
    end
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

  def assign_moves(start_pos, pawn)
    @board.turn.zero? ? white_pawn(start_pos, pawn) : black_pawn(start_pos, pawn)
  end

  def white_pawn(start_pos, pawn)
    starting_line(start_pos, pawn) if start_pos[1] == 1
    check_diags(start_pos, pawn)
    pawn
  end

  def black_pawn(start_pos, pawn)
    starting_line(start_pos, pawn) if start_pos[1] == 6
    check_diags(start_pos, pawn)
    pawn.moves.each do |set|
      set.map! { |move| move * -1 }
    end
    pawn
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

# pawn = Pawn.new
# pawn.board.turn = 1
# pawn.assign_moves([1, 6], pawn)
# p pawn