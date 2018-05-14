require './minesweeper.rb'
require './interact.rb'
require './printer.rb'

include Interact

game = Interact.io_new_game
print_type = 0

loop do
  Interact.show_menu
  option = gets.chomp

  case option
  when 'c'
    system 'clear'
    Interact.click_cell(game)
  when 'f'
    system 'clear'
    Interact.set_flag(game)
  when 'p'
    system 'clear'
    print_type += 1
    puts "Visualização do tabuleiro alterada!"
  when 't'
    system 'clear'
    if print_type%2 == 0
      Printer.new.print_table(game.board_state)
    else
      PrettyPrinter.new.print_table(game.board_state)
    end
  when 'x'
    system 'clear'
    if print_type%2 == 0
      Printer.new.print_table(game.board_state({xray:true}))
    else
      PrettyPrinter.new.print_table(game.board_state({xray:true}))
    end
  when 'e'
    break
  end

  if print_type%2 == 0 && option != 't' && option != 'x'
    Printer.new.print_table(game.board_state)
  elsif option != 't' && option != 'x'
    PrettyPrinter.new.print_table(game.board_state)
  end

  if game.still_playing?
    next
  else
    break
  end
end

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

puts ""
if print_type%2 == 0
  Printer.new.print_table(game.board_state({xray:true}))
else
  PrettyPrinter.new.print_table(game.board_state({xray:true}))
end