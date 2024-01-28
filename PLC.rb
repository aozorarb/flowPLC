require_relative 'items'
require_relative 'stage'

class PLC

  attr_accessor :inputs, :timers

  def initialize(amount_io, amount_timer)
    @stage = Stage.new
    @inputs = Array.new(amount_io) { Item::Input.new }
    @outputs = Array.new(amount_io, false)
    @timers = Array.new(amount_timer) { Item::Timer.new }
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

  def timer_run
    @inputs.each_with_index do |inp, idx|
      @timers[idx].start if inp
      @timers[idx].run
    end
  end

  def run
    timer_run
    @timers.each_with_index do |timer, idx|
      @outputs[idx] = timer.state
    end
  end

  def puts_state
    puts "Outputs:"
    pp @outputs
  end
end

plc = PLC.new(1, 1)
plc.inputs[0].state = true
plc.timers[0].time = 10

plc.run
plc.puts_state
10.times { plc.run }
plc.puts_state
