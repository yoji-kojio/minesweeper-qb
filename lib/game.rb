require_relative 'interact.rb'
require_relative 'printer.rb'
require 'colorize'

include Interact

game = Interact.io_new_game
print_type = 0

# loop action menu until return a game over situation:
# left cells = 0 || click a bomb
loop do
  Interact.show_menu
  option = gets.chomp

  case option
  # click cell
  when 'c'
    Interact.click_cell(game)
  # set flag
  when 'f'
    Interact.put_flag(game)
  # change print view
  when 'p'
    system 'clear'
    print_type += 1
    puts "Visualização do tabuleiro alterada!\n"
  # show table state
  when 't'
    system 'clear'
    if print_type.even?
      Printer.new.print_table(game.board_state)
    else
      PrettyPrinter.new.print_table(game.board_state)
    end
  # x-ray view
  when 'x'
    system 'clear'
    if print_type.even?
      Printer.new.print_table(game.board_state(xray: true))
    else
      PrettyPrinter.new.print_table(game.board_state(xray: true))
    end
  # exit game
  when 'e'
    # exit game implies lost
    break
  else
    puts "Comando inválido! Por favor, digite uma das opções válidas.\n".colorize(:red)
  end

  # after any action, show the board state
  if print_type.even? && option != 't' && option != 'x'
    Printer.new.print_table(game.board_state)
  elsif option != 't' && option != 'x'
    PrettyPrinter.new.print_table(game.board_state)
  end
  # check if a game over situation occurs
  game.still_playing? ? next : break
end

# show this message when game over (victory or lost)
system 'clear'
puts "\t--------------------FIM DE JOGO--------------------
    \t---------------------------------------------------"
if game.victory?
  puts "\t\t\tVocê venceu :D
  \t---------------------------------------------------"
else
  puts "\t\t\tVocê perdeu :(
  \t---------------------------------------------------"
end

puts ''
if print_type.even?
  Printer.new.print_table(game.board_state(xray: true))
else
  PrettyPrinter.new.print_table(game.board_state(xray: true))
end
puts ''
