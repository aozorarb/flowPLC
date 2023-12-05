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
  cmd_win =  CommandWindow.instance
  cmd_win.set_win(main_win)
  handler = Handler.new
  Colors::init_colors
  edit_win.display_loop

  while true
    ch = edit_win.getch
    handler = handler.execute(edit_win, ch)
    edit_win.move_refresh
  end
end

Curses.init_screen
Curses.cbreak
Curses.noecho
Curses.start_color
at_exit do
  Curses.close_screen
end

main()

