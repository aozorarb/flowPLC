require 'curses'
require_relative 'edit_window'
require_relative 'stage'
require_relative 'command_window'
require_relative 'handler'
require_relative 'config'

# main
def main
  main_window = Curses.stdscr
  edit_window = EditWindow.new(main_window)
  command_window = CommandWindow.new(main_window)
  handler = Handler.new
  Config::Colors::init_colors
  edit_window.display_loop

  while true
    ch = edit_window.getch
    handler = handler.execute(edit_window, ch)
  end
end

Curses.init_screen
Curses.cbreak
Curses.noecho
Curses.start_color

main()
Curses.close_screen
