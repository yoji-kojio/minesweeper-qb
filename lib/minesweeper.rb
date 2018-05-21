require 'matrix'
require 'colorize'
require_relative 'cell.rb'

# class that controls the game rules
class Minesweeper
  attr_accessor :row, :col, :n_bombs, :game_over, :table, :left_cells

  def initialize(row, col, n_bombs)
    validate_entry(row, col, n_bombs)
    @n_bombs = n_bombs
    @row = row
    @col = col
    @left_cells = (row * col) - n_bombs
    @game_over = false
    @table = create_table
    set_bombs
  end

  # build a matrix of cells
  def create_table
    Matrix.build(row, col) { |r, c| Cell.new(r, c) }
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
    (b_row - 1..b_row + 1).each do |r|
      (b_col - 1..b_col + 1).each do |c|
        # avoid cells out of the bounds
        next if r < 0 || r >= @row || c < 0 || c >= @col
        @table[r, c].is_bomb ? next : @table[r, c].neighbor_bombs += 1
      end
    end
  end

  # play/click command
  def play(row, col)
    # just check if click is inside the table
    # and not flagged or discovered
    if validate_position(row, col)
      @table[row, col].onclick_action(self)
      # if there is no cells left, game over! (victory)
      @game_over = true if @left_cells.zero?
      return true
    else
      puts "Posição inválida\n".colorize(:red)
    end
  end

  def flag(row, col)
    # just check if click is inside the table
    if validate_flag_position(row, col)
      cell = @table[row, col]
      if cell.flagged
        cell.flagged = false
        puts "Flag removida\n".colorize(:green)
        return true
      elsif cell.discovered
        puts 'Célula já foi descoberta!'.colorize(:yellow)
      else
        cell.flagged = true
        puts "Flag inserida\n".colorize(:green)
        return true
      end
    else
      puts "Posição inválida\n".colorize(:red)
    end
  end

  def still_playing?
    @game_over ? false : true
  end

  def victory?
    left_cells.zero?
  end
  
  # return the actual situation of the game in char representation:
  # (Flag: F, Undiscovered: #, Bomb: B, Clear: neighbor bomb count)
  def board_state(args = nil)
    Matrix.build(@row, @col) do |r, c|
      if args.nil?
        map_game_state(@table[r, c])
      elsif args[:xray]
        map_xray_game_state(@table[r, c])
      end
    end
  end

  def map_game_state(cell)
    if cell.flagged
      'F'.colorize(:yellow)
    elsif !cell.discovered
      '#'
    elsif cell.is_bomb
      'B'.colorize(:red)
    else
      cell.neighbor_bombs.to_s.colorize(:green)
    end
  end

  # x-ray! just show bombs and neighbor bombs
  def map_xray_game_state(cell)
    if cell.is_bomb
      'B'.colorize(:red)
    else
      cell.neighbor_bombs.to_s.colorize(:green)
    end
  end

  # handling game start invalid arguments
  def validate_entry(row, col, n_bombs)
    begin
      raise ArgumentError.new('Negative row number') unless row > 0
      raise ArgumentError.new('Negative column number') unless col > 0
      raise ArgumentError.new('Negative bomb number') unless n_bombs > 0
      raise ArgumentError.new('Bombs exceed table size') unless n_bombs <= row * col
    rescue
      puts 'Informações inválidas! Não foi possível iniciar o jogo'.colorize(:yellow)
      abort 'Encerrando o jogo...!'.colorize(:yellow)
    end
  end

  # check if the coordinates belongs to table and can be clicked
  def validate_position(r, c)
    cell = @table[r, c]
    (r >= 0 && r < @row && c >= 0 && c < @col && !cell.flagged && !cell.discovered)
  end

  def validate_flag_position(r, c)
    (r >= 0 && r < @row && c >= 0 && c < @col)
  end
end
