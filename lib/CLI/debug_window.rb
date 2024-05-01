require 'curses'
require_relative 'config_parser'
module CLI;end

class CLI::DebugWindow
  def initialize(plc)
    @plc = plc
    @win = Curses::Window.new(Curses.lines - 2, Curses.column / 2, 0, 0)
    @win.nodelay = true
  end

  
  private def resize
    @win.move(0, Curses.column / 2)
    @win.resize(Curses.lines - 2, 0)
  end

  def draw
    @win.setpos(0, 0)

  end
  
end

