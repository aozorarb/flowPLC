require_relative 'lib/miniPLC.rb'
plc = MiniPLC::Core.new

#debug
DStage = plc.instance_variable_get('@stage')
DStageManager = Stage.instance_variable_get('@manager')
NUM = 1

# play freely!
plc.new_flow(Item::Input.new('in01'))
plc.push(0, Item::Timer.new('timer', 10))
plc.push(0, Item::Output.new('out01'))
plc.input_turn_on('in01')
plc.puts_state_deep


