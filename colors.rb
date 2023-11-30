require 'curses'

class Colors
  Connect = 1

  def self.init_colors
    Curses.init_pair Connect, Curses::COLOR_BLACK, Curses::COLOR_WHITE
  end
end
