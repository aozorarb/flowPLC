class PLC

  attr_accessor :inputs
  attr_reader   :outputs

  def initialize(size)
    @inputs = Array.new(size, false)
    @outputs = Array.new(size, false)
  end

  def run
    @inputs.each_with_index do |input, idx|
      @outputs[idx] = input
    end
  end
end

plc = PLC.new(2)
plc.inputs[0] = true
plc.inputs[1] = false

plc.run

puts "Outputs: #{plc.outputs[0]}, #{plc.outputs[1]}"

