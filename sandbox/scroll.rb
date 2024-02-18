require 'curses'
Curses.init_screen

win = Curses.stdscr
status = win.subwin(1, 0, win.maxy-1, 0)
Curses.noecho
while true
  ch = win.getch
  case ch
  when 'i'
    status.clear
    status << "#{win.curx}, #{win.cury}"
    status.refresh
  when 'o'
    win.insertln
  when 'O'
    win.deleteln
  when 'h'
    win.setpos(win.begx-1, win.cury)
  when 'j'
    win.setpos(win.curx, win.cury+1)
  when 'k'
    win.setpos(win.curx, win.cury-1)
  when 'l'
    win.setpos(win.curx+1, win.cury)
  when 'q'
    exit
  end
  win.refresh
end
at_exit do
  Curses.close_screen
end

