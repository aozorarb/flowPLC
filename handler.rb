require_relative 'edit_window.rb'

class Handler
  def execute(win, in_ch)
    case in_ch
    when ?i
      return EditHandler.new
    when ?:
      CommandHandler.new
    when ?x
      win.delete
    when ?j
      win.cursor_down
    when ?k
      win.cursor_up
    when ?h
      win.cursor_left
    when ?l
      win.cursor_right
    when ?q
      exit
    end
    self
  end
end

class EditHandler
  def execute(win, in_ch)
    case in_ch
    when 0x1b
      return Handler.new
    else
      win.input(in_ch)
    end
  self
  end
end

class CommandHandler
  def execute(win, in_ch)
    @buff = ''
    case in_ch
    when 0x1b # ^[
      return Handler.new
    when 0x0a, 0x0e# ^J, ^M
      enter_command
    else
      @buff << in_ch
    end
  self
  end

  def enter_command
    case @buff
    # TODO
    when 'q'
      puts "quit"
      exit
    end
    @buff.clear
  end
end
