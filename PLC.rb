require_relative 'items'
require_relative 'stage'

class PLC

  def initialize(amount_io)
    @stage = Stage.new
  end

  def push(idx, item)
    @stage.push(idx, item)
  end
  
  def insert(flow_idx, inflow_idx, item)
    @stage.insert(flow_idx, inflow_idx, item)
  end

  def new_flow(item)
    @stage.new_flow(item)
  end

  def run
    @stage.each do |flow|
      flow.each do |item|
        item.run
      end
    end
  end

  def puts_state
    @stage.show
  end
end

plc = PLC.new(1)
plc.new_flow(Item::Input.new('in01'))
plc.push(0, Item::Timer.new('timer', 10))
plc.puts_state
