require 'curses'

class System
  include Curses

  def initialize
    init_screen
    noecho
    at_exit do
      close_screen
    end
    @x, @y = 0, 0
  end

  def loop
    while true
      execute
      status_bar
    end
  end

  private

  def up()   @y -= 1 if (@y-1).between?(0, lines-1) end
  def down() @y += 1 if (@y+1).between?(0, lines-1) end
  def right() @x += 1 if (@x+1).between?(0, cols-1) end
  def left()  @x -= 1 if (@x-1).between?(0, cols-1) end

  def clear_line(line_no)
    setpos line_no, 0
    addstr ' ' * cols
    setpos @y, @x
  end

  def execute
    case getch
    when 'h'
      left
    when 'l'
      right
    when 'j'
      down
    when 'k'
      up
    when 'q'
      exit
    end
    setpos @y, @x
    refresh
  end

  def status_bar
    clear_line lines - 1
    setpos lines - 1, 0
    addstr "#{@y}, #{@x}"
    setpos @y, @x
  end
end

sys = System.new
sys.loop
