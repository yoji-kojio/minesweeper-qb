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

  def create_table
    Matrix.build(row,col) { |r, c| Cell.new(r,c) }
  end

  def set_bombs
    (1..@n_bombs).each do
      r_rand = 0
      c_rand = 0
      loop do
        r_rand = Random.rand(@row)
        c_rand = Random.rand(@col)
        break unless @table[r_rand, c_rand].is_bomb
      end

      @table[r_rand, c_rand].is_bomb = true
      neighbor_bomb_update(r_rand, c_rand)
    end
  end

  def neighbor_bomb_update(b_row, b_col)
    for r in (b_row - 1..b_row + 1)
      for c in (b_col - 1..b_col + 1)
        if r < 0 || r >= @row || c < 0 || c >= @col
          next
        else
          (@table[r, c].is_bomb)? next : (@table[r, c].neighbor_bombs += 1)
        end
      end
    end
  end

  def play(row, col)
    if validate_position(row, col)
      @table[row, col].onclick_action(self)
      @game_over = true if @left_cells.zero?
    else
      puts "Posição inválida\n".colorize(:red)
    end
    @game_over = true if left_cells.zero?
  end

  def flag(row, col)
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


  def validate_entry(row, col, n_bombs)
    raise(ArgumentError, 'Negative row number') unless row > 0
    raise(ArgumentError, 'Negative column number') unless col > 0
    raise(ArgumentError, 'Negative bomb number') unless n_bombs > 0
    raise(ArgumentError, 'Bombs exceed table size') unless n_bombs <= row * col
  end

  def validate_position(r, c)
    (r >= 0 && r < @row && c >= 0 && c < @col)
  end

end