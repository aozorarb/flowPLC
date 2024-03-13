require_relative 'error'

class CLI::ExecuteCommand
  def initialize(plc)
    @plc = plc
  end


  def call(command)
    self.public_send(command)
  rescue 
    raise CLI::InvalidCommandError
  end


  def exit 
    # Kernel.exit
    super
  end
  alias :q :exit
  alias :quit :exit



end
