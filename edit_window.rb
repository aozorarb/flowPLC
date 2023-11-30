require 'curses'
require_relative 'config'
require_relative 'colors'

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
        @win.erase
        sleep 0.5
        @data.lines.each do |line|
          # indicate on | off, first it is on
          state = true
          Thread.new do
            line.each do |item|
              # item has act method, return connection state
              state = item.act(state)
              # if on(true), attrset {Connect} color
              if state && item.show_state
                @win.attrset Curses.color_pair(Colors::Connect)
              end
              @win.addch item.represent
              @win.attrset Curses::A_NORMAL
            end
            @win.refresh
          end
        end
      end
    end
  end

  def test
    raise 'called test'
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
