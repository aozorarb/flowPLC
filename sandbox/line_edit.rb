require 'curses'

Curses.init_screen
win = Curses::Window.new(1, 0, 0, 0)
info_win = Curses::Window.new(100, 0, 2, 0)
at_exit { Curses.close_screen }

win.keypad(true)

def info_win.show_msg(msg)
  msg = msg.to_s
  self.setpos(0, 0)
  self.insertln
  self.addstr(msg)
  self.refresh
end

def ctrl(ch)
  ch.upcase.ord & ~0x40
end

class Curses::Window
  def clear_line(from, len)
    x = curx
    setpos(0, from)
    len.times do
      delch
    end
    setpos(0, x)
  end
end

Curses.noecho
x = 0

buff = ''
while true
  win.setpos(0, 0)
  win.addstr(buff)
  win.setpos(0, x)
  ch = win.getch

  # win.keypad(true) will disturb ctrl('H') (I don't know why).
  # But Curses::Key::BACKSPACE also catch ctrl('H')
  # 127(0x7f) for mac, tabun
  case ch
  when ctrl('H'), Curses::Key::BACKSPACE, 0x7f
    if x - 1 >= 0
      info_win.show_msg('ok')
      win.setpos(0, x-1)
      win.delch
      buff.slice!(x-1)
      x -= 1
    end
  when ctrl('A'), Curses::Key::HOME
    x = 0
  when ctrl('E'), Curses::Key::END
    x = buff.size
  when ctrl('F'), Curses::Key::RIGHT
    x += 1 if x + 1 <= buff.size
  when ctrl('B'), Curses::Key::LEFT
    x -= 1 if x - 1 >= 0
  when ctrl('K')
    win.clear_line(x, buff.size)
    buff.slice!(x .. -1)
  when ctrl('U')
    win.clear_line(0, x)
    buff.slice!(0 ... x)
    x = 0
  when ctrl('W') # does not work for succession whitespacies
    separater_idx = idx = buff.rindex(' ', x)
    if separater_idx
      win.clear_line(separater_idx+1, x)
      buff.slice!(separater_idx+1, x)
      x = separater_idx +  1
    else
      win.clear_line(0, x)
      buff.slice!(0, x)
      x = 0
    end
  when ctrl('J'), ctrl('M')
    if buff == 'quit' || buff == 'exit'
      exit(0)
    end
    info_win.show_msg(buff)
    win.setpos(0, 0)
    win.clrtoeol
    buff.clear
    x = 0
  when ctrl('L')
    win.clear
  else
    unless Integer === ch
      buff.insert(x, ch)
      x += 1
    end
  end
  win.refresh
end

