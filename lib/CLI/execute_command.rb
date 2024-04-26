require 'logger'
require_relative 'error'
require_relative 'command_window'
require_relative '../flowPLC/item'


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

    
  private def item_name2class(item_class_name)
    # FIXME: use other class create method for security
    include FlowPLC::Item
    eval("klass = #{item_class_name}.new")
    klass
  end

  def push_item(flow_idx, item_class)    @plc.push_item(flow_idx, item_name2class(item_class)) end
  def insert_item(flow_idx, inflow_idx, item_class) @plc.insert_item(flow_idx, inflow_idx, item_class) end
  def new_flow(flow_idx)                      @plc.new_flow(flow_idx) end
  def delete_flow(flow_idx)                   @plc.delete_flow(flow_idx) end
  def delete_item_at(flow_idx, inflow_idx)    @plc.delete_item_at(flow_idx, inflow_idx) end
  def item_name_at(flow_idx, inflow_idx)      @plc.item_name_at(flow_idx, inflow_idx) end
  def delete_item(item_name)                       @plc.delete_item(item_name) end
  
  
  def commands
    cmds = public_methods(false).inspect
    @logger.debug(cmds)
    @cmd_win.expand_print(cmds)
  end

  def test
    @cmd_win.print_at('test', 0, 1)
    @cmd_win.sleep_until_key_type
  end
end
