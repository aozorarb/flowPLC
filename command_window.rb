require 'curses'
require 'singleton'

class CommandWindow
  include Singleton
  def set_win(win)
    raise 'already set window' unless @win.nil?
    begin_y = win.maxy - 3
    @win = win.subwin((win.maxy - begin_y), win.maxx, begin_y, 0)
    @win.box(?|, ?-)
    @win.refresh
  end

  def show_msg(msg)
    @win.setpos(0, 0)
    @win.addstr(msg)
    @win.refresh
  end
end
