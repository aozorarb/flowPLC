# curses color
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

setpos 3, 0
attrset A_NORMAL
addstr "NORMAL"

setpos 4, 0
init_pair 3, COLOR_BLACK, COLOR_WHITE
attrset color_pair(3)
addstr "connecting"
getch

at_exit do
  close_screen
end
