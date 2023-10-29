require 'curses'
require_relative 'config.rb'

class EditWindow

  # someday impletion functions
  # save
  # load
  # scroll

  def initialize win
    @window = win.subwin(win.maxy - Config::Command_window_size, win.maxx, 0, 0)
    @cursor_y = 0
    @cursor_x = 0
    @data = Stage.new

  end

  def move_refresh
    @window.setpos(@cursor_y, @cursor_x)
    @window.refresh
  end

  def getch
    @window.getch
  end

  def input(input_ch)
    @window.insch(input_ch)
    @data.insert_char(@cursor_y, @cursor_x, input_ch)
    @window.setpos(@cursor_y, @cursor_x += 1)
  end

  def delete
  end

  def cursor_down
  end
  def cursor_up
  end
  def cursor_left
  end
  def cursor_right
  end

end
