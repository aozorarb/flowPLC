require 'curses'
require_relative 'config'

class EditWindow

  # someday impletion functions
  # save
  # load
  # scroll

  def initialize win
    @win = win.subwin(win.maxy - Config::Command_window_size, win.maxx, 0, 0)
    @cursor_y = 0
    @cursor_x = 0
    @data = Stage.new
  end

  def getch
    @win.getch
  end

  def move
    @win.setpos(@cursor_y, @cursor_x)
  end

  def display_loop
    Thread.new do
      while true
        sleep 0.2
        @data.lines.each do |line|
          Thread.new do
            line.each do |item|
              # item has act method
              item.act
            end
          end
        end
      end
    end
  end

  def input(input_ch)
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
