require 'curses'

module CLI;end

class Curses::Window
  def clear_line(from, len)
    x = curx
    setpos(cury, from)
    len.times do
      delch
    end
    setpos(cury, x)
  end

end



class CLI::CommandWindow

  def initialize(plc)

    @plc = plc
    b_height, b_width = Curses.lines - 2, 0
    @win = Curses::Window.new(2, 0, b_height, b_width)
    @win.keypad(true)

    @x = 0
    # TODO: define in config.yml and load here
    @enter_commands = {
      0x0a => proc {execute_command},
      0x0d => proc {execute_command},
      Curses::Key::HOME => proc {cursor_home},
      0x01 => proc {cursor_home},
      Curses::Key::END => proc {cursor_end},
      0x05 => proc {cursor_end},
      Curses::Key::RIGHT => proc {cursor_forward},
      0x06 => proc {cursor_forward},
      Curses::Key::LEFT => proc {cursor_back},
      0x02 => proc {cursor_back},
      Curses::Key::BACKSPACE => proc {backspace},
      0x07 => proc {backspace},
      0x7f => proc {backspace},
      0x17 => proc {clear_before_word},
      0x15 => proc {clear_before_cursor},
      0x0b => proc {clear_after_cursor},
      0x1b => proc {exit_enter_command}
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
    if ch.ord.between?('0'.ord, 'z'.ord)
      @buff << ch 
      @x += 1
    end
  end


  private def execute_command
    exit_enter_command
  end


  private def backspace
    if @x - 1 >= 0
      @win.setpos(@win.cury, @x)
      @win.delch
      @buff.slice!(@x - 1)
      @x -= 1
    else
      exit_enter_command
    end
  end


  private def exit_enter_command
    @end_enter_command = true
  end


  private def clear_before_cursor
    @win.clear_line(1, @x)
    @buff.slice!(0, @x)
    @x = 0
  end

  private def clear_after_cursor
    @win.clear_line(@x, @buff.size)
    @buff.slice!(@x .. -1)
  end

  private def clear_before_word
    separater_idx = @buff.rindex(' ', @x)
    if separater_idx
      @win.clear_line(separater_idx + 1, @x)
      @buff.slice!(separater_idx + 1, @x)
      @x = separater_idx + 1
    else
      clear_before_cursor
    end
  end

  private def cursor_forward() @x = (@x + 1).clamp(0, @buff.size) end
  private def cursor_back()    @x = (@x - 1).clamp(0, @buff.size) end
  private def cursor_home()    @x = 0 end
  private def cursor_end()     @x = @buff.size end


  def enter_command
    @win.setpos(1, 0)
    @win.clear_line(0, @win.maxx)
    @x = 0
    @win.addch ':'
    @end_enter_command = false
    @buff = ''
    until @end_enter_command
      resize
      @win.setpos(1, 1)
      @win.addstr(@buff)
      @win.setpos(1, @x + 1)

      ch = @win.getch 
      if @enter_commands.key?(ch)
        @enter_commands[ch].call
      else
        type_key(ch)
      end
    end
    @win.clear_line(0, @win.maxx)
  end

end
