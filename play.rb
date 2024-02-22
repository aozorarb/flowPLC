require_relative 'lib/flowPLC.rb'
plc = FlowPLC::Core.new

#debug
DStage = plc.instance_variable_get('@stage')
DStageManager = FlowPLC::StageManager.instance_variable_get('@manager')

# play freely!
include FlowPLC
plc.new_flow(Item::Input.new('in01'))
plc.push(0, Item::Timer.new('timer', 10))
plc.push(0, Item::Output.new('out01'))
plc.puts_state

