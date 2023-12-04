require 'curses'

include Curses

init_screen
addstr 'test'
getch

at_exit do
  close_screen
end
