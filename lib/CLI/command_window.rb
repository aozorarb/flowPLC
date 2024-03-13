require 'curses'
require_relative 'error'
require_relative 'config_parser'


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

  def initialize(plc, exec_command)

    @plc = plc
    @exec_command = exec_command
    b_height, b_width = Curses.lines - 2, 0
    @win = Curses::Window.new(2, 0, b_height, b_width)
    @win.keypad(true)

    @x = 0
    load_key_commands
  end


  private def load_key_commands
    @window_commands = CLI::ConfigParser.instance.commands('command_commands')
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
    # ignore ctrl(ctrl-A, ctrl-[, ...) character
    if String === ch
      @buff << ch 
      @x += 1
    end
  end


  private def execute_command
    @exec_command.call(@buff)
  rescue CLI::InvalidCommandError
    warn "#{@buff} is not command"
  ensure
    exit_enter_command
  end


  private def print(msg)
    px, py = @win.curx, @win.cury
    @win.setpos(1, 0)
    @win.addstr(msg)
    @win.refresh
    @win.setpos(py, px)
  end


  private def color_print(color, msg)
    @win.attron(color)
    print(msg)
    @win.attroff(color)
  end


  private def warn(msg)
    color_print(CLI::Color::Warning, msg)
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

  private def rindex_word(pos)
    # Assume pos is str.size, str is ' str      '
    # word_match_idx is 1              ^  ^    ^
    #                        [[:word:]]+ \s*   \Z
    word_match_idx = @buff[0 .. pos] =~ /[[:word:]]+\s*\Z/
    word_match_idx ? word_match_idx : nil
  end

  private def clear_before_word
    word_idx = rindex_word(@x)
    if word_idx
      @win.clear_line(word_idx + 1, @x)
      @buff.slice!(word_idx, @x)
      @x = word_idx
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
    @win.addch ':'
    @x = 0
    @end_enter_command = false
    @buff = ''
    until @end_enter_command
      resize
      @win.setpos(1, 1)
      @win.addstr(@buff)
      @win.setpos(1, @x + 1)

      ch = @win.getch 
      if @window_commands.key?(ch)
        self.send(@window_commands[ch])
      else
        type_key(ch)
      end
    end
    # @win.clear_line(0, @win.maxx)
  end

end
