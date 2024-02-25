require 'curses'

module CLI;end

class CLI::FlowsWindow
  def initialize
    @win = Curses::Window.new(Curses.lines - 2, 0, 0, 0)
  end

  
  def resize
    @win.move(0, 0)
    @win.resize(Curses.lines - 2, 0)
  end

end

