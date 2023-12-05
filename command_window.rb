require 'curses'
require 'singleton'
require_relative 'config'

class CommandWindow
  include Singleton

  def set_win(win)
    raise 'already set window' unless @win.nil?
    begin_y = win.maxy - Config.instance.get('Command_window_size')
    @win = win.subwin((win.maxy - begin_y), win.maxx, begin_y, 0)
    @win.refresh
  end

  def show_msg(msg, y, x)
    size = Config.instance.get('Command_window_size')
    raise 'y must be between from 0 to #{size-1}' unless y.between?(0, size - 1)
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
