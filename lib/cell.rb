require 'colorize'

# Cell class defines the cells property and behavior
class Cell
  attr_accessor :row, :col, :discovered, :flagged, :neighbor_bombs, :is_bomb

  def initialize(row, col)
    @row = row
    @col = col
    @discovered = false
    @flagged = false
    @neighbor_bombs = 0
    @is_bomb = false
  end
  
  # cell click! what happens?!
  def onclick_action(game)
    # imagine a big table...now imagine the expand method...BOOM!
    begin
      if @is_bomb
        @discovered = true
        game.game_over = true
      else
        @discovered = true
        game.left_cells -= 1
        expand_cell(game) if @neighbor_bombs.zero?
        return true
      end
    rescue SystemStackError
      puts 'Boatos de que a pilha não aguentou a expansão...'.colorize(:red)
      abort 'Encerrando o programa...!'.colorize(:red)
    end
  end

  # if cell has no neighbor bombs, check 8-neighborhood cell and expand
  # recursively until reach a cell with neighbor bombs
  def expand_cell(game)
    (row - 1..row + 1).each do |r|
      (col - 1..col + 1).each do |c|
        next unless validate_position(game, r, c)
        cell = game.table[r, c]
        next if cell.discovered || (row == r && col == c)
        cell.discovered = true
        cell.flagged = false
        game.left_cells -= 1
        cell.expand_cell(game) if cell.neighbor_bombs.zero?
      end
    end
  end

  # just validate if cell is inside the table
  def validate_position(game, r, c)
    (r >= 0 && r < game.row && c >= 0 && c < game.col)
  end
end
