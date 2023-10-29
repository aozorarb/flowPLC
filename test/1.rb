require 'curses'

include Curses

start_color
init_pair 1, COLOR_YELLOW, COLOR_BLACK
init_pair 2, COLOR_BLACK, COLOR_RED

setpos 0, 0
attrset(color_pair(1))
addstr("warning!")

setpos 1, 0
attrset(color_pair(2))
addstr("ERROR")

setpos 2, 0
attroff A_COLOR
addstr "Color Cancel"
getch
at_exit do
  close_screen
end
