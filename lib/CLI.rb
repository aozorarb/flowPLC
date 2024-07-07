require_relative 'CLI/core'
module CLI
  def self.start
    plc = FlowPLC::Core.new
    main = CLI::Core.new(plc)
    main.start
  end
end
  

CLI.start
