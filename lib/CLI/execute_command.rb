
module CLI
  class InvalidCommandError < Exception;end
end

class CLI::ExecuteCommand
  def initialize(plc)
    @plc = plc
  end

  def call(command)
    self.public_send(command)
  rescue 
    raise InvalidCommandError
  end

  def exit 
    # Kernel.exit
    super
  end
  alias :q :exit
  alias :quit :exit



end
