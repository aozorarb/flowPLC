require_relative 'edit_window.rb'

class Handler
  def execute(win, in_ch)
    case in_ch
    when ?i
      return EditHandler.new
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
  end
end

class CommandHandler
  def execute(win, in_ch)
    @buff = ''
    case in_ch
    when 0x1b # ^[
      return Handler.new
    else
      @buff << in_ch
    end
  end

end
