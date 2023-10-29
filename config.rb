require 'curses'

module Config

  Command_window_size = 2

  class Colors

    Edit_window = 0
    Command_window = 1

    def self.init_colors
      Curses.init_pair(Edit_window, Curses::COLOR_YELLOW, Curses::COLOR_BLACK)
      Curses.init_pair(Command_window, Curses::COLOR_GREEN, Curses::COLOR_WHITE)
    end
  end
end
