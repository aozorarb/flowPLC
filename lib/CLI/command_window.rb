require 'curses'
require_relative 'config_parser'

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
    load_key_commands
  end


  def load_key_commands
    @window_commands = ConfigParser.instance.commands('command_commands')
  end


  def resize
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


  def type_key(ch)
    # ignore ctrl(ctrl-A, ctrl-[, ...) character
    if String === ch
      @buff << ch 
      @x += 1
    end
  end


   def execute_command
    exit_enter_command
  end


   def backspace
    if @x - 1 >= 0
      @win.setpos(@win.cury, @x)
      @win.delch
      @buff.slice!(@x - 1)
      @x -= 1
    else
      exit_enter_command
    end
  end


   def exit_enter_command
    @end_enter_command = true
  end


   def clear_before_cursor
    @win.clear_line(1, @x)
    @buff.slice!(0, @x)
    @x = 0
  end

   def clear_after_cursor
    @win.clear_line(@x, @buff.size)
    @buff.slice!(@x .. -1)
  end

   def rindex_word(pos)
    # Assume pos is str.size, str is ' str      '
    # word_match_idx is 1              ^  ^    ^
    #                        [[:word:]]+ \s*   \Z
    word_match_idx = @buff[0 .. pos] =~ /[[:word:]]+\s*\Z/
    word_match_idx ? word_match_idx : nil
  end

   def clear_before_word
    word_idx = rindex_word(@x)
    if word_idx
      @win.clear_line(word_idx + 1, @x)
      @buff.slice!(word_idx, @x)
      @x = word_idx
    else
      clear_before_cursor
    end
  end

   def cursor_forward() @x = (@x + 1).clamp(0, @buff.size) end
   def cursor_back()    @x = (@x - 1).clamp(0, @buff.size) end
   def cursor_home()    @x = 0 end
   def cursor_end()     @x = @buff.size end


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
        @window_commands[ch].call(self)
      else
        type_key(ch)
      end
    end
    @win.clear_line(0, @win.maxx)
  end

end
