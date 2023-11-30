require_relative 'edit_window'
require_relative 'command_window'

class BasicHandler
  private

  def set_mode(mode_name)
    # show first line
    raise 'define mode_name' if mode_name.nil?
    CommandWindow.instance.clear
    CommandWindow.instance.show_msg(mode_name, 0, 0)
  end

  def execute
    raise 'no implement'
  end

end

class Handler < BasicHandler

  def initialize
    set_mode 'NORMAL'
  end

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

class EditHandler < BasicHandler
  def initialize
    set_mode 'EDIT'
  end

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
