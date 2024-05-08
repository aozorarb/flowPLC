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

  # error: NoMethodError, ArgumentError, CommandMessage
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
    @logger.warn($!.full_message)
    raise #Exception, $!
  end


  def exit
    # Kernel.exit
    super
  end

  alias :q :exit
  alias :quit :exit

    
  def push_item(flow_idx, item, item_args)    @plc.push_item(flow_idx, item, item_args) end
  def insert_item(flow_idx, inflow_idx, item, item_args) @plc.insert_item(flow_idx, inflow_idx, item, item_args) end
  def new_flow()                                    @plc.new_flow end
  def new_flow_at(flow_idx)                         @plc.new_flow_at(flow_idx) end
  def delete_flow(flow_idx)                         @plc.delete_flow(flow_idx) end
  def delete_item_at(flow_idx, inflow_idx)          @plc.delete_item_at(flow_idx, inflow_idx) end
  def item_name_at(flow_idx, inflow_idx)            @plc.item_name_at(flow_idx, inflow_idx) end
  def delete_item(item_name)                  @plc.delete_item(item_name) end

  def save(filename)
    ret = @plc.save(filename)
    print
      if ret
        "#{filename} saved"
      else
        'Already file exist (save! to overwrite)'
      end
  end

  def save!(filename)
    ret = @plc.save!(filename)
    print
      if ret
        "#{filename} saved (overwrote)"
      else
        'invalid filename, or something wrong'
      end
  end

  alias :w  :save
  alias :w! :save!

  
  def commands
    cmds = public_methods(false).inspect
    @logger.debug(cmds)
    @cmd_win.expand_print(cmds)
  end

  def print(message)
    @cmd_win.print_at(message.to_s, 0, 1)
    @cmd_win.sleep_until_key_type
  end

  def d_print_stage
    msg = @plc.stage.show_state.inspect
    @cmd_win.expand_print(msg)
  end

end
