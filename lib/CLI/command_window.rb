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


  def keep_pos(&block)
    px = curx
    py = cury
    block.call
    setpos(py, px)
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
  rescue NoMethodError
    warn "Not a command: #{@buff}"
  rescue ArgumentError
    /given (?<given>\d+), expected (?<expected>\d+)/ =~ $!.full_message
    # Why cannot use 'if' after expression
    if given.nil? || expected.nil?
      raise $!
    end
    warn "wrong number of argments: expected #{expected} but given #{given}"
  ensure
    exit_enter_command
  end


  def print(msg)
    @win.keep_pos do
      @win.setpos(1, 0)
      @win.clear_line(1, @win.maxx)
      @win.addstr(msg)
      @win.refresh
    end
  end

  def print_at(msg, y, x)
    @win.keep_pos do
      @win.setpos(y, x)
      @win.clear_line(y, @win.maxx)
      @win.addstr(msg)
      @win.refresh
    end
  end

  def print_no_refresh(msg)
    @win.keep_pos do
      @win.clear_line(1, @win.maxx)
      @win.addstr(msg)
      @win.noutrefresh
    end
  end


  def color_print(color, msg)
    @win.attron(color)
    print(msg)
    @win.attroff(color)
  end


  def warn(msg)
    color_print(CLI::Color::Warning, msg)
  end

  def sleep_until_key_type
    @win.getch
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


  private def change_window_size(h, w, &block)
    wh = Curses.lines - h
    ww = w
    @win.move(wh, ww)
    @win.resize(h, w)

    block.call
    resize
  end


  def expand_print(str)
    logger = Logger.new('log/command_window.log')
    need_line = (str.size + 1) / @win.maxx
    @win.keep_pos do
      change_window_size(need_line, 0) do
        @win.clear
        print_at(str, 0, 0)
        sleep_until_key_type
        @win.clear
      end
    end
  end
end
