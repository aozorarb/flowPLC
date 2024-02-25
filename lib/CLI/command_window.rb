require 'curses'

module CLI;end

class CLI::CommandWindow
  def initialize
    b_height, b_width = Curses.lines - 2, 0
    @win = Curses::Window.new(2, 0, b_height, b_width)
  end

  private def resize
    @win.move(Curses.lines - 2, 0)
    @win.resize(2, 0)
  end

  
  def draw
    resize
  end

end
