require 'curses'

Curses.init_screen
win = Curses::Window.new(1, 0, 0, 0)
info_win = Curses::Window.new(1, 0, 2, 0)

def ctrl(ch)
  ch.upcase.ord & ~0x40
end

class Curses::Window
  def on_char?
    ch = self.inch.chr
    ch.match?(/[[:alnum:]]/)
  end
end

Curses.noecho
x = 0
win.setpos(0, 0)

while true
  ch = win.getch
  case ch
  when ctrl('J')
    prev_x = win.curx
    buff = ''
    win.setpos(0, 0)
    x = 0
    while x <= win.maxx
      buff << win.inch.chr
      x += 1
      win.setpos(0, x)
    end
    info_win.clear
    info_win.addstr (buff.nil? ? 'not' : buff)
    info_win.refresh
    win.setpos(0, prev_x)
  when ctrl('A')
    win.setpos(0, 0)
  when ctrl('E')
    prev_x = win.curx
    last_x = win.curx
    while win.setpos(0, last_x) && win.on_char?
      last_x += 1
    end
    win.setpos(0, prev_x)
  when ctrl('B')
    win.setpos(0, win.curx - 1)
  when ctrl('F')
    win.setpos(0, win.curx + 1) if win.on_char?
  when 'Q'
    exit(1)
  else
    next if Integer === ch
    win.addch ch 
  end
  win.refresh
end

Curses.close_screen
