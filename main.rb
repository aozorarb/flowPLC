require 'curses'
require_relative 'edit_window'
require_relative 'stage'
require_relative 'command_window'
require_relative 'handler'
require_relative 'config'
require_relative 'colors'

# main
def main
  main_win = Curses.stdscr
  edit_win = EditWindow.new(main_win)
  cmd_win  =  CommandWindow.instance
  cmd_win.set_win(main_win)
  conf = Config.instance
  handler = Handler.new

  while true
    sleep (1.0 / conf.get('fps'))
    edit_win.display
    ch = edit_win.getch
    handler = handler.execute(edit_win, ch)
  end
end

Curses.init_screen
Curses.cbreak
Curses.noecho
Curses.start_color
Colors::init_colors
at_exit do
  Curses.close_screen
end

main()

