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

  # item execute if previous item's state is true
  def run_item(item)
    case item
    when Item::Output
      item.on
    when Item::Timer
      item.start
      item.run
    end
  end

  # when previous item's state is false
  def disable_run_item(item)
    case item
    when Item::Output
      item.disable
    when Item::Timer
      # timer require constant input until count ok
      item.reset_stop
    end
  end

  def run
    @stage.data.each_with_index do |flow, flow_idx|
      flow.each_with_index do |item, inflow_idx|
        # item execute if previous item's state is true
        # first item always execute
        if inflow_idx == 0
          run_item(item)
        else
          if @stage.flow_state[flow_idx][inflow_idx-1]
            run_item(item)
          else
            disable_run_item(item)
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

  def puts_state_deep
    @stage.show_detail
    @stage.show_state
  end

  
  # there methods for access to items
end
