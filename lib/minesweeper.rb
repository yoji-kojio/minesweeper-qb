require 'matrix'
require 'colorize'
require './cell.rb'

class Minesweeper

  attr_accessor :row, :col, :n_bombs, :game_over, :table, :left_cells

  def initialize(row, col, n_bombs)
    validate_entry(row, col, n_bombs)
    @n_bombs = n_bombs
    @row = row
    @col = col
    @left_cells = (row*col) - n_bombs
    @game_over = false
    @table = create_table
    set_bombs
  end

  # build a matrix of cells
  def create_table
    Matrix.build(row,col) { |r, c| Cell.new(r,c) }
  end

  # set bombs randomly on table
  def set_bombs
    (1..@n_bombs).each do
      r_rand = 0
      c_rand = 0
      # still looping bomb coordinates until find a empty space (no bomb)
      loop do
        r_rand = Random.rand(@row)
        c_rand = Random.rand(@col)
        break unless @table[r_rand, c_rand].is_bomb
      end
      #set is_bomb flag and update neighborhood bomb count
      @table[r_rand, c_rand].is_bomb = true
      neighbor_bomb_update(r_rand, c_rand)
    end
  end

  # iterate on cell neighborhood to sum +1 on neighbor_bombs
  def neighbor_bomb_update(b_row, b_col)
    for r in (b_row - 1..b_row + 1)
      for c in (b_col - 1..b_col + 1)
        # avoid cells out of the bounds
        if r < 0 || r >= @row || c < 0 || c >= @col
          next
        else
          (@table[r, c].is_bomb)? next : (@table[r, c].neighbor_bombs += 1)
        end
      end
    end
  end

  # play/click command
  def play(row, col)
    # just check if click is inside the table
    if validate_position(row, col)
      @table[row, col].onclick_action(self)
      @game_over = true if @left_cells.zero?
    else
      puts "Posição inválida\n".colorize(:red)
    end
    # if there is no cells left, game over! (victory)
    @game_over = true if left_cells.zero?
  end

  def flag(row, col)
    # just check if click is inside the table
    if validate_position(row, col)
      cell = @table[row, col]
      if cell.flagged
        cell.flagged = false
        puts "Flag removida".colorize(:green)
        return true
      elsif cell.discovered
        puts "Não é possível colocar flag em células descobertas".colorize(:yellow)
      else
        cell.flagged = true
        puts "Flag inserida".colorize(:green)
      end
    else
      puts "Posição inválida\n".colorize(:red)
    end
  end

  def still_playing?
    @game_over? false : true
  end

  def victory?
    left_cells.zero?
  end
  
  # return the actual situation of the game in characters representation:
  # (Flag: F, Undiscovered: #, Bomb: B, clear: neighbor bomb count)
  def board_state(args = nil)
    game_state = Matrix.build(@row,@col) do |r, c|
      if args == nil
        map_game_state(@table[r, c])
      elsif args[:xray]
        map_xray_game_state(@table[r, c])
      end
    end
  end

  def map_game_state(cell)
    if cell.flagged
      return 'F'.colorize(:yellow)
    elsif !cell.discovered
      return '#'
    elsif cell.is_bomb
      return 'B'.colorize(:red)
    else
      return cell.neighbor_bombs.to_s.colorize(:green)
    end
  end

  def map_xray_game_state(cell)
    if cell.is_bomb
      return 'B'.colorize(:red)
    else
      return cell.neighbor_bombs.to_s.colorize(:red)
    end
  end

  # trying to handle errors... 
  def validate_entry(row, col, n_bombs)
    raise(ArgumentError, 'Negative row number') unless row > 0
    raise(ArgumentError, 'Negative column number') unless col > 0
    raise(ArgumentError, 'Negative bomb number') unless n_bombs > 0
    raise(ArgumentError, 'Bombs exceed table size') unless n_bombs <= row * col
  end

  # check if the coordinates belong to table
  def validate_position(r, c)
    (r >= 0 && r < @row && c >= 0 && c < @col)
  end

end