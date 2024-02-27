require 'curses'

module CLI;end

class CLI::CommandWindow

  def initialize(plc)

    @plc = plc
    b_height, b_width = Curses.lines - 2, 0
    @win = Curses::Window.new(2, 0, b_height, b_width)
    @win.keypad(true)

    # TODO: define in config.yml and load here
    @enter_commands = {
      0x0a => proc {execute_command}
    }
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


  private def type_key(ch)
    # only alphabet and number
    # TODO: accept signs such as '(', ','
    @buff << ch if ch.ord.between?('0'.ord, 'z'.ord)
  end

  private def execute_command

  end

  private def backspace
    return if @buff.empty?
    @buff.chop!
    @win.setpos(@win.cury, @win.curx-1)
    @win.delch
  end


  private def clear_before_cursor
    @win.setpos(1, 0)
    @win.deleteln
    @win.addch ':'
  end

  private def clear_after_cursor
    @win.clrtoeol
  end

  private def cursor_forward
    @win.setpos(@win.cury, (@win.curx + 1).clamp(0, @win.maxx))
  end

  private def cursor_back
    @win.setpos(@win.cury, (@win.curx - 1).clamp(0, @win.maxx))
  end


  def enter_command
    @win.setpos(1, 0)
    @win.deleteln
    @win.addch ':'
    @buff = ''

    while true
      @win.setpos(1, 1)
      @win.addstr(@buff) unless @buff.empty?
      ch = @win.getch 
      # call command
      if @enter_commands.key?(ch)
        @enter_commands[ch].call
      else
        type_key(ch)
      end
    end
  end

end
