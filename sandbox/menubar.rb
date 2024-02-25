# https://linuxmag.osdn.jp/Japanese/March2002/article233.shtml
# OSDNが死んだのでもう作れません
require 'curses'
Enter = 10
Escape = 27



class Menubar
  def init_curses
    init_screen
    start_color()
    init_pair(1, Curses::COLOR_WHITE, Curses::COLOR_BLUE)
    init_pair(2, Curses::COLOR_BLUE, Curses::COLOR_WHITE)
    init_pair(3, Curses::COLOR_RED, Curses::COLOR_WHITE)
    curs_set 0
    noecho
    keypad(stdscr, true)
  end
end
