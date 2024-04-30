require 'curses'
require 'logger'
require_relative 'flowPLC'
require_relative 'CLI/execute_command'
require_relative 'CLI/flows_window'
require_relative 'CLI/command_window'
require_relative 'CLI/color'

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
      @exec_command = CLI::ExecuteCommand.new(@plc)
      @flows_win = CLI::FlowsWindow.new(@plc, @exec_command)
      @cmd_win = CLI::CommandWindow.new(@plc, @exec_command)
      @exec_command.cmd_win = @cmd_win
      @logger = Logger.new('log/core.log')
    end


    def start
      draw_loop
    end


    private def curses_initialize
      Curses.init_screen
      at_exit do 
        Curses.close_screen
        CLI::Color.finalize
      end
      Curses.noecho
      Curses.cbreak
      curses_color_define
    end


    private def curses_color_define
      Curses.start_color
      CLI::Color.initialize
    end

    private def draw
      @flows_win.draw
      @cmd_win.draw
    end

    private def draw_loop
      while true
        draw
        @flows_win.move_cursor
        sleep 0.05 # 20 fps
        ch = @flows_win.getch
        select_action(ch)
        Curses.doupdate
      end
    end


    private def select_action(ch)
      case ch
      when ':'
        @cmd_win.enter_command
      end
    end
  end
end


CLI.start
