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

  def show_msg(msg, y, x=0)
    size = Config.instance.get('Command_window_size')
    raise 'y must be between from 0 to #{size-1}' unless y.between?(0, size - 1)
    @win.setpos(y, x)
    @win.addstr(msg)
    @win.refresh
  end


  def input_command
    @win.setpos(1, 0)
    show_msg(':', 1)
    buf = ''
    while true
      show_msg(buf, 1, x=1)
      in_ch = @win.getch
      case in_ch
      when 0x1b
        break
      when 0x0a, 0x0c
        enter_command(buf)
      else
        buf << in_ch
      end
    end
  end

  def enter_command(command)

  end

  def clear
    @win.clear
  end

  def input(msg)
  end
end
