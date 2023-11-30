require 'curses'
require 'singleton'

class CommandWindow
  include Singleton
  Command_line = 3
  def set_win(win)
    raise 'already set window' unless @win.nil?
    begin_y = win.maxy - Command_line
    @win = win.subwin((win.maxy - begin_y), win.maxx, begin_y, 0)
    @win.refresh
  end

  def show_msg(msg, y, x)
    raise 'y must be between from 0 to #{Command_line-1}' unless y.between?(0, Command_line - 1)
    @win.setpos(y, x)
    @win.addstr(msg)
    @win.refresh
  end

  def clear
    @win.clear
  end

  def input(msg)
  end
end
