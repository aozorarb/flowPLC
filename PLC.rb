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

  def run_item(item)
    case item.class
    when Item::Input
    when Item::Output
    when Item::Timer
      item.start
    end
  end

  def run
    @stage.data.each_with_index do |flow, flow_idx|
      flow.each_with_index do |item, inflow_idx|
        # item execute if previous item's state is true
        # first item always execute
        if flow_idx == 0
          run_item(item, flow_idx, inflow_idx)
        else
          if @stage.flow_state[flow_idx][inflow_idx-1]
            run_item(item, flow_idx, inflow_idx)
          end
        end
        # item refresh after item ran
        @stage.flow_state[flow_idx][inflow_idx] = item.state
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
