# frozen_string_literal: true

require_relative 'unit'
require_relative '../../lib/board'

class Pawn < Unit
  attr_reader :board

  def initialize(board)
    super
  end

  def starting_line(start_pos, pawn)
    if !occupied?(one_ahead(start_pos)) && !occupied?(two_ahead(start_pos))
      update_moves([0, 2])
    end
    pawn
  end

  def double_step?(start_pos, end_pos)
    return true if (y_pos(start_pos) - y_pos(end_pos)).abs == 2

    false
  end

  def enemy_pawn?(square)
    return true if @board.enemy_occupied?(square) && square.downcase == 'p'

    false
  end

  def move_pawn(start_pos, end_pos)
    if double_step?(start_pos, end_pos) && en_passant?(end_pos)
      @board.update_en_passant(end_pos)
    end
    @board.move_unit(start_pos, end_pos)
    en_passant_capture?(end_pos) unless @board.en_passant.nil?
    promote(end_pos) if promote?(end_pos)
  end

  def en_passant?(end_pos)
    return true if enemy_pawn?(l_adj(end_pos)) || enemy_pawn?(r_adj(end_pos))

    false
  end

  def first_move?(start_pos)
    return true if @board.turn.zero? && start_pos[1] == 1 ||
                   @board.turn.positive? && start_pos[1] == 6

    false
  end

  def get_x_factor(start_pos)
    if @board.turn.zero?
      @board.en_passant[0] - start_pos[0]
    else
      start_pos[0] - @board.en_passant[0]
    end
  end

  def assign_en_passant(start_pos, pawn)
    x_factor = get_x_factor(start_pos)

    if x_factor == -1
      update_moves([-1, 1])
    else
      update_moves([1, 1])
    end

    pawn
  end

  def en_passant_capture?(end_pos)
    row = @board.en_passant[0] - end_pos[0]
    col = @board.en_passant[1] - end_pos[1]

    unless row.zero? && col.abs == 1
      @board.update_en_passant(nil)
      return false
    end

    @board.en_passant_capture
    true
  end

  def check_one_ahead(start_pos, pawn)
    unless occupied?(one_ahead(start_pos))
      update_moves([0, 1])
      starting_line(start_pos, pawn) if first_move?(start_pos)
    end
    pawn
  end

  def assign_moves(start_pos, pawn)
    check_one_ahead(start_pos, pawn)
    check_diags(start_pos, pawn)
    assign_en_passant(start_pos, pawn) unless @board.en_passant.nil?

    if @board.turn.positive? # inverse moves for black
      pawn.moves.each do |set|
        set.map! { |move| move * -1 }
      end
    end
    pawn
  end

  def promote?(end_pos)
    return true if @board.turn.zero? && end_pos[1] == 7 ||
                   @board.turn.positive? && end_pos[1].zero?

    false
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

# pawn = Pawn.new(Board.new, [0, 5])
# pawn.move_pawn([0, 6], [0, 7])
# pawn.board.display_board
