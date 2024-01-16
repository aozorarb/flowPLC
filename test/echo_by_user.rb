
require 'curses'
Curses.init_screen

win = Curses.stdscr
Curses.noecho

while true
  ch = win.getch
  case ch
  when 'i'
    Curses.echo
  when 0x1b #ctrl-[
    Curses.noecho
    win.ungetch
  end
end
at_exit do
  Curses.close_screen
end
