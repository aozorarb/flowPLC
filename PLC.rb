require_relative 'items'
require_relative 'stage'

class PLC

  def initialize
    @stage = Stage.new
  end

  # access Stage
  def push(idx, item)  @stage.push(idx, item) end
  def insert(flow_idx, inflow_idx, item) @stage.insert(flow_idx, inflow_idx, item) end
  def new_flow(item)   @stage.new_flow(item) end
  def delete_flow(idx) @stage.delete_flow(idx) end
  def delete_at(idx, inflow_idx) @stage.delete_at(idx, inflow_idx) end

  def item_exec(item, flow_idx, inflow_idx)
    item_state = @stage.flow_state[flow_idx][inflow_idx]
    case item.class
    when Item::Input
      item_state = item.state
    when Item::Output
      item_state = 
    when Item::Timer
  end

  def run
    @stage.data.each_with_index do |flow, flow_idx|
      flow.each_with_index do |item, inflow_idx|
        # when flow first, always previous is true
        if flow_idx == 0
          item_exec(item, flow_idx, inflow_idx)
        else
          if @stage.flow_state[flow_idx][inflow_idx-1]
            item_exec(item, flow_idx, inflow_idx)
          end
        end
      end
    end
  end

  def puts_state
    @stage.show
    @stage.show_state
  end
end

plc = PLC.new
plc.new_flow(Item::Input.new('in01'))
plc.push(0, Item::Timer.new('timer', 10))
plc.push(0, Item::Output.new('out01'))
plc.puts_state
