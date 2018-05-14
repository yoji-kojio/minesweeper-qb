require './minesweeper.rb'
require 'pry'

module Interact

  # action menu
  def show_menu
    puts "\t--------------------MENU--------------------
    (c) Escolher Célula\t\t(f) Inserir/Remover Bandeira\n
    (t) Mostrar o Tabuleiro\t(x) X-Ray\n
    (p) Trocar Visualização\t(e) Sair do Jogo\n
    \t--------------------------------------------"
    print "\nAção: "
  end

  # get input to start a new game and return a Minesweeper object
  def io_new_game
    puts 'Bem vindo ao Minesweeper! Comece fornecendo as configurações do jogo!'
    print 'Número de linhas do tabuleiro: '
    io_rows = gets.to_i
    print 'Número de colunas do tabuleiro: '
    io_cols = gets.to_i
    print 'Número de bombas do tabuleiro: '
    io_bombs = gets.to_i

    Minesweeper.new(io_rows, io_cols, io_bombs)
  end

  # get click coordinates
  def click_cell(game)
    puts 'Digite as coordenadas de linha e coluna, respectivamente. Ex: 1 2'
    r, c = gets.split.map(&:to_i)
    puts ""
    (r.nil? || c.nil?)? (puts "Argumentos inválidos!".colorize(:red)) : (game.play(r-1, c-1))
  end

  # get flag coordinates
  def set_flag(game)
    puts 'Digite as coordenadas de linha e coluna, respectivamente. Ex: 1 2'
    r, c = gets.split.map(&:to_i)
    puts ""
    (r.nil? || c.nil?)? (puts "Argumentos inválidos!\n".colorize(:red)) : (game.flag(r-1, c-1))
  end

end