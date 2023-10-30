require 'curses'
require_relative 'edit_window'
require_relative 'stage'
require_relative 'command_window'
require_relative 'handler'
require_relative 'config'

# main
def main
  main_win = Curses.stdscr
  edit_win = EditWindow.new(main_win)
  cmd_win =  CommandWindow.instance
  cmd_win.set_win(main_win)
  handler = Handler.new
  Config::Colors::init_colors
  edit_win.display_loop

  while true
    ch = edit_win.getch
    handler = handler.execute(edit_win, ch)
  end
end

Curses.init_screen
Curses.cbreak
Curses.noecho
Curses.start_color

main()
Curses.close_screen
