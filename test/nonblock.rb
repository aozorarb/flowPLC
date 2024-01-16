require 'curses'
Curses.init_screen

win = Curses.stdscr

at_exit do
  Curses.close_screen
end
