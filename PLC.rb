require_relative 'items'

class PLC

  attr_reader   :outputs

  def initialize(amount_io)
    @data = Hash.new
    @outputs = Array.new(amount_io, false)
  end

  def set_item(item, val)
    @data[item] = val
  end

  def run
    @inputs.each_with_index do |inp, idx|
      @outputs[idx] = inp
    end
  end

  def puts_state
    puts "Outputs:"
    pp @outputs
  end
end

plc = PLC.new(2)
plc.set_item(:x0, false)


plc.run

plc.puts_state
