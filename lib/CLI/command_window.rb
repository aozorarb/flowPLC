require 'curses'

module CLI;end

class CLI::CommandWindow
  def initialize(plc)
    @plc = plc
    b_height, b_width = Curses.lines - 2, 0
    @win = Curses::Window.new(2, 0, b_height, b_width)
  end

  private def resize
    @win.move(Curses.lines - 2, 0)
    @win.resize(2, 0)
  end

  
  def draw
    resize
    @win.setpos(0, 0)
    # line border
    @win.maxx.times do
      @win.addch '-'
    end
    @win.noutrefresh 
  end


  def execute_command(cmd)

  end

  def enter_command
    @win.setpos(1, 0)
    @win.deleteln
    @win.addch ':'

    buff = ''
    while true
      @win.setpos(1, 1)
      @win.addstr(buff) unless buff.empty?
      ch = @win.getch 
      case ch
      when 0x0a # ctrl-j
        execute_command(buff)
        return
      when 0x1b # ctrl-[, esc
        return
      when 0x08 # ctrl-h
        next if buff.empty?
        buff.chop!
        @win.setpos(@win.cury, @win.curx-1)
        @win.delch
      when 0x15 # ctrl-u
        buff.clear
        @win.setpos(1, 0)
        @win.deleteln
        @win.addch ':'
        # TODO: buff store method(now) is cant move cursour, change curses mode
      when 0x0b # ctrl-k
        buff.slice!(@win.curx-1, -1)
      when 0x07 # ctrl-f
        @win.setpos(@win.curx + 1, @win.cury)
      when 0x02 # ctrl-b
        @win.setpos(@win.curx - 1, @win.cury)
      when 0x01 # ctrl-a
        @win.setpos(1, @win.cury)
      when 0x05 # ctrl-e
        @win.setpos(1, buff.size + 1)
      else
        # only alphabet, number and white space
        buff << ch if '0'.ord <= ch.ord && ch.ord <= 'z'.ord || ch.ord == ' '.ord
      end
    end
  end
end
