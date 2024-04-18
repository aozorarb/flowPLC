require 'logger'
require_relative 'error'
require_relative 'command_window'


class CLI::ExecuteCommand
  def initialize(plc)
    @plc = plc
    @logger = Logger.new('log/execute_command.log')
  end
  attr_writer :cmd_win

  # error: NoMethodError, ArgumentError
  def call(command, args)
    public_send(command, args)
  end


  def call(line)
    match_data = line.match(/(?<cmd>\w*) *(?<args>.*)/)
    @logger.debug(match_data)
    cmd, args = match_data[:cmd], match_data[:args]
    args = args.split(',').map(&:strip)
    public_send(cmd, *args)
  rescue # for DEBUG
    raise #Exception, $!
  end


  def exit
    # Kernel.exit
    super
  end

  alias :q :exit
  alias :quit :exit

    
  def push_item(flow_idx, item)               @plc.push_item(flow_idx, item) end
  def insert_item(flow_idx, inflow_idx, item) @plc.insert_item(flow_idx, inflow_idx, item) end
  def new_flow(flow_idx)                      @plc.new_flow(flow_idx) end
  def delete_flow(flow_idx)                   @plc.delete_flow(flow_idx) end
  def delete_item_at(flow_idx, inflow_idx)    @plc.delete_item_at(flow_idx, inflow_idx) end
  def item_name_at(flow_idx, inflow_idx)      @plc.item_name_at(flow_idx, inflow_idx) end
  def delete_item(name)                       @plc.delete_item(name) end
  
  
  def commands
    cmds = public_methods
    @cmd_win.expand_print(cmds)
  end

  def tes
    @cmd_win.print('test')
  end
end
