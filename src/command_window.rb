require 'curses'

class CommandWindow

  def initialize(win)
    begin_y = win.maxy - 3
    @window = win.subwin((win.maxy - begin_y), win.maxx, begin_y, 0)
    @window.box(?|, ?-)
    @window.refresh
  end

end
