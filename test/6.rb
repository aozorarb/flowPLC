# multi window write
require 'curses'
include Curses
init_screen
win = stdscr
subwin = Window.new(10, 0, 5, 0)
Thread.new do
  n = 0
  while true
    win.addstr "#{n} "
    win.deleteln if n % 5 == 0
    n += 1
    sleep 1
    win.refresh
  end
end
Thread.new do
m = 0
  while true
    subwin.addstr "#{m} "
    subwin.deleteln if m % 20 == 0
    m += 1
    sleep 0.5
    subwin.refresh
  end
end

win.getch

at_exit do
  close_screen
end
