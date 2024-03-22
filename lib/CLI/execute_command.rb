require_relative 'error'

class CLI::ExecuteCommand
  def initialize(plc)
    @plc = plc
  end


  # error: NoMethodError, ArgumentError
  def call(command, args)
    self.public_send(command, args)
  end


  def call(line)
    match_data = line.match(/(?<cmd>\w*) *(?<args>.*)/)
    cmd, args = match_data[:cmd], match_data[:args]
    args = args.split(',').map(&:strip)
    self.public_send(cmd, *args)
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
  
end
