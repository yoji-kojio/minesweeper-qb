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
  
  # what if the cell is clicked
  def onclick_action(game)
    if @flagged
      puts "Posição possui flag!\n".colorize(:yellow)
    elsif @discovered
      puts "Posição já foi descoberta!\n".colorize(:red)
    elsif @is_bomb
      @discovered = true
      game.game_over = true
    else
      @discovered = true
      game.left_cells -= 1
      expand_cell(game) if @neighbor_bombs.zero?
      return true
    end
  end

  # if cell has no neighbor bombs, check 8-neighborhood cell and expand
  # recursively until reach a cell with neighbor bombs
  def expand_cell(game)
    for r in (row - 1..row + 1)
      for c in (col - 1..col + 1)
        next unless validate_position(game, r, c)
        cell = game.table[r, c]
        next if cell.discovered || (row == r && col == c)
        cell.discovered = true
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