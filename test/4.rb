# use color
require 'curses'
include Curses

init_screen
win = stdscr
start_color
attron(Curses::Window::A_STANDOUT)
win.addstr('hello')
attroff(Curses::Window::A_STANDOUT)
win.addstr('world')
win.getch
close_screen
