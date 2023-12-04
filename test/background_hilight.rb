# change color depend on condition
require 'curses'
include Curses
# depend on cond
line = [false, true, true, false]
init_screen
start_color
C_on = 1
C_off = 0
init_pair C_on, COLOR_RED, COLOR_BLACK
init_pair C_off, COLOR_WHITE, COLOR_BLACK
line.each do |l|
  attrset(l ? color_pair(C_on) : color_pair(C_off))
  addch '-'
end
refresh
getch
at_exit do
  close_screen
end
