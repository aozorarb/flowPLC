require_relative 'flowPLC'
require_relative 'CLI/item_command'
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
    end


    def start

    end

  end

end


CLI.start
