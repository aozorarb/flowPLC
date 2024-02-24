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
      @plc = flowplc

      Curses.init_screen
      at_exit { Curses.close_screen }
      @flows_win = CLI::FlowsWindow.new
      @cmd_win = CLI::CommandWindow.new
    end


    def start

    end

  end

end


CLI.start
