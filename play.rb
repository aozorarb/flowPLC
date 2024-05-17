require_relative 'lib/flowPLC.rb'
require 'debug'
plc = FlowPLC::Core.new

#debug
DStage = plc.instance_variable_get('@stage')
DStageManager = FlowPLC::StageManager.instance_variable_get('@manager')

# play freely!
debugger
if plc.load('test.yml')
  plc.puts_stage
  return
end

plc.new_flow
plc.push_item(0, 'Input', 'inp')
plc.save('test.yml')

