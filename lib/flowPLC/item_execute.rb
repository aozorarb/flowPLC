module FlowPLC::ItemExecute
  attr_writer :stage
  module_function :stage=

  # item execute if previous item's state is true
  private def run_enable_item(item)
    include FlowPLC
    case item
    when Item::Output
      item.enable
    when Item::Timer
      item.start
      item.run
    end
  end


  # when previous item's state is false
  private def run_disable_item(item)
    include FlowPLC
    case item
    when Item::Output
      item.disable
    when Item::Timer
      # timer require constant input until count up
      item.reset
    end
  end


  module_function def run
    @stage.data.each_with_index do |flow, flow_idx|
      flow.each_with_index do |item, inflow_idx|
        # item execute if previous item's state is true
        # first item always execute
        if inflow_idx == 0
          run_enable_item(item)
        else
          if @stage.flow_state[flow_idx][inflow_idx-1]
            run_item(item)
          else
            run_disable_item(item)
          end
        end
        # item refresh after it ran
        @stage.flow_state[flow_idx][inflow_idx] = item.state
      end
    end
  end


  module_function def item_exec(flow_idx, inflow_idx, command, *args)
    @stage.item_exec(flow_idx, inflow_idx, command, args)
  end

end
