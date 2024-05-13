require 'curses'
require 'logger'
require_relative 'config_parser'
module CLI;end

class CLI::FlowsWindow
  def initialize(plc, exec_command)
    @plc = plc
    @exec_command = exec_command
    @win = Curses::Window.new(Curses.lines - 2, 0, 0, 0)
    @win.nodelay = true
    @x = 0
    @y = 0
  end

  
  private def resize
    @win.move(0, 0)
    @win.resize(Curses.lines - 2, 0)
  end

  def getch() @win.getch end
  
  def move_cursor() @win.setpos(@x, @y) end


  def draw
    resize
    @win.erase
    @win.setpos(0, 0)
    @win.noutrefresh
  end

end

