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
  def item_name_at(flow_idx, inflow_idx) return @stage[flow_idx][inflow_idx].name end
  def delete_item(name) @stage.delete(name) end

  # item execute if previous item's state is true
  def run_item(item)
    case item
    when Item::Output
      item.enable
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
    @stage.show_class
    @stage.show_state
  end

  def puts_state_deep
    @stage.show_detail
    @stage.show_state
  end

  def save(file_name)
    @stage.save(file_name)
  end

  def save!(file_name)
    @stage.save(file_name, overwrite: true)
  end

  def load(file_name)
    @stage.load(file_name)
  end

  # there methods for access to items
  # Item::Input
  def input_turn_on(name)
    @stage.item_exec(name, 'on')
  end
end
