require 'colorize'

# printer that print meh...
class Printer
  def print_table(game_state)
    (0...game_state.row_count).each do |r|
      (0...game_state.column_count).each do |c|
        print "#{game_state[r, c]} "
      end
      puts ''
    end
  end
end

# printer that print so beautiful :o
class PrettyPrinter
  def print_table(game_state)
    pretty_row = (game_state.row_count * 2) + 1
    pretty_col = (game_state.column_count * 2) + 1
    i = 0
    for r in (0...pretty_row)
      j = 0
      for c in (0...pretty_col)
        if r.zero? || r == pretty_row - 1 || c.zero? || c == pretty_col - 1
          print '@ '.colorize(:blue)
        elsif r.even?
          print '- '.colorize(:blue)
        elsif c.even?
          print '| '.colorize(:blue)
        else
          print "#{game_state[i, j]} "
          j += 1
        end
      end
      puts ''
      i += 1 if r.odd?
    end
  end
end
