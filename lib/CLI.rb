require_relative 'flowPLC'
require_relative 'CLI/item_command'
require_relative 'CLI/flows_window'
require_relative 'CLI/command_window'
require 'curses'


module CLI
  def self.start
    plc = FlowPLC::Core.new
    main = CLI::Core.new(plc)
    main.start
  end


  class Core
    def initialize(plc)
      curses_initialize
      @plc = plc

      @flows_win = CLI::FlowsWindow.new(@plc)
      @cmd_win = CLI::CommandWindow.new(@plc)
    end


    def start
      draw_loop
    end


    private def curses_initialize
      Curses.init_screen
      at_exit { Curses.close_screen }

      Curses.noecho
      Curses.cbreak
      curses_color_define
    end


    private def curses_color_define
      Curses.start_color
    end


    private def draw_loop
      while true
        @flows_win.draw
        @cmd_win.draw
        @flows_win.move_cursor
        sleep 0.05 # 20 fps
        ch = @flows_win.getch
        select_action(ch)
        Curses.doupdate
      end
    end


    private def select_action(ch)
      case ch
      when 'q'
        exit(0)
      when ':'
        @cmd_win.enter_command
      end
    end

  end

end


CLI.start
